import 'package:flutter/material.dart';
import 'package:hedieaty/controller/services/auth_service.dart';
import 'package:hedieaty/controller/services/event_service.dart';
import 'package:hedieaty/controller/services/gift_service.dart';
import 'package:hedieaty/controller/utils/date_utils.dart';
import '../../../data/local/database/app_database.dart';
import '../gift/gift_list_item.dart';
import '../../../data/remote/firebase/models/event.dart' as RemoteEvent;
import 'package:hedieaty/data/remote/firebase/models/gift.dart' as RemoteGift;


class EventExpandableList extends StatelessWidget {
  const EventExpandableList({super.key});

  @override
  Widget build(BuildContext context) {
    final GiftService _giftService = GiftService(AppDatabase());
    final EventService _eventService = EventService(AppDatabase());
    final AuthService _authService = AuthService(AppDatabase());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: StreamBuilder<List<RemoteEvent.Event>>(
        stream: _authService.getCurrentUser().then((userId) {
          return _eventService.getEventsForUser(userId);
        }).asStream().asyncExpand((stream) => stream),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found.'));
          }
          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            shrinkWrap: false,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final event = events[index];
              return StreamBuilder<List<RemoteGift.Gift>>(
                stream: _giftService.getGiftsForEvent(event.id),
                builder: (context, giftSnapshot) {
                  if (giftSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (giftSnapshot.hasError) {
                    return Text('Error fetching gifts: ${giftSnapshot.error}');
                  }
                  final gifts = giftSnapshot.data ?? [];
                  return EventItem(
                    eventName: event.name,
                    eventDate: getFormattedDate(event.eventDate),
                    gifts: gifts,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class EventItem extends StatefulWidget {
  final String eventName;
  final String eventDate;
  final List<RemoteGift.Gift> gifts;

  const EventItem({
    super.key,
    required this.eventName,
    required this.eventDate,
    required this.gifts,
  });

  @override
  _EventItemState createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface,
        child: Theme(
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Text(
                widget.eventName,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Date: ${widget.eventDate}",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: theme.colorScheme.onSurface,
            ),
            onExpansionChanged: (expanded) {
              setState(() {
                isExpanded = expanded;
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.gifts.map((gift) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Container(
                        decoration: BoxDecoration(
                        border: Border(
                        bottom: BorderSide(
                        color: theme.colorScheme.onSurface.withOpacity(0.1),
                        width: 1.0,
                    ),
                    ),
                    ),
                    child: GiftListItem(
                    gift: gift,
                    animation: null,
                    showActions: false,
                    onEdit: () {},
                    onDelete: () {},
                    ),
                    ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
