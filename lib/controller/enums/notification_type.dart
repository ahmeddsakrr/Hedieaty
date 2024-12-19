enum NotificationType {
  giftPledged,
  giftUnpledged,
  friendRequest,
}

extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.giftPledged:
        return "Gift Pledged";
      case NotificationType.giftUnpledged:
        return "Gift Unpledged";
      case NotificationType.friendRequest:
        return "Friend Request";
    }
  }
}
