enum EventStatus {
  past,
  upcoming,
  current;

  // Helper method to get the EventStatus based on the event date
  static EventStatus fromDateTime(DateTime eventDate) {
    final now = DateTime.now();
    if (eventDate.isBefore(now)) {
      return EventStatus.past;
    } else if (eventDate.isAfter(now)) {
      return EventStatus.upcoming;
    } else {
      return EventStatus.current;
    }
  }

  // Helper method to convert EventStatus to a string for display purposes
  String get name {
    switch (this) {
      case EventStatus.past:
        return 'Past';
      case EventStatus.upcoming:
        return 'Upcoming';
      case EventStatus.current:
        return 'Current';
    }
  }

  // Helper method to check if the event is in the past
  bool get isPast {
    return this == EventStatus.past;
  }

  // Helper method to check if the event is upcoming
  bool get isUpcoming {
    return this == EventStatus.upcoming;
  }

  // Helper method to check if the event is current
  bool get isCurrent {
    return this == EventStatus.current;
  }

  @override
  String toString() {
    return name;
  }
}
