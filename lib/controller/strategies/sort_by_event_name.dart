import '../../data/local/database/app_database.dart';
import 'event_sort_strategy.dart';

class SortByEventName implements EventSortStrategy {
  @override
  List<Event> sort(List<Event> events) {
    events.sort((a, b) => a.name.compareTo(b.name));
    return events;
  }
}
