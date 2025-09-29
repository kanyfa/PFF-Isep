import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../services/annonce_service.dart';
import '../../utils/theme.dart';
import '../../utils/demo_images.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    
    // Simuler le chargement des utilisateurs
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _users = [
        {
          'id': 'user1',
          'nom': 'Sow',
          'prenom': 'Moussa',
          'email': 'moussa@senpapier.sn',
          'role': 'user',
          'status': 'active',
          'dateCreation': DateTime.now().subtract(const Duration(days: 10)),
        },
        {
          'id': 'user2',
          'nom': 'Ndiaye',
          'prenom': 'Fatou',
          'email': 'fatou@senpapier.sn',
          'role': 'ramasseur',
          'status': 'active',
          'dateCreation': DateTime.now().subtract(const Duration(days: 5)),
        },
        {
          'id': 'user3',
          'nom': 'Diop',
          'prenom': 'Amadou',
          'email': 'amadou@senpapier.sn',
          'role': 'admin',
          'status': 'active',
          'dateCreation': DateTime.now().subtract(const Duration(days: 30)),
        },
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: Text(
          'Gestion des utilisateurs',
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
                        child: _buildStatItem('Total', '${_users.length}', AppTheme.primaryBlue),
                      ),
                      Expanded(
                        child: _buildStatItem('Actifs', '${_users.where((u) => u['status'] == 'active').length}', AppTheme.successGreen),
                      ),
                      Expanded(
                        child: _buildStatItem('Bloqués', '${_users.where((u) => u['status'] == 'blocked').length}', AppTheme.errorRed),
                      ),
                    ],
                  ),
                ),
                
                // Liste des utilisateurs
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return _buildUserCard(user);
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

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          // Photo de profil
          DemoImages.buildProfileImage(
            name: user['prenom'],
            size: 50,
          ),
          const SizedBox(width: 16),
          
          // Informations utilisateur
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user['prenom']} ${user['nom']}',
                  style: AppTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user['email'],
                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.mediumGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRoleColor(user['role']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _getRoleColor(user['role'])),
                      ),
                      child: Text(
                        _getRoleLabel(user['role']),
                        style: AppTheme.textTheme.bodySmall?.copyWith(
                          color: _getRoleColor(user['role']),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: user['status'] == 'active' 
                            ? AppTheme.successGreen.withOpacity(0.1)
                            : AppTheme.errorRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: user['status'] == 'active' 
                              ? AppTheme.successGreen
                              : AppTheme.errorRed,
                        ),
                      ),
                      child: Text(
                        user['status'] == 'active' ? 'Actif' : 'Bloqué',
                        style: AppTheme.textTheme.bodySmall?.copyWith(
                          color: user['status'] == 'active' 
                              ? AppTheme.successGreen
                              : AppTheme.errorRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Actions
          PopupMenuButton<String>(
            onSelected: (action) => _handleUserAction(action, user),
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
              PopupMenuItem(
                value: user['status'] == 'active' ? 'block' : 'unblock',
                child: Row(
                  children: [
                    Icon(
                      user['status'] == 'active' 
                          ? Icons.block_rounded 
                          : Icons.check_circle_rounded,
                      color: user['status'] == 'active' 
                          ? AppTheme.errorRed 
                          : AppTheme.successGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(user['status'] == 'active' ? 'Bloquer' : 'Débloquer'),
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
    );
  }

  void _handleUserAction(String action, Map<String, dynamic> user) {
    switch (action) {
      case 'view':
        _showUserDetails(user);
        break;
      case 'block':
        _blockUser(user);
        break;
      case 'unblock':
        _unblockUser(user);
        break;
      case 'delete':
        _deleteUser(user);
        break;
    }
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Détails de ${user['prenom']} ${user['nom']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${user['email']}'),
            Text('Rôle: ${_getRoleLabel(user['role'])}'),
            Text('Statut: ${user['status'] == 'active' ? 'Actif' : 'Bloqué'}'),
            Text('Date d\'inscription: ${_formatDate(user['dateCreation'])}'),
          ],
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

  void _blockUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bloquer l\'utilisateur'),
        content: Text('Êtes-vous sûr de vouloir bloquer ${user['prenom']} ${user['nom']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                user['status'] = 'blocked';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user['prenom']} ${user['nom']} a été bloqué'),
                  backgroundColor: AppTheme.errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('Bloquer'),
          ),
        ],
      ),
    );
  }

  void _unblockUser(Map<String, dynamic> user) {
    setState(() {
      user['status'] = 'active';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${user['prenom']} ${user['nom']} a été débloqué'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _deleteUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'utilisateur'),
        content: Text('Êtes-vous sûr de vouloir supprimer définitivement ${user['prenom']} ${user['nom']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _users.remove(user);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user['prenom']} ${user['nom']} a été supprimé'),
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

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return AppTheme.errorRed;
      case 'ramasseur':
        return AppTheme.warningOrange;
      case 'user':
      default:
        return AppTheme.primaryBlue;
    }
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'admin':
        return 'Administrateur';
      case 'ramasseur':
        return 'Ramasseur';
      case 'user':
      default:
        return 'Utilisateur';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}


