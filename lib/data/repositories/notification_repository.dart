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

  Stream<List<RemoteNotification.Notification>> getNotifications(String userId) {
    return _remoteNotificationDao
        .getNotificationsByUser(userId)
        .handleError((error) {
      return _localNotificationDao
          .getNotificationsForUser(userId)
          .map((localNotifications) => localNotifications.map((n) => NotificationAdapter.fromLocal(n)).toList());
    }).map((remoteNotifications) {
      for (final remoteNotification in remoteNotifications) {
        final localNotification = NotificationAdapter.fromRemote(remoteNotification);
        _localNotificationDao.insertOrUpdateNotification(localNotification);
      }
      return remoteNotifications;
    });
  }


  Future<void> deleteNotification(int notificationId) async {
    await _remoteNotificationDao.deleteNotification(notificationId);
    await _localNotificationDao.deleteNotification(notificationId);
  }
}
