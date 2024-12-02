import '../app_database.dart';

class NotificationDao {
  final AppDatabase _db;
  NotificationDao(this._db);

  Future<void> insertNotification(Notification notification) async {
    await _db.into(_db.notifications).insert(notification);
  }

  Stream<List<Notification>> watchAllNotifications() {
    return _db.select(_db.notifications).watch();
  }

  Future<List<Notification>> getNotificationsForUser(String phoneNumber) {
    return (_db.select(_db.notifications)..where((n) => n.userId.equals(phoneNumber))).get();
  }

  Future<void> insertOrUpdateNotification(Notification notification) async {
    await _db.into(_db.notifications).insertOnConflictUpdate(notification);
  }

  Future<void> deleteNotification(int notificationId) async {
    await (_db.delete(_db.notifications)..where((n) => n.id.equals(notificationId))).go();
  }
}
