import '../../old_models/event.dart';
import 'event_sort_strategy.dart';

class SortByStatus implements EventSortStrategy {
  @override
  List<Event> sort(List<Event> events) {
    print("Sorting by status...");
    events.sort((a, b) => a.status.compareTo(b.status));
    return events;
  }
}
