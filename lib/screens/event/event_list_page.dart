import 'package:flutter/material.dart';
import '../../../components/sort_buttons.dart';
import '../../widgets/event/event_item.dart';
import '../../widgets/event/event_dialog.dart';
import '../../../models/event.dart';
import '../../../strategies/event_sort_strategy.dart';
import '../../../strategies/sort_by_name.dart';
import '../../../strategies/sort_by_category.dart';
import '../../../strategies/sort_by_status.dart';
import '../../../strategies/event_sort_context.dart';
import '../../../screens/gift/gift_list_page.dart';
import '../../utils/navigation_utils.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Event> _events = [];
  final EventSortContext _sortContext = EventSortContext();
  EventSortStrategy? _lastUsedSortStrategy;

  @override
  void initState() {
    super.initState();
    _events = List.generate(10, (index) {
      return Event(
        name: 'Event $index',
        category: 'Category $index',
        status: index % 3 == 0 ? 'Upcoming' : (index % 3 == 1 ? 'Current' : 'Past'),
        date: DateTime.now().add(Duration(days: index * 7)), // Sample date calculation
      );
    });
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
              onSortByName: () => _sortBy(SortByName()),
              onSortByCategory: () => _sortBy(SortByCategory()),
              onSortByStatus: () => _sortBy(SortByStatus()),
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
