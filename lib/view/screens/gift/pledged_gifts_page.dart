import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/controller/services/gift_service.dart';
import 'package:hedieaty/controller/services/pledge_service.dart';
import 'package:hedieaty/data/local/database/app_database.dart';
import '../../components/custom_search_bar.dart';
import '../../widgets/gift/gift_list_item.dart';

const String placeholderUserId = '1234567890'; // Placeholder for current user ID

class PledgedGiftsPage extends StatefulWidget {
  const PledgedGiftsPage({super.key});

  @override
  _PledgedGiftsPageState createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {
  List<Gift> pledgedGifts = [];
  final PledgeService _pledgeService = PledgeService(AppDatabase());
  final GiftService _giftService = GiftService(AppDatabase());
  List<Gift> filteredGifts = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchPledgedGifts();
  }

  Future<void> _fetchPledgedGifts() async {
    try {
      final giftList = await _pledgeService.getPledgedGiftsForUser(placeholderUserId);
      setState(() {
        pledgedGifts = giftList;
        filteredGifts = pledgedGifts;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching pledged gifts: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to load pledged gifts")));
    }
  }

  Future<void> _searchGifts(String query) async {
    setState(() {
      searchQuery = query;
    });

    if (query.isEmpty) {
      setState(() {
        filteredGifts = pledgedGifts;
      });
    } else {
      final searchedPledgedGifts = await _pledgeService.searchPledgedGifts(placeholderUserId, query);
      setState(() {
        filteredGifts = searchedPledgedGifts;
      });
    }
  }

  void _removePledgedGift(Gift gift) {
    setState(() async {
      _pledgeService.unpledgeGift(placeholderUserId, gift.id);
      pledgedGifts.remove(gift);
      filteredGifts = await _pledgeService.searchPledgedGifts(placeholderUserId, searchQuery);
    });
  }

  Future<void> _confirmUnpledge(Gift gift) async {
    final shouldUnpledge = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Unpledge Gift'),
          content: Text('Are you sure you want to unpledge the gift "${gift.name}"?'),
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
                foregroundColor: WidgetStateProperty.all(Colors.red),
                overlayColor: WidgetStateProperty.all(Colors.red.withOpacity(0.1)),
              ),
              child: const Text('Unpledge'),
            ),
          ],
        );
      },
    );

    if (shouldUnpledge == true) {
      _removePledgedGift(gift);
    }
  }

  Future<Map<String, dynamic>> _getGiftDetails(int giftId) async {
    final results = await Future.wait([
      _getFriendName(giftId),
      _getDueDate(giftId),
    ]);

    return {
      'friendName': results[0],
      'dueDate': results[1],
    };
  }

  Future<String> _getFriendName(int giftId) async {
    final user = await _giftService.getUserForGift(giftId);
    return user?.name ?? "Unknown Friend";
  }

  Future<DateTime> _getDueDate(int giftId) async {
    final event = await _giftService.getEventForGift(giftId);
    return event.eventDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Pledged Gifts"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomSearchBar(
                onSearch: _searchGifts,
                hintText: "Search pledged gifts...",
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: filteredGifts.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    searchQuery.isEmpty
                        ? 'You have not pledged any gifts yet.\nStart by pledging a gift for your friends!'
                        : 'No pledged gifts found matching "$searchQuery".',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemCount: filteredGifts.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                itemBuilder: (context, index) {
                  final gift = filteredGifts[index];
                  return FutureBuilder<Map<String, dynamic>>(
                    future: _getGiftDetails(gift.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: Text('No data available'));
                      }
                      final friendName = snapshot.data![0] as String;
                      final dueDate = snapshot.data![1] as DateTime;
                      return GiftListItem(
                        gift: gift,
                        friendName: friendName,
                        dueDate: dueDate,
                        customAction: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: TextButton(
                            onPressed: () => _confirmUnpledge(gift),
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all(Colors.red),
                              overlayColor: WidgetStateProperty.all(Colors.red.withOpacity(0.1)),
                            ),
                            child: const Text("Unpledge"),
                          ),
                        ),
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
