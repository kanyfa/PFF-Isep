import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/annonce_service.dart';
import '../../utils/theme.dart';
import '../../utils/demo_images.dart';
import '../../models/annonce.dart';

class FoundDocumentsScreen extends StatefulWidget {
  const FoundDocumentsScreen({super.key});

  @override
  State<FoundDocumentsScreen> createState() => _FoundDocumentsScreenState();
}

class _FoundDocumentsScreenState extends State<FoundDocumentsScreen> {
  List<Annonce> _foundDocuments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFoundDocuments();
  }

  Future<void> _loadFoundDocuments() async {
    try {
      final annonceService = context.read<AnnonceService>();
      final documents = await annonceService.getFoundDocumentsNearby();
      setState(() {
        _foundDocuments = documents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement: $e'),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: Text(
          'Documents trouvés près de vous',
          style: AppTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.darkGrey,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadFoundDocuments,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _foundDocuments.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadFoundDocuments,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _foundDocuments.length,
                    itemBuilder: (context, index) {
                      final document = _foundDocuments[index];
                      return _buildDocumentCard(document);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppTheme.mediumGrey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun document trouvé',
            style: AppTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Aucun document n\'a été trouvé près de vous\npour le moment',
            style: AppTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.mediumGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.go('/search'),
            icon: const Icon(Icons.search_rounded),
            label: const Text('Rechercher des documents'),
            style: AppTheme.primaryButtonStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(Annonce document) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppTheme.cardDecoration,
      child: InkWell(
        onTap: () => context.go('/annonce/${document.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Icône du type de document avec image
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: _getDocumentColor(document.typeDocument).withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: DemoImages.buildDocumentImage(
                            documentType: document.typeDocument.name,
                            width: 60,
                            height: 60,
                          ),
                        ),
                      ),
                  const SizedBox(width: 16),
                  
                  // Informations principales
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getDocumentLabel(document.typeDocument),
                          style: AppTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Propriétaire: ${document.titre}',
                          style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.mediumGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Distance
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.successGreen),
                    ),
                    child: Text(
                      '${_getRandomDistance()}km',
                      style: AppTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Lieu de trouvaille
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 16,
                    color: AppTheme.mediumGrey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getSenegalLocation(),
                      style: AppTheme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Trouvé par
              Row(
                children: [
                  Icon(
                    Icons.person_rounded,
                    size: 16,
                    color: AppTheme.mediumGrey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Trouvé par ${_getRandomName()}',
                    style: AppTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/annonce/${document.id}'),
                      icon: const Icon(Icons.visibility_rounded),
                      label: const Text('Voir détails'),
                      style: AppTheme.secondaryButtonStyle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _contactFinder(document),
                      icon: const Icon(Icons.message_rounded),
                      label: const Text('Contacter'),
                      style: AppTheme.primaryButtonStyle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _contactFinder(Annonce document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Contacter le trouveur',
          style: AppTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Voulez-vous contacter la personne qui a trouvé ce document ?',
          style: AppTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Annuler',
              style: AppTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGrey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Ouvrir la messagerie
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Ouverture de la messagerie...'),
                  backgroundColor: AppTheme.successGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: AppTheme.primaryButtonStyle,
            child: const Text('Contacter'),
          ),
        ],
      ),
    );
  }

  Color _getDocumentColor(TypeDocument type) {
    switch (type) {
      case TypeDocument.carteIdentite:
        return AppTheme.primaryBlue;
      case TypeDocument.passeport:
        return AppTheme.successGreen;
      case TypeDocument.permisConduire:
        return AppTheme.warningOrange;
      case TypeDocument.carteVitale:
        return AppTheme.errorRed;
      case TypeDocument.carteEtudiant:
        return AppTheme.primaryBlue;
      case TypeDocument.autre:
        return AppTheme.mediumGrey;
    }
  }

  String _getDocumentLabel(TypeDocument type) {
    switch (type) {
      case TypeDocument.carteIdentite:
        return 'Carte d\'identité';
      case TypeDocument.passeport:
        return 'Passeport';
      case TypeDocument.permisConduire:
        return 'Permis de conduire';
      case TypeDocument.carteVitale:
        return 'Carte Vitale';
      case TypeDocument.carteEtudiant:
        return 'Carte étudiant';
      case TypeDocument.autre:
        return 'Autre';
    }
  }

  String _getRandomDistance() {
    final distances = ['0.8', '1.2', '2.5', '3.1', '4.7', '5.2'];
    return distances[DateTime.now().millisecondsSinceEpoch % distances.length];
  }

  String _getSenegalLocation() {
    final locations = [
      'Métro Liberté, Dakar',
      'Université Cheikh Anta Diop',
      'Marché Sandaga',
      'Place de l\'Indépendance',
      'Aéroport Léopold Sédar Senghor',
      'Gare routière de Dakar',
      'Hôpital Principal',
      'Centre commercial Almadies',
      'Plage de Yoff',
      'Mosquée de la Divinité',
    ];
    return locations[DateTime.now().millisecondsSinceEpoch % locations.length];
  }

  String _getRandomName() {
    final names = [
      'Aminata D.',
      'Moussa B.',
      'Fatou S.',
      'Ibrahima T.',
      'Aïcha M.',
      'Cheikh K.',
      'Mariama F.',
      'Ousmane N.',
      'Khadija L.',
      'Mamadou C.',
    ];
    return names[DateTime.now().millisecondsSinceEpoch % names.length];
  }
}
