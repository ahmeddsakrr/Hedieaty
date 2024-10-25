import 'package:flutter/material.dart';
import '../../components/sort_buttons.dart';
import '../../widgets/gift/gift_list_item.dart';
import '../../widgets/gift/gift_dialog.dart';
import '../../models/event.dart';
import '../../models/gift.dart';
import '../../strategies/gift_sort_strategy.dart';
import '../../strategies/sort_by_gift_name.dart';
import '../../strategies/sort_by_gift_category.dart';
import '../../strategies/sort_by_gift_status.dart';
import '../../strategies/gift_sort_context.dart';

class GiftListPage extends StatefulWidget {
  final Event event;

  const GiftListPage({super.key, required this.event});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Gift> _gifts = [];
  final GiftSortContext _sortContext = GiftSortContext();
  GiftSortStrategy? _lastUsedSortStrategy;

  @override
  void initState() {
    super.initState();
    _gifts = List.generate(
      10,
          (index) => Gift(
        name: '${widget.event.name} Gift $index',
        category: 'Category ${index % 3}',
        status: index % 2 == 0 ? 'Pledged' : 'Available',
      ),
    );
  }

  void _sortBy(GiftSortStrategy strategy) {
    setState(() {
      _sortContext.setSortStrategy(strategy);
      _gifts = _sortContext.sortGifts(_gifts);
      _lastUsedSortStrategy = strategy;
    });
  }

  void _addOrEditGift({Gift? gift, int? index}) {
    showDialog(
      context: context,
      builder: (context) {
        return GiftDialog(
          gift: gift,
          onSave: (newGift) {
            setState(() {
              if (index != null) {
                _gifts[index] = newGift;
              } else {
                _gifts.add(newGift);
                _listKey.currentState?.insertItem(_gifts.length - 1);
              }

              if (_lastUsedSortStrategy != null) {
                _sortBy(_lastUsedSortStrategy!);
              }
            });
          },
        );
      },
    );
  }

  void _removeGift(int index) {
    final removedGift = _gifts.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
          (context, animation) {
        return GiftListItem(
          gift: removedGift,
          animation: animation,
          onEdit: () => _addOrEditGift(gift: removedGift, index: index),
          onDelete: () {},
        );
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.event.name} - Gift List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addOrEditGift(),
          ),
        ],
      ),
      body: Column(
        children: [
          SortButtons(
            onSortByName: () => _sortBy(SortByGiftName()),
            onSortByCategory: () => _sortBy(SortByGiftCategory()),
            onSortByStatus: () => _sortBy(SortByGiftStatus()),
          ),
          Expanded(
            child: _gifts.isEmpty
                ? Center(
              child: Text(
                'No gifts available.',
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
            )
                : AnimatedList(
              key: _listKey,
              initialItemCount: _gifts.length,
              itemBuilder: (context, index, animation) {
                return GiftListItem(
                  gift: _gifts[index],
                  animation: animation,
                  onEdit: () => _addOrEditGift(gift: _gifts[index], index: index),
                  onDelete: () => _removeGift(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
