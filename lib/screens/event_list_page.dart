import 'package:flutter/material.dart';
import '../components/sort_buttons.dart';
import '../strategies/event_sort_strategy.dart';
import '../strategies/sort_by_name.dart';
import '../strategies/sort_by_category.dart';
import '../strategies/sort_by_status.dart';
import '../strategies/event_sort_context.dart';
import '../models/event.dart';

class EventListPage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const EventListPage({super.key, required this.toggleTheme});

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();
  List<Event> _events = [];
  final EventSortContext _sortContext = EventSortContext();
  EventSortStrategy? _lastUsedSortStrategy;

  @override
  void initState() {
    super.initState();
    _events = List.generate(
      10,
          (index) => Event(
        name: 'Event $index',
        category: 'Category $index',
        status: index % 3 == 0
            ? 'Upcoming'
            : (index % 3 == 1 ? 'Current' : 'Past'),
      ),
    );
  }

  void _sortBy(EventSortStrategy strategy) {
    setState(() {
      _sortContext.setSortStrategy(strategy);
      _events = _sortContext.sortEvents(_events);
      _lastUsedSortStrategy = strategy;  // Store the last used strategy
    });
  }

  void _removeEvent(int index) {
    final removedEvent = _events.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
          (context, animation) => _buildEventItem(removedEvent, index, animation),
    );
  }

  // Reusable dialog for adding/editing events
  Future<void> _showEventDialog({Event? event, int? index}) async {
    final isEditMode = event != null;
    final TextEditingController nameController = TextEditingController(text: event?.name ?? '');
    final TextEditingController categoryController = TextEditingController(text: event?.category ?? '');
    String selectedStatus = event?.status ?? 'Upcoming';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditMode ? 'Edit Event' : 'Add Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.purpleAccent,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.purpleAccent,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: ['Upcoming', 'Current', 'Past']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.purpleAccent,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (isEditMode && index != null) {
                  // Edit existing event
                  setState(() {
                    _events[index] = Event(
                      name: nameController.text,
                      category: categoryController.text,
                      status: selectedStatus,
                    );
                  });
                } else {
                  // Add new event
                  setState(() {
                    _events.add(Event(
                      name: nameController.text,
                      category: categoryController.text,
                      status: selectedStatus,
                    ));
                    _listKey.currentState?.insertItem(_events.length - 1);
                  });
                }

                // Reapply the last used sorting strategy
                if (_lastUsedSortStrategy != null) {
                  _sortBy(_lastUsedSortStrategy!);
                }

                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
              ),
              child: Text(isEditMode ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventItem(Event event, int index, Animation<double> animation) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(8),
          color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
          child: ListTile(
            leading: const Icon(Icons.event),
            title: Text(event.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category: ${event.category}'),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Status: ${event.status}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEventDialog(event: event, index: index),  // Open edit dialog
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeEvent(index),
                ),
              ],
            ),
            splashColor: Colors.purpleAccent.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
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
              child: AnimatedList(
                key: _listKey,
                controller: _scrollController,
                initialItemCount: _events.length,
                itemBuilder: (context, index, animation) {
                  if (index < _events.length) {
                    return _buildEventItem(_events[index], index, animation);
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEventDialog(), // Open dialog to add event
        child: const Icon(Icons.add),
      ),
    );
  }
}
