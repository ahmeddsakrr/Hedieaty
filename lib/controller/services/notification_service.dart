import 'package:hedieaty/data/repositories/notification_repository.dart';
import '../../data/local/database/app_database.dart';
import '../../data/remote/firebase/models/notification.dart' as RemoteNotification;

class NotificationService {
  final NotificationRepository _notificationRepository;

  NotificationService(AppDatabase db) : _notificationRepository = NotificationRepository(db);

  Stream<List<RemoteNotification.Notification>> getNotifications(String userId) {
    return _notificationRepository.getNotifications(userId);
  }

  Future<void> createNotification(RemoteNotification.Notification notification) async {
    await _notificationRepository.createNotification(notification);
  }

  Future<void> deleteNotification(int notificationId) async {
    await _notificationRepository.deleteNotification(notificationId);
  }

  Future<void> updateNotification(RemoteNotification.Notification notification) async {
    await _notificationRepository.updateNotification(notification);
  }

  Future<void> markNotificationAsRead(RemoteNotification.Notification notification) async {
    notification.isRead = true;
    await _notificationRepository.updateNotification(notification);
  }

  Stream<RemoteNotification.Notification?> getNewNotificationStream(String userId) {
    return _notificationRepository.getUnreadNotificationStream(userId);
  }
}