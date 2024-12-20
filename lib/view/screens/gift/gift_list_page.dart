import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/controller/services/auth_service.dart';
import 'package:hedieaty/controller/services/pledge_service.dart';
import 'package:hedieaty/view/components/notification.dart';
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
import 'package:hedieaty/data/remote/firebase/models/pledge.dart';

class GiftListPage extends StatefulWidget {
  final Event event;
  final bool canManageGifts;

  const GiftListPage({super.key, required this.event, required this.canManageGifts});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  final GiftService _giftService = GiftService(local.AppDatabase());
  final PledgeService _pledgeService = PledgeService(local.AppDatabase());
  final AuthService _authService = AuthService(local.AppDatabase());
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Gift> _gifts = [];
  final GiftSortContext _sortContext = GiftSortContext();
  GiftSortStrategy? _lastUsedSortStrategy;
  bool isLoading = true;

  void _syncGifts(List<Gift> newGifts) {
    final oldGifts = _gifts;

    if (_lastUsedSortStrategy != null) {
      _sortContext.setSortStrategy(_lastUsedSortStrategy!);
      newGifts = _sortContext.sortGifts(newGifts);
    }

    final diff = newGifts.length - oldGifts.length;

    // Update _gifts list
    _gifts = newGifts;

    if (diff > 0) {
      // Add new items with animation
      for (int i = oldGifts.length; i < newGifts.length; i++) {
        _listKey.currentState?.insertItem(i);
      }
    } else if (diff < 0) {
      // Remove extra items with animation
      for (int i = oldGifts.length - 1; i >= newGifts.length; i--) {
        final removedGift = oldGifts[i];
        _listKey.currentState?.removeItem(i, (context, animation) => GiftListItem(
            gift: removedGift,
            animation: animation,
            onEdit: () {},
            onDelete: () {},
          ),
        );
      }
    }
  }

  void _sortBy(GiftSortStrategy strategy) {
    setState(() {
      _sortContext.setSortStrategy(strategy);
      _gifts = _sortContext.sortGifts(_gifts);
      _lastUsedSortStrategy = strategy;
    });
  }

  Future<void> _navigateToGiftDetails({Gift? gift, int? index, bool viewOnly = false}) async {
    final result = await navigateWithAnimation(
      GiftDetailsPage(
        gift: gift,
        isEditMode: gift != null,
        eventId: widget.event.id,
        viewOnly: viewOnly,
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

  Future<void> _removeGift(int index) async {
    final removedGift = _gifts[index];
    try {
      _listKey.currentState?.removeItem(
        index,
            (context, animation) => GiftListItem(
          gift: removedGift,
          animation: animation,
          onEdit: () {},
          onDelete: () {},
        ),
      );
      _gifts.removeAt(index);
      await _giftService.deleteGift(removedGift.id);
      if (_lastUsedSortStrategy != null) {
        _sortBy(_lastUsedSortStrategy!);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting gift: $e");
      }
      _gifts.insert(index, removedGift);
      _listKey.currentState?.insertItem(index);
      NotificationHelper.showNotification(context, 'Failed to delete gift', isSuccess: false);
    }
  }

  Future<void> _confirmPledge(Gift gift) async {
    final shouldPledge = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pledge Gift'),
          content: Text('Are you sure you want to pledge the gift "${gift.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.grey),
                overlayColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.1)),
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.teal),
                overlayColor: WidgetStateProperty.all(Colors.teal.withOpacity(0.1)),
              ),
              child: const Text('Pledge'),
              key: const Key('confirmPledgeButton'),
            ),
          ],
        );
      },
    );

    if (shouldPledge == true) {
      Pledge pledge = Pledge(
        giftId: gift.id,
        userId: await _authService.getCurrentUser(),
        id: 0,
        pledgeDate: DateTime.now(),
      );
      _pledgeService.pledgeGift(pledge);
      NotificationHelper.showNotification(context, 'Pledged ${gift.name}');
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
              key: const Key('addGiftButton'),
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

                final giftsFromStream = snapshot.data ?? [];
                _syncGifts(giftsFromStream);

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
                      final theme = Theme.of(context);
                      final isDarkMode = theme.brightness == Brightness.dark;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GiftListItem(
                          gift: _gifts[index],
                          animation: animation,
                          onEdit: () => _navigateToGiftDetails(gift: _gifts[index], index: index),
                          onDelete: () => _showDeleteConfirmationDialog(index),
                          showActions: widget.canManageGifts && _pledgeService.isAvailable(_gifts[index]),
                          customAction: _pledgeService.isAvailable(_gifts[index]) && !widget.canManageGifts
                              ? MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: TextButton(
                              onPressed: () => _confirmPledge(_gifts[index]),
                              style: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all(isDarkMode ? Colors.tealAccent : Colors.teal),
                                overlayColor: WidgetStateProperty.all(isDarkMode ? Colors.tealAccent.withOpacity(0.1) : Colors.teal.withOpacity(0.1)),
                              ),
                              child: const Text("Pledge"),
                              key: Key('pledgeButton'),
                            ),
                          )
                              : null,
                          onTap: widget.canManageGifts ? null : () => _navigateToGiftDetails(gift: _gifts[index], index: index, viewOnly: true),
                        ),
                      );
                    },
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
