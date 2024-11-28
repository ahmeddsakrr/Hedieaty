
import '../../data/local/database/app_database.dart';

abstract class EventSortStrategy {
  List<Event> sort(List<Event> events);
}
