import '../local/database/app_database.dart';
import '../remote/firebase/models/event.dart' as RemoteEvent;

class EventAdapter {
  static Event fromRemote(RemoteEvent.Event event) {
    return Event(
      id: event.id,
      userId: event.userId,
      name: event.name,
      category: event.category,
      eventDate: event.eventDate,
    );
  }

  static RemoteEvent.Event fromLocal(Event event) {
    return RemoteEvent.Event(
      id: event.id,
      userId: event.userId,
      name: event.name,
      category: event.category,
      eventDate: event.eventDate,
    );
  }
}
