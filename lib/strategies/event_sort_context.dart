import '../models/event.dart';
import 'event_sort_strategy.dart';

class EventSortContext {
  EventSortStrategy? _strategy;

  void setSortStrategy(EventSortStrategy strategy) {
    _strategy = strategy;
  }

  List<Event> sortEvents(List<Event> events) {
    return _strategy != null ? _strategy!.sort(events) : events;
  }
}
