import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/controller/services/event_service.dart';
import 'package:hedieaty/view/components/notification.dart';
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
import '../../../data/remote/firebase/models/event.dart' as RemoteEvent;


class EventListPage extends StatefulWidget {
  final String userId;
  final bool canManageEvents;
  const EventListPage({super.key, required this.userId, required this.canManageEvents});

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final EventService _eventService = EventService(AppDatabase());
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<RemoteEvent.Event> _events = [];
  final EventSortContext _sortContext = EventSortContext();
  EventSortStrategy? _lastUsedSortStrategy;
  bool isLoading = true;


  void _sortBy(EventSortStrategy strategy) {
    setState(() {
      _sortContext.setSortStrategy(strategy);
      _events = _sortContext.sortEvents(_events);
      _lastUsedSortStrategy = strategy;
    });
  }

  void _showEventDialog({RemoteEvent.Event? event, int? index}) async {
    showDialog(
      context: context,
      builder: (context) => EventDialog(
        event: event,
        onSave: (savedEvent) async {
          try {
            if (event == null) {
              // Adding new event
              await _eventService.addEvent(savedEvent);
              setState(() {
                _events.add(savedEvent);
                _listKey.currentState?.insertItem(_events.length - 1);
              });
            } else {
              // Editing existing event
              await _eventService.updateEvent(savedEvent);
              setState(() {
                _events[index!] = savedEvent;
              });
            }
            if (_lastUsedSortStrategy != null) {
              _sortBy(_lastUsedSortStrategy!);
            }
          } catch (e) {
            if (kDebugMode) {
              print("Error saving event: $e");
            }
            NotificationHelper.showNotification(context, 'Failed to save event', isSuccess: false);
          }
        }, userId: widget.userId,
      ),
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: const Text('Are you sure you want to delete this event?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _removeEvent(index); // Call delete action
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _removeEvent(int index) async {
    try {
      await _eventService.deleteEvent(_events[index].id);
      final removedEvent = _events.removeAt(index);
      _listKey.currentState?.removeItem(index, (context, animation) {
        return EventItem(
          event: removedEvent,
          animation: animation,
          onEdit: () {},
          onDelete: () {},
          onTap: () {},
          canManageEvents: widget.canManageEvents,
          onPublish: () {},
          isPublished: false,
        );
      });
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting event: $e");
      }
      NotificationHelper.showNotification(context, 'Failed to delete event', isSuccess: false);
    }
  }

  void publishEvent(int eventId, String eventName) async{
    try {
      _eventService.publishEvent(eventId);
      NotificationHelper.showNotification(context, 'Event $eventName was published successfully!');
    } catch (e) {
      if (kDebugMode) {
        print("Error publishing event: $e");
      }
      NotificationHelper.showNotification(context, 'Failed to publish event', isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event List"),
        actions: [
          if (widget.canManageEvents)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showEventDialog(),
              key: const Key('createEventButton'),
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
              child: StreamBuilder<List<RemoteEvent.Event>>(
                stream: widget.canManageEvents ? _eventService.getEventsForUser(widget.userId) : _eventService.getPublishedEventsForUser(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        widget.canManageEvents ? 'No events available. Add a new event to get started!' : 'No events found.',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    );
                  }

                  // Data available
                  final events = snapshot.data!;

                  return AnimatedList(
                    key: _listKey,
                    initialItemCount: events.length,
                    itemBuilder: (context, index, animation) {
                      return EventItem(
                        event: events[index],
                        animation: animation,
                        onEdit: () => _showEventDialog(event: events[index], index: index),
                        onDelete: () => _showDeleteConfirmationDialog(index),
                        onTap: () => navigateWithAnimation(GiftListPage(event: events[index], canManageGifts: widget.canManageEvents,)),
                        canManageEvents: widget.canManageEvents,
                        onPublish: () => publishEvent(events[index].id, events[index].name),
                        isPublished: events[index].isPublished,
                      );
                    },
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
