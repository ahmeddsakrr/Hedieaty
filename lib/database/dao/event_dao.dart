import 'package:drift/drift.dart';
import '../app_database.dart';
import '../models/event_table.dart';

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

  Future<List<Event>> findEventsByUserId(String userId) {
    return (_db.select(_db.events)..where((e) => e.userId.equals(userId))).get();
  }

}
