import '../adapters/notification_adapter.dart';
import '../local/database/app_database.dart';
import '../local/database/dao/notification_dao.dart';
import '../remote/firebase/dao/notification_dao.dart' as RemoteNotificationDao;
import '../remote/firebase/models/notification.dart' as RemoteNotification;

class NotificationRepository {
  final NotificationDao _localNotificationDao;
  final RemoteNotificationDao.NotificationDAO _remoteNotificationDao = RemoteNotificationDao.NotificationDAO();
  NotificationRepository(AppDatabase db) : _localNotificationDao = NotificationDao(db);

  Future<void> createNotification(RemoteNotification.Notification notification) async {
    await _remoteNotificationDao.createNotification(notification);
    final localNotification = NotificationAdapter.fromRemote(notification);
    await _localNotificationDao.insertOrUpdateNotification(localNotification);
  }

  Future<List<RemoteNotification.Notification>> getNotifications(String userId) async {
    try {
      final remoteNotifications = await _remoteNotificationDao.getNotificationsByUser(userId);
      for (final remoteNotification in remoteNotifications) {
        final localNotification = NotificationAdapter.fromRemote(remoteNotification);
        await _localNotificationDao.insertOrUpdateNotification(localNotification);
      }
      return remoteNotifications;
    } catch (e) {
      final localNotifications = await _localNotificationDao.getNotificationsForUser(userId);
      return localNotifications.map((n) => NotificationAdapter.fromLocal(n)).toList();
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    await _remoteNotificationDao.deleteNotification(notificationId);
    await _localNotificationDao.deleteNotification(notificationId);
  }
}
