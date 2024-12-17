import 'dart:async';
import 'package:hedieaty/controller/services/notification_service.dart';

import '../../../main.dart';
import '../../components/notification.dart';

class GlobalNotificationListener {
  final NotificationService _notificationService;
  final StreamController<String> _notificationQueue = StreamController<String>.broadcast();

  DateTime _loginTime;

  GlobalNotificationListener(this._notificationService) : _loginTime = DateTime.now();

  void startListening(String userId) {
    print('Starting notification listener for user $userId');
    _loginTime = DateTime.now();
    _notificationService.getNotifications(userId).listen((notifications) {
      for (var notification in notifications) {
        print('Notification received: ${notification.message}, createdAt: ${notification.createdAt}');
        print('Login time: $_loginTime');

        if (notification.createdAt.isAfter(_loginTime)) {
          print('New notification: ${notification.message}');
          _notificationQueue.add(notification.message);
        } else {
          print('Old notification ignored: ${notification.message}');
        }
      }
    });
    _processQueue();
  }

  void _processQueue() async {
    await for (var message in _notificationQueue.stream) {
      if (navigatorKey.currentContext != null) {
        NotificationHelper.showNotification(
          navigatorKey.currentContext!,
          message,
        );
      }
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  void dispose() {
    _notificationQueue.close();
  }
}