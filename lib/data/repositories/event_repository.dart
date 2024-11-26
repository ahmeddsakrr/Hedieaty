import '../local/database/app_database.dart';
import '../local/database/dao/event_dao.dart';

class EventRepository {
  final EventDao _eventDao;
  EventRepository(AppDatabase db) : _eventDao = EventDao(db);

  Future<void> addEvent(Event event) async {
    await _eventDao.insertEvent(event);
  }

  Stream<List<Event>> getAllEvents() {
    return _eventDao.watchAllEvents();
  }

  Future<List<Event>> getEventsForUser(String phoneNumber) {
    return _eventDao.findEventsByUserPhoneNumber(phoneNumber);
  }

  Future<void> updateEvent(Event updatedEvent) async {
    await _eventDao.updateEvent(updatedEvent);
  }

  Future<void> deleteEvent(int eventId) async {
    await _eventDao.deleteEvent(eventId);
  }
}
