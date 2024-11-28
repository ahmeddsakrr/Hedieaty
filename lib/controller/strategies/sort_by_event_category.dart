import '../../data/local/database/app_database.dart';
import 'event_sort_strategy.dart';

class SortByEventCategory implements EventSortStrategy {
  @override
  List<Event> sort(List<Event> events) {
    print("Sorting by category...");
    events.sort((a, b) => a.category.compareTo(b.category));
    return events;
  }
}
