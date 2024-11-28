import 'package:flutter/material.dart';
import 'package:hedieaty/controller/services/event_service.dart';
import '../../../data/local/database/app_database.dart';
import '../../components/sort_buttons.dart';
import '../../widgets/event/event_item.dart';
import '../../widgets/event/event_dialog.dart';
import '../../../controller/strategies/event_sort_strategy.dart';
import '../../../controller/strategies/sort_by_event_name.dart';
import '../../../controller/strategies/sort_by_event_category.dart';
import '../../../controller/strategies/sort_by_event_status.dart';
import '../../../controller/strategies/event_sort_context.dart';
import '../../screens/gift/gift_list_page.dart';
import '../../../controller/utils/navigation_utils.dart';

const String placeholderUserId = '1234567890'; // Placeholder for current user ID

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final EventService _eventService = EventService(AppDatabase());
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Event> _events = [];
  final EventSortContext _sortContext = EventSortContext();
  EventSortStrategy? _lastUsedSortStrategy;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final eventList = await _eventService.getEventsForUser(placeholderUserId);
      setState(() {
        _events = eventList;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching events: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _sortBy(EventSortStrategy strategy) {
    setState(() {
      _sortContext.setSortStrategy(strategy);
      _events = _sortContext.sortEvents(_events);
      _lastUsedSortStrategy = strategy;
    });
  }

  void _showEventDialog({Event? event, int? index}) {
    showDialog(
      context: context,
      builder: (context) => EventDialog(
        event: event,
        onSave: (savedEvent) {
          setState(() {
            if (event != null && index != null) {
              _events[index] = savedEvent;
            } else {
              _events.add(savedEvent);
              _listKey.currentState?.insertItem(_events.length - 1);
            }

            if (_lastUsedSortStrategy != null) {
              _sortBy(_lastUsedSortStrategy!);
            }
          });
        },
      ),
    );
  }

  void _removeEvent(int index) {
    final removedEvent = _events.removeAt(index);
    _listKey.currentState?.removeItem(index, (context, animation) {
      return EventItem(
        event: removedEvent,
        animation: animation,
        onEdit: () {},
        onDelete: () {},
        onTap: () {},
      );
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showEventDialog(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SortButtons(
              onSortByName: () => _sortBy(SortByEventName()),
              onSortByCategory: () => _sortBy(SortByEventCategory()),
              onSortByStatus: () => _sortBy(SortByEventStatus()),
            ),
            Expanded(
              child: _events.isEmpty
                  ? Center(
                child: Text(
                  'No events available. Add a new event to get started!',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
              )
                  : AnimatedList(
                key: _listKey,
                initialItemCount: _events.length,
                itemBuilder: (context, index, animation) {
                  return EventItem(
                    event: _events[index],
                    animation: animation,
                    onEdit: () => _showEventDialog(event: _events[index], index: index),
                    onDelete: () => _removeEvent(index),
                    onTap: () => navigateWithAnimation(context, GiftListPage(event: _events[index])),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
