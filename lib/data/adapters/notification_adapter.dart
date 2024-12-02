import '../local/database/app_database.dart';
import '../remote/firebase/models/notification.dart' as RemoteNotification;

class NotificationAdapter {
  static Notification fromRemote(RemoteNotification.Notification notification) {
    return Notification(
      id: notification.id,
      userId: notification.userId,
      type: notification.type,
      message: notification.message,
      isRead: notification.isRead,
      createdAt: notification.createdAt,
    );
  }

  static RemoteNotification.Notification fromLocal(Notification notification) {
    return RemoteNotification.Notification(
      id: notification.id,
      userId: notification.userId,
      type: notification.type,
      message: notification.message,
      isRead: notification.isRead,
      createdAt: notification.createdAt,
    );
  }
}
