import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../../utils/theme.dart';
import '../../utils/demo_images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildStatsCards(),
                  _buildRecentActivity(),
                  const SizedBox(height: 100), // Espace pour le FAB
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Photo de profil
              Consumer<AuthService>(
                builder: (context, authService, child) {
                  final user = authService.currentUser;
                  return DemoImages.buildProfileImage(
                    name: user?.prenom ?? 'Utilisateur',
                    size: 50,
                  );
                },
              ),
              const SizedBox(width: 16),
              
              // Salutation
              Expanded(
                child: Consumer<AuthService>(
                  builder: (context, authService, child) {
                    final user = authService.currentUser;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bonjour, ${user?.prenom ?? 'Utilisateur'}',
                          style: AppTheme.textTheme.headlineSmall?.copyWith(
                            color: AppTheme.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.successGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'En ligne',
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              
              // Notifications
              Consumer<NotificationService>(
                builder: (context, notificationService, child) {
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_rounded,
                          color: AppTheme.white,
                          size: 28,
                        ),
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
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: 'Annonces actives',
              value: '12',
              subtitle: 'Documents en recherche',
              icon: Icons.description_rounded,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              title: 'Taux de récupération',
              value: '89%',
              subtitle: 'Dans votre région',
              icon: Icons.trending_up_rounded,
              color: AppTheme.successGreen,
            ),
          ),
        ],
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

  Widget _buildRecentActivity() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activité récente',
            style: AppTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          
          _buildActivityItem(
            icon: Icons.check_circle_rounded,
            iconColor: AppTheme.successGreen,
            title: 'Un document a été trouvé près de chez vous',
            subtitle: 'Il y a 15min',
          ),
          
          const SizedBox(height: 16),
          
          _buildActivityItem(
            icon: Icons.message_rounded,
            iconColor: AppTheme.primaryBlue,
            title: 'Quelqu\'un a contacté pour votre carte d\'identité',
            subtitle: 'Il y a 2h',
            badge: 'T',
            badgeColor: AppTheme.warningOrange,
          ),
          
          const SizedBox(height: 16),
          
              _buildActivityItem(
                icon: Icons.location_on_rounded,
                iconColor: AppTheme.infoBlue,
                title: 'Nouveau document signalé à Dakar',
                subtitle: 'Il y a 4h',
              ),
              
              const SizedBox(height: 16),
              
              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/found-documents'),
                      icon: const Icon(Icons.search_rounded),
                      label: const Text('Documents trouvés'),
                      style: AppTheme.primaryButtonStyle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/annonce-history'),
                      icon: const Icon(Icons.history_rounded),
                      label: const Text('Mon historique'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.white,
                        foregroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppTheme.primaryBlue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? badge,
    Color? badgeColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
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
        ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: badgeColor ?? AppTheme.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: Text(
              badge,
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: FloatingActionButton.extended(
        onPressed: () => context.go('/declare-loss'),
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(
          Icons.add_rounded,
          color: AppTheme.white,
        ),
        label: Text(
          'Signaler un document',
          style: AppTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.mediumGrey,
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Recherche',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_rounded),
            label: 'Mes Annonces',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profil',
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
              context.go('/my-annonces');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }
}