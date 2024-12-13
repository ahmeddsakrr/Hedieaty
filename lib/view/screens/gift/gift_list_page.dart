import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../controller/services/gift_service.dart';
import '../../../data/local/database/app_database.dart' as local;
import '../../components/sort_buttons.dart';
import '../../widgets/gift/gift_list_item.dart';
import '../../../controller/strategies/gift_sort_strategy.dart';
import '../../../controller/strategies/sort_by_gift_name.dart';
import '../../../controller/strategies/sort_by_gift_category.dart';
import '../../../controller/strategies/sort_by_gift_status.dart';
import '../../../controller/strategies/gift_sort_context.dart';
import 'gift_details_page.dart';
import '../../../controller/utils/navigation_utils.dart';
import 'package:hedieaty/data/remote/firebase/models/gift.dart';
import '../../../data/remote/firebase/models/event.dart';

class GiftListPage extends StatefulWidget {
  final Event event;
  final bool canManageGifts;

  const GiftListPage({super.key, required this.event, required this.canManageGifts});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  final GiftService _giftService = GiftService(local.AppDatabase());
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Gift> _gifts = [];
  final GiftSortContext _sortContext = GiftSortContext();
  GiftSortStrategy? _lastUsedSortStrategy;
  bool isLoading = true;


  void _sortBy(GiftSortStrategy strategy) {
    setState(() {
      _sortContext.setSortStrategy(strategy);
      _gifts = _sortContext.sortGifts(_gifts);
      _lastUsedSortStrategy = strategy;
    });
  }

  void _navigateToGiftDetails({Gift? gift, int? index}) async {
    final result = await navigateWithAnimation(
      GiftDetailsPage(
        gift: gift,
        isEditMode: gift != null,
        eventId: widget.event.id,
      ),
    );
    if (result != null) {
      if (index != null) {
        // Update existing gift
        await _giftService.updateGift(result);
      } else {
        // Add new gift
        await _giftService.addGift(result);
      }
      if (_lastUsedSortStrategy != null) {
        _sortBy(_lastUsedSortStrategy!);
      }
    }
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Gift'),
        content: const Text('Are you sure you want to delete this gift?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _removeGift(index);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  _removeGift(int index) async {
    try {
      await _giftService.deleteGift(_gifts[index].id);
      final removedGift = _gifts.removeAt(index);
      _listKey.currentState?.removeItem(index, (context, animation) {
        return GiftListItem(
          gift: removedGift,
          animation: animation,
          onEdit: () {},
          onDelete: () {},
        );
      });
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting gift: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to delete gift")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.event.name} - Gift List"),
        actions: [
          if (widget.canManageGifts)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _navigateToGiftDetails(),
            ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          SortButtons(
            onSortByName: () => _sortBy(SortByGiftName()),
            onSortByCategory: () => _sortBy(SortByGiftCategory()),
            onSortByStatus: () => _sortBy(SortByGiftStatus()),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: StreamBuilder<List<Gift>>(
              stream: _giftService.getGiftsForEvent(widget.event.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                _gifts = snapshot.data ?? [];
                if (_lastUsedSortStrategy != null) {
                  _sortBy(_lastUsedSortStrategy!);
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          onDelete: () => _showDeleteConfirmationDialog(index),
                          showActions: widget.canManageGifts,
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ),
        ],
      ),
    );
  }
}
