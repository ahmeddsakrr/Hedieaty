import 'package:flutter/material.dart';
import 'package:hedieaty/controller/services/auth_service.dart';
import 'package:hedieaty/data/local/database/app_database.dart';

import '../../../controller/services/notification_service.dart';
import 'package:hedieaty/data/remote/firebase/models/notification.dart' as RemoteNotification;

import '../../components/notification.dart';

class GlobalNotificationListener extends StatefulWidget {
  final NotificationService notificationService;
  final Widget child;
  // final String userId;

  const GlobalNotificationListener({
    super.key,
    required this.notificationService,
    required this.child,
    // required this.userId,
  });

  @override
  _GlobalNotificationListenerState createState() =>
      _GlobalNotificationListenerState();
}

class _GlobalNotificationListenerState
    extends State<GlobalNotificationListener> {
  final List<RemoteNotification.Notification> _notificationQueue = [];
  final AuthService _authService = AuthService(AppDatabase());
  bool _isShowingNotification = false;

  @override
  void initState() {
    super.initState();
    _listenForNotifications();
  }

  void _listenForNotifications() async {
    String userId = await _authService.getCurrentUser();
    widget.notificationService
        .getNewNotificationStream(userId)
        .listen((notification) {
      if (notification != null) {
        _enqueueNotification(notification);
      }
    });
  }

  void _enqueueNotification(RemoteNotification.Notification notification) {
    _notificationQueue.add(notification);
    if (!_isShowingNotification) {
      _showNextNotification();
    }
  }

  void _showNextNotification() async {
    if (_notificationQueue.isEmpty) return;

    setState(() => _isShowingNotification = true);

    final nextNotification = _notificationQueue.removeAt(0);
    NotificationHelper.showNotification(
      context,
      nextNotification.message,
      isSuccess: true,
    );

    await Future.delayed(const Duration(seconds: 3));

    if (_notificationQueue.isNotEmpty) {
      _showNextNotification();
    } else {
      setState(() => _isShowingNotification = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
