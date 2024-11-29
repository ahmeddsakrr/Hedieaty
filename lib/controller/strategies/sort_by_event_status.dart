import 'package:hedieaty/controller/enums/event_status.dart';

import '../../data/local/database/app_database.dart';
import 'event_sort_strategy.dart';

class SortByEventStatus implements EventSortStrategy {
  @override
  List<Event> sort(List<Event> events) {
    events.sort((a, b) => EventStatus.fromDateTime(a.eventDate).name.toLowerCase().compareTo(EventStatus.fromDateTime(b.eventDate).name.toLowerCase()));
    return events;
  }
}
