import 'package:drift/drift.dart';
import '../app_database.dart';
import '../models/notification_table.dart';

class NotificationDao {
  final AppDatabase _db;
  NotificationDao(this._db);

  Future<void> insertNotification(Notification notification) async {
    await _db.into(_db.notifications).insert(notification);
  }

  Stream<List<Notification>> watchAllNotifications() {
    return _db.select(_db.notifications).watch();
  }

  Future<List<Notification>> getNotificationsForUser(String userId) {
    return (_db.select(_db.notifications)..where((n) => n.userId.equals(userId))).get();
  }
}
