import '../../old_models/event.dart';

abstract class EventSortStrategy {
  List<Event> sort(List<Event> events);
}
