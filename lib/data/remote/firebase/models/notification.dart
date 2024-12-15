import 'package:hedieaty/controller/utils/date_utils.dart';

class Notification {
  int id;
  final String userId;
  final String type;
  final String message;
  bool isRead;
  final DateTime createdAt;

  Notification({
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

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'],
      userId: map['user_id'],
      type: map['type'],
      message: map['message'],
      isRead: map['is_read'],
      createdAt: parseFormattedDate(map['created_at']),
    );
  }
}
