import 'package:hedieaty/controller/utils/date_utils.dart';

class Event {
  int id;
  final String userId;
  final String name;
  final String category;
  final DateTime eventDate;
  bool isPublished;

  Event({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.eventDate,
    required this.isPublished,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'category': category,
      'event_date': getFormattedDate(eventDate),
      'is_published': isPublished,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      category: map['category'],
      eventDate: parseFormattedDate(map['event_date']),
      isPublished: map['is_published'],
    );
  }
}
