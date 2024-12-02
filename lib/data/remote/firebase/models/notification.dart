import 'package:hedieaty/controller/utils/date_utils.dart';

class RemoteNotification {
  final int id;
  final String userId;
  final String type;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  RemoteNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'message': message,
      'is_read': isRead,
      'created_at': getFormattedDate(createdAt),
    };
  }

  factory RemoteNotification.fromMap(Map<String, dynamic> map) {
    return RemoteNotification(
      id: map['id'],
      userId: map['user_id'],
      type: map['type'],
      message: map['message'],
      isRead: map['is_read'],
      createdAt: parseFormattedDate(map['created_at']),
    );
  }
}
