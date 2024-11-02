import 'package:flutter/material.dart';
import '../gift/gift_list_item.dart';
import '../../old_models/gift.dart';

class EventExpandableList extends StatelessWidget {
  const EventExpandableList({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        itemCount: 5,
        shrinkWrap: false,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return EventItem(
            eventName: 'Event $index',
            eventDate: '2023-12-31',
            gifts: List.generate(
              3,
                  (giftIndex) => Gift(
                name: 'Gift $giftIndex',
                category: 'Category ${giftIndex % 3}',
                status: giftIndex % 2 == 0 ? 'Available' : 'Pledged',
                description: 'Description for Gift $giftIndex',
                price: 20.0 + giftIndex * 5,
                imageUrl: null,
              ),
            ),
          );
        },
      ),
    );
  }
}

class EventItem extends StatefulWidget {
  final String eventName;
  final String eventDate;
  final List<Gift> gifts;

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
