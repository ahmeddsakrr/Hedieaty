import 'package:flutter/material.dart';
import '../../components/sort_buttons.dart';
import '../../widgets/gift/gift_list_item.dart';
import '../../models/event.dart';
import '../../models/gift.dart';
import '../../strategies/gift_sort_strategy.dart';
import '../../strategies/sort_by_gift_name.dart';
import '../../strategies/sort_by_gift_category.dart';
import '../../strategies/sort_by_gift_status.dart';
import '../../strategies/gift_sort_context.dart';
import 'gift_details_page.dart';

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
        description: 'Description for gift $index',
        price: (index + 1) * 10.0,
        imageUrl: null,
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

  void _navigateToGiftDetails({Gift? gift, int? index}) async {
    final result = await Navigator.of(context).push<Gift>(
      MaterialPageRoute(
        builder: (context) => GiftDetailsPage(
          gift: gift,
          isEditMode: gift != null,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          _gifts[index] = result;
        } else {
          _gifts.add(result);
          _listKey.currentState?.insertItem(_gifts.length - 1);
        }
        if (_lastUsedSortStrategy != null) {
          _sortBy(_lastUsedSortStrategy!);
        }
      });
    }
  }

  void _removeGift(int index) {
    final removedGift = _gifts.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
          (context, animation) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: GiftListItem(
            gift: removedGift,
            animation: animation,
            onEdit: () => _navigateToGiftDetails(gift: removedGift, index: index),
            onDelete: () {},
          ),
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
            onPressed: () => _navigateToGiftDetails(),
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
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GiftListItem(
                    gift: _gifts[index],
                    animation: animation,
                    onEdit: () => _navigateToGiftDetails(gift: _gifts[index], index: index),
                    onDelete: () => _removeGift(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
