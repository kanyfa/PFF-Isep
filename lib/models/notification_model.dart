import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  newAnnonce,
  message,
  validation,
  success,
  warning,
  reminder,
  info;
}

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime date;
  final bool isRead;
  final String? annonceId;
  final String? senderId;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    this.isRead = false,
    this.annonceId,
    this.senderId,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'type': type.name,
      'date': date.toIso8601String(),
      'isRead': isRead,
      'annonceId': annonceId,
      'senderId': senderId,
      'data': data,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotificationType.info,
      ),
      date: DateTime.parse(map['date']),
      isRead: map['isRead'] ?? false,
      annonceId: map['annonceId'],
      senderId: map['senderId'],
      data: map['data'],
    );
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? date,
    bool? isRead,
    String? annonceId,
    String? senderId,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
      annonceId: annonceId ?? this.annonceId,
      senderId: senderId ?? this.senderId,
      data: data ?? this.data,
    );
  }
}