import '../database/app_database.dart';
import '../repositories/event_repository.dart';

class EventService {
  final EventRepository _eventRepository;
  EventService(this._eventRepository);

  Future<List<Event>> getEventsForFriend(String friendPhoneNumber) async {
    return await _eventRepository.getEventsForUser(friendPhoneNumber);
  }

  Future<int> getEventCountForFriend(String friendPhoneNumber) async {
    final eventsForFriend = await getEventsForFriend(friendPhoneNumber);
    return eventsForFriend.where((event) => event.eventDate.isAfter(DateTime.now())).length;
  }
}
