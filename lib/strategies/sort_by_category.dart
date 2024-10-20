import '../models/event.dart';
import 'event_sort_strategy.dart';

class SortByCategory implements EventSortStrategy {
  @override
  List<Event> sort(List<Event> events) {
    print("Sorting by category...");
    events.sort((a, b) => a.category.compareTo(b.category));
    return events;
  }
}
