import '../../data/local/database/app_database.dart';
import 'event_sort_strategy.dart';

class SortByEventCategory implements EventSortStrategy {
  @override
  List<Event> sort(List<Event> events) {
    events.sort((a, b) => a.category.toLowerCase().compareTo(b.category.toLowerCase()));
    return events;
  }
}
