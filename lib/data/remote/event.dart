import '../../controller/utils/date_utils.dart';

class RemoteEvent {
  final int id;
  final String userId;
  final String name;
  final String category;
  final DateTime eventDate;

  RemoteEvent({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.eventDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'category': category,
      'event_date': getFormattedDate(eventDate),
    };
  }

  factory RemoteEvent.fromMap(Map<String, dynamic> map) {
    return RemoteEvent(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      category: map['category'],
      eventDate: parseFormattedDate(map['event_date']),
    );
  }
}
