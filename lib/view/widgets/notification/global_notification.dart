import 'dart:async';
import 'package:hedieaty/controller/services/notification_service.dart';

import '../../../main.dart';
import '../../components/notification.dart';

class GlobalNotificationListener {
  final NotificationService _notificationService;
  final StreamController<String> _notificationQueue = StreamController<String>.broadcast();

  DateTime _loginTime;
  final Set<int> _displayedNotificationIds = {};

  GlobalNotificationListener(this._notificationService) : _loginTime = DateTime.now();

  void startListening(String userId) {
    print('Starting notification listener for user $userId');
    _loginTime = DateTime.now();
    _notificationService.getNotifications(userId).listen((notifications) {
      for (var notification in notifications) {
        if (_displayedNotificationIds.contains(notification.id)) {
          continue;
        }
        if (notification.createdAt.isAfter(_loginTime)) {
          print('New notification: ${notification.message}');
          _displayedNotificationIds.add(notification.id);
          _notificationQueue.add(notification.message);
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
    _displayedNotificationIds.clear();
  }
}