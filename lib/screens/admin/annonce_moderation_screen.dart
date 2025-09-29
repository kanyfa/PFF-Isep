import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/annonce_service.dart';
import '../../utils/theme.dart';
import '../../utils/demo_images.dart';
import '../../models/annonce.dart';

class AnnonceModerationScreen extends StatefulWidget {
  const AnnonceModerationScreen({super.key});

  @override
  State<AnnonceModerationScreen> createState() => _AnnonceModerationScreenState();
}

class _AnnonceModerationScreenState extends State<AnnonceModerationScreen> {
  List<Annonce> _annonces = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnnonces();
  }

  Future<void> _loadAnnonces() async {
    setState(() => _isLoading = true);
    
    try {
      final annonceService = context.read<AnnonceService>();
      final annonces = await annonceService.getAllAnnonces();
      setState(() {
        _annonces = annonces;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: Text(
          'Modération des annonces',
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
          onPressed: () => context.go('/admin'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadAnnonces,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Statistiques
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.cardDecoration,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatItem('Total', '${_annonces.length}', AppTheme.primaryBlue),
                      ),
                      Expanded(
                        child: _buildStatItem('En attente', '${_annonces.where((a) => a.statut == StatutAnnonce.perdu).length}', AppTheme.warningOrange),
                      ),
                      Expanded(
                        child: _buildStatItem('Trouvés', '${_annonces.where((a) => a.statut == StatutAnnonce.trouve).length}', AppTheme.successGreen),
                      ),
                    ],
                  ),
                ),
                
                // Liste des annonces
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _annonces.length,
                    itemBuilder: (context, index) {
                      final annonce = _annonces[index];
                      return _buildAnnonceCard(annonce);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.mediumGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildAnnonceCard(Annonce annonce) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Image du document
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _getStatutColor(annonce.statut).withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: DemoImages.buildDocumentImage(
                    documentType: annonce.typeDocument.name,
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Informations de l'annonce
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      annonce.titre,
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Type: ${_getDocumentLabel(annonce.typeDocument)}',
                      style: AppTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.mediumGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lieu: ${annonce.lieuPerte}',
                      style: AppTheme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatutColor(annonce.statut).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _getStatutColor(annonce.statut)),
                          ),
                          child: Text(
                            _getStatutLabel(annonce.statut),
                            style: AppTheme.textTheme.bodySmall?.copyWith(
                              color: _getStatutColor(annonce.statut),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(annonce.dateCreation),
                          style: AppTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.mediumGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Actions
              PopupMenuButton<String>(
                onSelected: (action) => _handleAnnonceAction(action, annonce),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility_rounded, color: AppTheme.primaryBlue),
                        SizedBox(width: 8),
                        Text('Voir détails'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'validate',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_rounded, color: AppTheme.successGreen),
                        SizedBox(width: 8),
                        Text('Valider'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'reject',
                    child: Row(
                      children: [
                        Icon(Icons.cancel_rounded, color: AppTheme.errorRed),
                        SizedBox(width: 8),
                        Text('Rejeter'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_rounded, color: AppTheme.errorRed),
                        SizedBox(width: 8),
                        Text('Supprimer'),
                      ],
                    ),
                  ),
                ],
                child: const Icon(
                  Icons.more_vert_rounded,
                  color: AppTheme.mediumGrey,
                ),
              ),
            ],
          ),
          
          if (annonce.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              annonce.description,
              style: AppTheme.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  void _handleAnnonceAction(String action, Annonce annonce) {
    switch (action) {
      case 'view':
        _showAnnonceDetails(annonce);
        break;
      case 'validate':
        _validateAnnonce(annonce);
        break;
      case 'reject':
        _rejectAnnonce(annonce);
        break;
      case 'delete':
        _deleteAnnonce(annonce);
        break;
    }
  }

  void _showAnnonceDetails(Annonce annonce) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(annonce.titre),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type: ${_getDocumentLabel(annonce.typeDocument)}'),
              Text('Lieu: ${annonce.lieuPerte}'),
              Text('Date de perte: ${_formatDate(annonce.datePerte)}'),
              Text('Statut: ${_getStatutLabel(annonce.statut)}'),
              if (annonce.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Description: ${annonce.description}'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _validateAnnonce(Annonce annonce) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Valider l\'annonce'),
        content: Text('Êtes-vous sûr de vouloir valider l\'annonce "${annonce.titre}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Annonce "${annonce.titre}" validée'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.successGreen),
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  void _rejectAnnonce(Annonce annonce) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rejeter l\'annonce'),
        content: Text('Êtes-vous sûr de vouloir rejeter l\'annonce "${annonce.titre}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Annonce "${annonce.titre}" rejetée'),
                  backgroundColor: AppTheme.errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('Rejeter'),
          ),
        ],
      ),
    );
  }

  void _deleteAnnonce(Annonce annonce) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'annonce'),
        content: Text('Êtes-vous sûr de vouloir supprimer définitivement l\'annonce "${annonce.titre}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _annonces.remove(annonce);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Annonce "${annonce.titre}" supprimée'),
                  backgroundColor: AppTheme.errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  Color _getStatutColor(StatutAnnonce statut) {
    switch (statut) {
      case StatutAnnonce.perdu:
        return AppTheme.warningOrange;
      case StatutAnnonce.trouve:
        return AppTheme.successGreen;
      case StatutAnnonce.enRecherche:
        return AppTheme.primaryBlue;
    }
  }

  String _getStatutLabel(StatutAnnonce statut) {
    switch (statut) {
      case StatutAnnonce.perdu:
        return 'Perdu';
      case StatutAnnonce.trouve:
        return 'Trouvé';
      case StatutAnnonce.enRecherche:
        return 'En recherche';
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}


