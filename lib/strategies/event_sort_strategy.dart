import '../models/event.dart';
import '../widgets/event_item.dart';

abstract class EventSortStrategy {
  List<Event> sort(List<Event> events);
}
