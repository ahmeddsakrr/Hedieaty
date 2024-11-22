import '../../old_models/event.dart';
import 'event_sort_strategy.dart';

class SortByName implements EventSortStrategy {
  @override
  List<Event> sort(List<Event> events) {
    print("Sorting by name...");
    events.sort((a, b) => a.name.compareTo(b.name));
    return events;
  }
}
