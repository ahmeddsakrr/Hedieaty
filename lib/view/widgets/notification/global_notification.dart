import 'dart:async';
import 'package:hedieaty/controller/services/notification_service.dart';

import '../../../main.dart';
import '../../components/notification.dart';

class GlobalNotificationListener {
  final NotificationService _notificationService;
  StreamController<String>? _notificationQueue;

  DateTime _loginTime;
  final Set<int> _displayedNotificationIds = {};

  GlobalNotificationListener(this._notificationService) : _loginTime = DateTime.now();

  void startListening(String userId) {
    if (_notificationQueue != null && !_notificationQueue!.isClosed) {
      throw StateError('Listener is already running.');
    }
    print('Starting notification listener for user $userId');
    _loginTime = DateTime.now();
    _notificationQueue = StreamController<String>.broadcast();
    _notificationService.getNotifications(userId).listen((notifications) {
      for (var notification in notifications) {
        if (_displayedNotificationIds.contains(notification.id)) {
          continue;
        }
        if (notification.createdAt.isAfter(_loginTime)) {
          print('New notification: ${notification.message}');
          _displayedNotificationIds.add(notification.id);
          _notificationQueue?.add(notification.message);
        }
      }
    });
    _processQueue();
  }

  void _processQueue() async {
    if (_notificationQueue == null) return;

    await for (var message in _notificationQueue!.stream) {
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
    if (_notificationQueue != null && !_notificationQueue!.isClosed) {
      _notificationQueue!.close();
    }
    _notificationQueue = null;
    _displayedNotificationIds.clear();
  }
}