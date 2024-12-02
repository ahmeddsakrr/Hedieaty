import '../app_database.dart';

class EventDao {
  final AppDatabase _db;
  EventDao(this._db);

  Future<void> insertEvent(Event event) async {
    await _db.into(_db.events).insert(event);
  }

  Stream<List<Event>> watchAllEvents() {
    return _db.select(_db.events).watch();
  }

  Future<Event?> findEventById(int id) {
    return (_db.select(_db.events)..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  Stream<List<Event>> findEventsByUserPhoneNumber(String phoneNumber) {
    return (_db.select(_db.events)..where((e) => e.userId.equals(phoneNumber))).watch();
  }

  Future<void> updateEvent(Event updatedEvent) async {
    await _db.update(_db.events).replace(updatedEvent);
  }

  Future<void> deleteEvent(int eventId) async {
    await (_db.delete(_db.events)..where((e) => e.id.equals(eventId))).go();
  }

  Future<List<Event>> getAllEvents() {
    return _db.select(_db.events).get();
  }

  Stream<Event> getEvent(int eventId) {
    return (_db.select(_db.events)..where((e) => e.id.equals(eventId))).watchSingle();
  }

  Future<void> insertOrUpdateEvent(Event event) async {
    await _db.into(_db.events).insertOnConflictUpdate(event);
  }
}
