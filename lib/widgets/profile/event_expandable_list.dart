import 'package:flutter/material.dart';
import '../gift/gift_list_item.dart';
import '../../models/gift.dart';

class EventExpandableList extends StatelessWidget {
  const EventExpandableList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return EventItem(
          eventName: 'Event $index',
          eventDate: '2023-12-31',
          gifts: List.generate(3, (giftIndex) => Gift(
            name: 'Gift $giftIndex',
            category: 'Category ${giftIndex % 3}',
            status: giftIndex % 2 == 0 ? 'Available' : 'Pledged',
            description: 'Description for Gift $giftIndex',
            price: 20.0 + giftIndex * 5,
            imageUrl: null,
          )),
        );
      },
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ExpansionTile(
        title: Text(widget.eventName),
        subtitle: Text("Date: ${widget.eventDate}"),
        trailing: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
        onExpansionChanged: (expanded) {
          setState(() {
            isExpanded = expanded;
          });
        },
        children: widget.gifts.map((gift) {
          return GiftListItem(
            gift: gift,
            animation: null,
            showActions: false,
            onEdit: () {
            },
            onDelete: () {
            },
          );
        }).toList(),
      ),
    );
  }
}
