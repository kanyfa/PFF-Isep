import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../../utils/theme.dart';
import '../../utils/demo_images.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotifications();
    });
  }

  Future<void> _loadNotifications() async {
    final authService = context.read<AuthService>();
    final notificationService = context.read<NotificationService>();
    
    if (authService.currentUser != null) {
      await notificationService.loadUserNotifications(authService.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: Text(
          'Administration',
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
          Consumer<NotificationService>(
            builder: (context, notificationService, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_rounded),
                    onPressed: () => context.go('/notifications'),
                  ),
                  if (notificationService.unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.errorRed,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${notificationService.unreadCount}',
                          style: AppTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<AuthService>(
        builder: (context, authService, child) {
          if (authService.currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = authService.currentUser!;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // En-tête administrateur
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: AppTheme.cardDecoration,
                  child: Column(
                    children: [
                      DemoImages.buildProfileImage(
                        name: user.prenom,
                        size: 100,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '${user.prenom} ${user.nom}',
                        style: AppTheme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.errorRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.errorRed),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.admin_panel_settings_rounded,
                              color: AppTheme.errorRed,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Administrateur',
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.errorRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Statistiques
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Utilisateurs',
                        value: '156',
                        subtitle: 'Total inscrits',
                        icon: Icons.people_rounded,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Annonces',
                        value: '89',
                        subtitle: 'Documents signalés',
                        icon: Icons.description_rounded,
                        color: AppTheme.successGreen,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Récupérés',
                        value: '67',
                        subtitle: 'Documents retrouvés',
                        icon: Icons.check_circle_rounded,
                        color: AppTheme.successGreen,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Taux',
                        value: '75%',
                        subtitle: 'Taux de récupération',
                        icon: Icons.trending_up_rounded,
                        color: AppTheme.warningOrange,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Actions d'administration
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: AppTheme.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Actions d\'administration',
                        style: AppTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      _buildActionTile(
                        icon: Icons.people_rounded,
                        title: 'Gérer les utilisateurs',
                        subtitle: 'Voir et gérer tous les utilisateurs',
                        onTap: () => context.go('/admin/users'),
                      ),
                      
                      _buildActionTile(
                        icon: Icons.description_rounded,
                        title: 'Modérer les annonces',
                        subtitle: 'Valider et gérer les annonces',
                        onTap: () => context.go('/admin/annonces'),
                      ),
                      
                      _buildActionTile(
                        icon: Icons.analytics_rounded,
                        title: 'Statistiques',
                        subtitle: 'Voir les statistiques détaillées',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Fonctionnalité en cours de développement'),
                              backgroundColor: AppTheme.infoBlue,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      _buildActionTile(
                        icon: Icons.settings_rounded,
                        title: 'Paramètres',
                        subtitle: 'Configurer l\'application',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Fonctionnalité en cours de développement'),
                              backgroundColor: AppTheme.infoBlue,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.mediumGrey,
        backgroundColor: AppTheme.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_rounded),
            label: 'Annonces',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_rounded),
            label: 'Admin',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/search');
              break;
            case 2:
              context.go('/notifications');
              break;
            case 3:
              context.go('/admin');
              break;
          }
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: AppTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.mediumGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryBlue,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.textTheme.bodyMedium,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: AppTheme.mediumGrey,
      ),
      onTap: onTap,
    );
  }
}