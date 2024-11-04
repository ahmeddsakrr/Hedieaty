import '../database/app_database.dart';
import '../database/dao/event_dao.dart';
import '../database/models/event_table.dart';

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
}
