import '../adapters/event_adapter.dart';
import '../local/database/app_database.dart';
import '../local/database/dao/event_dao.dart';
import '../remote/firebase/dao/event_dao.dart' as RemoteEventDao;
import '../remote/firebase/models/event.dart' as RemoteEvent;


class EventRepository {
  final EventDao _localEventDao;
  final RemoteEventDao.EventDAO _remoteEventDao = RemoteEventDao.EventDAO();
  EventRepository(AppDatabase db) : _localEventDao = EventDao(db);

  Future<void> addEvent(RemoteEvent.Event event) async {
    await _remoteEventDao.createEvent(event);
    final localEvent = EventAdapter.fromRemote(event);
    await _localEventDao.insertOrUpdateEvent(localEvent);
  }

  Future<List<RemoteEvent.Event>> getEventsForUser(String userId) async {
    try {
      final remoteEvents = await _remoteEventDao.getEventsByUser(userId);
      for (final remoteEvent in remoteEvents) {
        final localEvent = EventAdapter.fromRemote(remoteEvent);
        await _localEventDao.insertOrUpdateEvent(localEvent);
      }
      return remoteEvents;
    } catch (e) {
      final localEvents = await _localEventDao.findEventsByUserPhoneNumber(userId);
      return localEvents.map((e) => EventAdapter.fromLocal(e)).toList();
    }
  }

  Future<void> updateEvent(RemoteEvent.Event event) async {
    await _remoteEventDao.updateEvent(event);
    final localEvent = EventAdapter.fromRemote(event);
    await _localEventDao.insertOrUpdateEvent(localEvent);
  }

  Future<void> deleteEvent(int eventId) async {
    await _remoteEventDao.deleteEvent(eventId);
    await _localEventDao.deleteEvent(eventId);
  }

  Future<Event> getEvent(int eventId) async {
    return await _localEventDao.getEvent(eventId);
  }
}
