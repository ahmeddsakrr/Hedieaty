import '../database/app_database.dart';
import '../database/dao/notification_dao.dart';
import '../database/models/notification_table.dart';

class NotificationRepository {
  final NotificationDao _notificationDao;
  NotificationRepository(AppDatabase db) : _notificationDao = NotificationDao(db);

  Future<void> addNotification(Notification notification) async {
    await _notificationDao.insertNotification(notification);
  }

  Stream<List<Notification>> getAllNotifications() {
    return _notificationDao.watchAllNotifications();
  }

  Future<List<Notification>> getNotificationsForUser(String phoneNumber) {
    return _notificationDao.getNotificationsForUser(phoneNumber);
  }
}
