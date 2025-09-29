import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../services/annonce_service.dart';
import '../../services/auth_service.dart';
import '../../services/historique_service.dart';
import '../../utils/theme.dart';
import '../../models/annonce.dart';
import '../../models/historique.dart';

class AnnonceHistoryScreen extends StatefulWidget {
  const AnnonceHistoryScreen({super.key});

  @override
  State<AnnonceHistoryScreen> createState() => _AnnonceHistoryScreenState();
}

class _AnnonceHistoryScreenState extends State<AnnonceHistoryScreen> {
  List<Annonce> _myAnnonces = [];
  List<Historique> _history = [];
  bool _isLoading = false;
  String _selectedFilter = 'all'; // all, active, found, deleted

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = context.read<AuthService>();
      final annonceService = context.read<AnnonceService>();
      final historiqueService = context.read<HistoriqueService>();
      
      if (authService.currentUser != null) {
        // Charger les annonces de l'utilisateur
        final annonces = await annonceService.getAnnoncesByUser(authService.currentUser!.id);
        
        // Charger l'historique des actions liées aux annonces
        final historique = await historiqueService.getHistoriqueUtilisateur(authService.currentUser!.id);
        final annonceHistory = historique.where((h) => 
          h.action == TypeAction.creationAnnonce ||
          h.action == TypeAction.modificationAnnonce ||
          h.action == TypeAction.suppressionAnnonce
        ).toList();
        
        setState(() {
          _myAnnonces = annonces;
          _history = annonceHistory;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<Annonce> get _filteredAnnonces {
    switch (_selectedFilter) {
      case 'active':
        return _myAnnonces.where((a) => a.statut == StatutAnnonce.perdu || a.statut == StatutAnnonce.enRecherche).toList();
      case 'found':
        return _myAnnonces.where((a) => a.statut == StatutAnnonce.trouve).toList();
      case 'deleted':
        // Les annonces supprimées ne sont plus dans _myAnnonces, on les trouve dans l'historique
        return [];
      default:
        return _myAnnonces;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: Text(
          'Historique des annonces',
          style: AppTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.white),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistiques rapides
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.cardDecoration,
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    '${_myAnnonces.length}',
                    Icons.description,
                    AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Actives',
                    '${_myAnnonces.where((a) => a.statut == StatutAnnonce.perdu || a.statut == StatutAnnonce.enRecherche).length}',
                    Icons.search,
                    AppTheme.warningOrange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Trouvées',
                    '${_myAnnonces.where((a) => a.statut == StatutAnnonce.trouve).length}',
                    Icons.check_circle,
                    AppTheme.successGreen,
                  ),
                ),
              ],
            ),
          ),

          // Filtres
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('Toutes', 'all'),
                _buildFilterChip('Actives', 'active'),
                _buildFilterChip('Trouvées', 'found'),
                _buildFilterChip('Supprimées', 'deleted'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Contenu principal
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _selectedFilter == 'deleted'
                    ? _buildDeletedHistory()
                    : _buildAnnoncesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTheme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.mediumGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
        selectedColor: AppTheme.primaryBlue.withOpacity(0.2),
        checkmarkColor: AppTheme.primaryBlue,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryBlue : AppTheme.mediumGrey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildAnnoncesList() {
    if (_filteredAnnonces.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: AppTheme.mediumGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune annonce trouvée',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.mediumGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vous n\'avez pas encore publié d\'annonces',
              style: AppTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGrey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredAnnonces.length,
        itemBuilder: (context, index) {
          final annonce = _filteredAnnonces[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildAnnonceCard(annonce),
          );
        },
      ),
    );
  }

  Widget _buildAnnonceCard(Annonce annonce) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: InkWell(
        onTap: () => context.go('/annonce-details/${annonce.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Image ou icône
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: annonce.photoUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              annonce.photoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.description,
                                  color: AppTheme.primaryBlue,
                                  size: 30,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.description,
                            color: AppTheme.primaryBlue,
                            size: 30,
                          ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Informations
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          annonce.titre,
                          style: AppTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          annonce.description,
                          style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.mediumGrey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildStatusChip(annonce.statut),
                            const Spacer(),
                            Text(
                              DateFormat('dd/MM/yyyy').format(annonce.dateCreation),
                              style: AppTheme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.mediumGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Boutons d'action
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                'Détail',
                                Icons.visibility,
                                AppTheme.infoBlue,
                                () => context.go('/annonce/${annonce.id}'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildActionButton(
                                'Modifier',
                                Icons.edit,
                                AppTheme.warningOrange,
                                () => _editAnnonce(annonce),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildActionButton(
                                'Supprimer',
                                Icons.delete,
                                AppTheme.errorRed,
                                () => _deleteAnnonce(annonce),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildStatusChip(StatutAnnonce statut) {
    Color color;
    String label;
    IconData icon;

    switch (statut) {
      case StatutAnnonce.perdu:
        color = AppTheme.warningOrange;
        label = 'Perdu';
        icon = Icons.search;
        break;
      case StatutAnnonce.enRecherche:
        color = AppTheme.primaryBlue;
        label = 'En recherche';
        icon = Icons.visibility;
        break;
      case StatutAnnonce.trouve:
        color = AppTheme.successGreen;
        label = 'Trouvé';
        icon = Icons.check_circle;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeletedHistory() {
    final deletedActions = _history.where((h) => h.action == TypeAction.suppressionAnnonce).toList();
    
    if (deletedActions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline,
              size: 64,
              color: AppTheme.mediumGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune annonce supprimée',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.mediumGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vous n\'avez supprimé aucune annonce',
              style: AppTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGrey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: deletedActions.length,
        itemBuilder: (context, index) {
          final action = deletedActions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildHistoryCard(action),
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(Historique action) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                action.action.icon,
                color: AppTheme.errorRed,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.description,
                    style: AppTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    action.action.label,
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd/MM/yyyy à HH:mm').format(action.dateAction),
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: AppTheme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
      ),
    );
  }

  Future<void> _editAnnonce(Annonce annonce) async {
    // TODO: Implémenter la modification d'annonce
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Modification de "${annonce.titre}" - Fonctionnalité à venir'),
        backgroundColor: AppTheme.warningOrange,
      ),
    );
  }

  Future<void> _deleteAnnonce(Annonce annonce) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer l\'annonce "${annonce.titre}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final annonceService = context.read<AnnonceService>();
        await annonceService.deleteAnnonce(annonce.id);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Annonce "${annonce.titre}" supprimée avec succès'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
        
        _loadData(); // Recharger les données
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }
}
