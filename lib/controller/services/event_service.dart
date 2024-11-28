import '../../data/local/database/app_database.dart';
import '../../data/repositories/event_repository.dart';

class EventService {
  final EventRepository _eventRepository;
  EventService(AppDatabase db) : _eventRepository = EventRepository(db);

  Future<List<Event>> getEventsForUser(String phoneNumber) async {
    return await _eventRepository.getEventsForUser(phoneNumber);
  }

  Future<int> getEventCountForUser(String phoneNumber) async {
    final eventsForFriend = await getEventsForUser(phoneNumber);
    return eventsForFriend.where((event) => event.eventDate.isAfter(DateTime.now())).length;
  }

  Future<void> addEvent(Event event) async {
    await _eventRepository.addEvent(event);
  }

  Future<void> updateEvent(Event updatedEvent) async {
    await _eventRepository.updateEvent(updatedEvent);
  }

  Future<void> deleteEvent(int eventId) async {
    await _eventRepository.deleteEvent(eventId);
  }

  Stream<List<Event>> getAllEvents() {
    return _eventRepository.getAllEvents();
  }

  // get even status for a given event

}
