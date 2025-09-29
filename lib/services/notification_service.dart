import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';
import '../utils/logger.dart';

class NotificationService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  // Créer une notification
  Future<void> createNotification({
    required String userId,
    required String title,
    required String message,
    required NotificationType type,
    String? annonceId,
    String? senderId,
    Map<String, dynamic>? data,
  }) async {
    try {
      final notification = NotificationModel(
        id: '',
        userId: userId,
        title: title,
        message: message,
        type: type,
        date: DateTime.now(),
        annonceId: annonceId,
        senderId: senderId,
        data: data,
      );

      await _firestore.collection('notifications').add(notification.toMap());
      AppLogger.log('Notification créée avec succès');
    } catch (e) {
      AppLogger.log('Erreur lors de la création de la notification: $e');
    }
  }

  // Récupérer les notifications d'un utilisateur
  Future<void> loadUserNotifications(String userId) async {
    try {
      // Pour éviter l'erreur d'index Firebase, utilisons une requête plus simple
      final querySnapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .get();

      _notifications = querySnapshot.docs
          .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
          .toList();

      // Trier par date manuellement
      _notifications.sort((a, b) => b.date.compareTo(a.date));

      _unreadCount = _notifications.where((n) => !n.isRead).length;
      notifyListeners();
    } catch (e) {
      AppLogger.log('Erreur lors du chargement des notifications: $e');
      // En cas d'erreur, créer des notifications de démonstration
      _createDemoNotifications(userId);
    }
  }

  // Créer des notifications de démonstration
  void _createDemoNotifications(String userId) {
    _notifications = [
      NotificationModel(
        id: 'demo1',
        userId: userId,
        title: 'Bienvenue sur SenPapier !',
        message: 'Votre compte a été créé avec succès. Vous pouvez maintenant signaler des documents perdus.',
        type: NotificationType.info,
        date: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      NotificationModel(
        id: 'demo2',
        userId: userId,
        title: 'Nouvelle fonctionnalité',
        message: 'Découvrez la recherche intelligente pour trouver vos documents plus facilement.',
        type: NotificationType.info,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: 'demo3',
        userId: userId,
        title: 'Document trouvé près de vous',
        message: 'Un document a été trouvé à 500m de votre position actuelle.',
        type: NotificationType.success,
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
    _unreadCount = _notifications.where((n) => !n.isRead).length;
    notifyListeners();
  }

  // Marquer une notification comme lue
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});

      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        _unreadCount = _notifications.where((n) => !n.isRead).length;
        notifyListeners();
      }
    } catch (e) {
      AppLogger.log('Erreur lors de la mise à jour de la notification: $e');
    }
  }

  // Marquer toutes les notifications comme lues
  Future<void> markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      final unreadNotifications = _notifications.where((n) => !n.isRead);

      for (final notification in unreadNotifications) {
        batch.update(
          _firestore.collection('notifications').doc(notification.id),
          {'isRead': true},
        );
      }

      await batch.commit();

      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      AppLogger.log('Erreur lors de la mise à jour des notifications: $e');
    }
  }

  // Supprimer une notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .delete();

      _notifications.removeWhere((n) => n.id == notificationId);
      _unreadCount = _notifications.where((n) => !n.isRead).length;
      notifyListeners();
    } catch (e) {
      AppLogger.log('Erreur lors de la suppression de la notification: $e');
    }
  }

  // Notifications automatiques pour les rôles
  Future<void> notifyNewAnnonce(String annonceId, String annonceTitle) async {
    try {
      // Notifier les administrateurs
      final adminSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      for (final adminDoc in adminSnapshot.docs) {
        await createNotification(
          userId: adminDoc.id,
          title: 'Nouvelle annonce',
          message: 'Une nouvelle annonce a été publiée: $annonceTitle',
          type: NotificationType.newAnnonce,
          annonceId: annonceId,
        );
      }

      // Notifier les ramasseurs
      final ramasseurSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'ramasseur')
          .get();

      for (final ramasseurDoc in ramasseurSnapshot.docs) {
        await createNotification(
          userId: ramasseurDoc.id,
          title: 'Document à récupérer',
          message: 'Un nouveau document a été signalé: $annonceTitle',
          type: NotificationType.newAnnonce,
          annonceId: annonceId,
        );
      }
    } catch (e) {
      AppLogger.log('Erreur lors de la notification de nouvelle annonce: $e');
    }
  }

  Future<void> notifyDocumentFound(String userId, String annonceTitle) async {
    await createNotification(
      userId: userId,
      title: 'Document retrouvé !',
      message: 'Votre document "$annonceTitle" a été retrouvé par un ramasseur',
      type: NotificationType.success,
    );
  }

  Future<void> notifyValidationRequired(String userId, String annonceTitle) async {
    await createNotification(
      userId: userId,
      title: 'Validation requise',
      message: 'Un ramasseur prétend avoir trouvé votre document "$annonceTitle". Veuillez valider.',
      type: NotificationType.validation,
    );
  }
}