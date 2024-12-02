import '../../data/local/database/app_database.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/remote/firebase/models/event.dart' as RemoteEvent;

class EventService {
  final EventRepository _eventRepository;
  EventService(AppDatabase db) : _eventRepository = EventRepository(db);

  Stream<List<RemoteEvent.Event>> getEventsForUser(String phoneNumber)  {
    return _eventRepository.getEventsForUser(phoneNumber);
  }

  Stream<int> getEventCountForUser(String phoneNumber) {
    return getEventsForUser(phoneNumber).map((eventsForFriend) {
      return eventsForFriend.where((event) => event.eventDate.isAfter(DateTime.now())).length;
    });
  }


  Future<void> addEvent(RemoteEvent.Event event) async {
    await _eventRepository.addEvent(event);
  }

  Future<void> updateEvent(RemoteEvent.Event updatedEvent) async {
    await _eventRepository.updateEvent(updatedEvent);
  }

  Future<void> deleteEvent(int eventId) async {
    await _eventRepository.deleteEvent(eventId);
  }

  Stream<RemoteEvent.Event> getEvent(int eventId)  {
    return _eventRepository.getEvent(eventId);
  }

}
