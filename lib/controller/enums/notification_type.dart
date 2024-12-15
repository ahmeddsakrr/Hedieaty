enum NotificationType {
  giftPledged,
  giftUnpledged,
}

extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.giftPledged:
        return "Gift Pledged";
      case NotificationType.giftUnpledged:
        return "Gift Unpledged";
    }
  }
}
