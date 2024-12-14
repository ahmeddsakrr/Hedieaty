import 'package:flutter/material.dart';
import 'package:hedieaty/controller/services/auth_service.dart';
import 'package:hedieaty/controller/services/gift_service.dart';
import 'package:hedieaty/controller/services/pledge_service.dart';
import 'package:hedieaty/data/local/database/app_database.dart' as local;
import '../../components/custom_search_bar.dart';
import '../../widgets/gift/gift_list_item.dart';
import 'package:hedieaty/data/remote/firebase/models/gift.dart';
import '../../../data/remote/firebase/models/user.dart';
import '../../../data/remote/firebase/models/event.dart';


class PledgedGiftsPage extends StatefulWidget {
  const PledgedGiftsPage({super.key});

  @override
  _PledgedGiftsPageState createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {
  List<Gift> pledgedGifts = [];
  final PledgeService _pledgeService = PledgeService(local.AppDatabase());
  final GiftService _giftService = GiftService(local.AppDatabase());
  final AuthService _authService = AuthService(local.AppDatabase());
  List<Gift> filteredGifts = [];
  String searchQuery = "";

  Stream<List<Gift>> _fetchPledgedGifts() {
    return _authService.getCurrentUser().then((currentUser) {
      return _pledgeService.getPledgedGiftsForUser(currentUser);
    }).asStream().asyncExpand((stream) => stream);
  }


  Stream<List<Gift>> _searchGifts(String query) {
    if (query.isEmpty) {
      return _fetchPledgedGifts();
    } else {
      return _authService.getCurrentUser().then((currentUser) {
        return _pledgeService.searchPledgedGifts(currentUser, query);
      }).asStream().asyncExpand((stream) => stream);
    }
  }

  // void _removePledgedGift(Gift gift) {
  //   setState(() async {
  //     String userId = await _authService.getCurrentUser();
  //     await _pledgeService.unpledgeGift(userId, gift.id);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Unpledged ${gift.name}'))
  //     );
  //   });
  // }

  void _removePledgedGift(Gift gift) async{
    String userId = await _authService.getCurrentUser();
    await _pledgeService.unpledgeGift(userId, gift.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Unpledged ${gift.name}'))
    );
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
                onSearch: (query) {
                  setState(() {
                    searchQuery = query;
                  });
                },
                hintText: "Search pledged gifts...",
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<List<Gift>>(
                stream: _searchGifts(searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final filteredGifts = snapshot.data ?? [];

                  if (filteredGifts.isEmpty) {
                    return Center(
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
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: filteredGifts.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                    itemBuilder: (context, index) {
                      final gift = filteredGifts[index];
                      return StreamBuilder<User?>(
                        stream: _giftService.getUserForGift(gift.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const ListTile(
                              title: Text("Loading..."),
                            );
                          }
                          if (snapshot.hasError) {
                            return ListTile(
                              title: const Text("Error loading user"),
                              subtitle: Text(snapshot.error.toString()),
                            );                          }
                          final user = snapshot.data;
                          final friendName = user?.name ?? 'Unknown User';
                          return StreamBuilder<Event>(
                            stream: _giftService.getEventForGift(gift.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const ListTile(
                                  title: Text("Loading..."),
                                );
                              }
                              if (snapshot.hasError) {
                                return ListTile(
                                  title: const Text("Error loading event"),
                                  subtitle: Text(snapshot.error.toString()),
                                );
                              }
                              final event = snapshot.data;
                              final dueDate = event?.eventDate ?? DateTime.now();
                              return GiftListItem(
                                gift: gift,
                                friendName: friendName,
                                dueDate: dueDate,
                                customAction: StreamBuilder<bool>(
                                  stream: _pledgeService.isUnpledgeable(gift),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError) {
                                      return const SizedBox.shrink();
                                    }
                                    if (snapshot.data == true) {
                                      return MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: TextButton(
                                          onPressed: () => _confirmUnpledge(gift),
                                          style: ButtonStyle(
                                            foregroundColor: WidgetStateProperty.all(Colors.red),
                                            overlayColor: WidgetStateProperty.all(Colors.red.withOpacity(0.1)),
                                          ),
                                          child: const Text("Unpledge"),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}
