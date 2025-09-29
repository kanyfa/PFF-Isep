import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/notification_service.dart';
import '../../services/auth_service.dart';
import '../../utils/theme.dart';
import '../../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
          'Notifications',
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
              return TextButton(
                onPressed: () async {
                  final authService = context.read<AuthService>();
                  if (authService.currentUser != null) {
                    await notificationService.markAllAsRead(authService.currentUser!.id);
                  }
                },
                child: Text(
                  'Tout marquer comme lu',
                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationService>(
        builder: (context, notificationService, child) {
          if (notificationService.notifications.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: _loadNotifications,
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notificationService.notifications.length,
              itemBuilder: (context, index) {
                final notification = notificationService.notifications[index];
                return _buildNotificationCard(notification, notificationService);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
              context.go('/notifications');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
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
              Icons.notifications_none_rounded,
              size: 64,
              color: AppTheme.mediumGrey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucune notification',
            style: AppTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Vous recevrez des notifications ici\nquand il y aura de l\'activité',
            style: AppTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.mediumGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification, NotificationService notificationService) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppTheme.cardDecoration.copyWith(
        color: notification.isRead ? AppTheme.white : AppTheme.surfaceVariant,
        border: notification.isRead 
            ? Border.all(color: AppTheme.outline)
            : Border.all(color: AppTheme.primaryBlue, width: 2),
      ),
      child: InkWell(
        onTap: () async {
          if (!notification.isRead) {
            await notificationService.markAsRead(notification.id);
          }
          
          // Navigation selon le type de notification
          if (notification.annonceId != null) {
            context.go('/annonce/${notification.annonceId}');
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône de notification
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
              // Contenu de la notification
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTheme.textTheme.titleMedium?.copyWith(
                              fontWeight: notification.isRead 
                                  ? FontWeight.w500 
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.message,
                      style: AppTheme.textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: AppTheme.mediumGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(notification.date),
                          style: AppTheme.textTheme.bodySmall,
                        ),
                        const Spacer(),
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'delete') {
                              await notificationService.deleteNotification(notification.id);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline, color: AppTheme.errorRed),
                                  SizedBox(width: 8),
                                  Text('Supprimer'),
                                ],
                              ),
                            ),
                          ],
                          child: Icon(
                            Icons.more_vert_rounded,
                            color: AppTheme.mediumGrey,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.newAnnonce:
        return Icons.description_rounded;
      case NotificationType.message:
        return Icons.message_rounded;
      case NotificationType.validation:
        return Icons.verified_user_rounded;
      case NotificationType.success:
        return Icons.check_circle_rounded;
      case NotificationType.warning:
        return Icons.warning_rounded;
      case NotificationType.reminder:
        return Icons.alarm_rounded;
      case NotificationType.info:
        return Icons.info_rounded;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.newAnnonce:
        return AppTheme.infoBlue;
      case NotificationType.message:
        return AppTheme.successGreen;
      case NotificationType.validation:
        return AppTheme.warningOrange;
      case NotificationType.success:
        return AppTheme.successGreen;
      case NotificationType.warning:
        return AppTheme.warningOrange;
      case NotificationType.reminder:
        return AppTheme.primaryBlue;
      case NotificationType.info:
        return AppTheme.mediumGrey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }
}