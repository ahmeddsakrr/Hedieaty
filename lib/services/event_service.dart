import '../database/app_database.dart';
import '../repositories/event_repository.dart';

class EventService {
  final EventRepository _eventRepository;
  EventService(this._eventRepository);

  Future<List<Event>> getEventsForUser(String phoneNumber) async {
    return await _eventRepository.getEventsForUser(phoneNumber);
  }

  Future<int> getEventCountForUser(String phoneNumber) async {
    final eventsForFriend = await getEventsForUser(phoneNumber);
    return eventsForFriend.where((event) => event.eventDate.isAfter(DateTime.now())).length;
  }
}
