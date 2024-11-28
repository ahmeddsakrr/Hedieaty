import 'package:flutter/material.dart';
import 'package:hedieaty/controller/services/event_service.dart';
import '../../../data/local/database/app_database.dart';
import '../../../controller/services/friend_service.dart';
import '../../components/custom_search_bar.dart';
import '../../widgets/friend/friend_list_item.dart';
import '../event/event_list_page.dart';
import '../profile/profile_page.dart';
import '../../../controller/utils/navigation_utils.dart';

const String placeholderUserId = '1234567890'; // Placeholder for current user ID

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FriendService _friendService = FriendService(AppDatabase());
  final EventService _eventService = EventService(AppDatabase());
  List<User> friends = [];
  List<User> filteredFriends = [];
  String searchQuery = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFriends();
  }

  Future<void> _fetchFriends() async {
    try {
      final friendList = await _friendService.getFriendsForUser(placeholderUserId);
      setState(() {
        friends = friendList;
        filteredFriends = friends;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching friends: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _searchFriends(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredFriends = friends;
      } else {
        filteredFriends = friends.where((user) {
          final name = user.name.toLowerCase();
          final phoneNumber = user.phoneNumber.toLowerCase();
          return name.contains(query.toLowerCase()) || phoneNumber.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<int> _getEventCountForFriend(String phoneNumber) async {
    return await _eventService.getEventCountForUser(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gift List Manager"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => navigateWithAnimation(context, const ProfilePage()),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => navigateWithAnimation(context, const EventListPage()),
                style: ElevatedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onPrimary,
                  backgroundColor: theme.colorScheme.primary,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Text("Create Your Own Event/List"),
              ),
            ),
            CustomSearchBar(
              onSearch: _searchFriends,
              hintText: "Search friends...",
            ),
            Expanded(
              child: filteredFriends.isEmpty
                  ? Center(
                child: Text(
                  'No friends found matching "$searchQuery".',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: filteredFriends.length,
                itemBuilder: (context, index) {
                  final friend = filteredFriends[index];
                  return FutureBuilder<int>(
                    future: _getEventCountForFriend(friend.phoneNumber),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError) {
                        return FriendListItem(
                          friendName: friend.name,
                          eventsCount: 0,
                          onTap: () => navigateWithAnimation(context, const EventListPage()),
                        );
                      }
                      final eventsCount = snapshot.data ?? 0;

                      return FriendListItem(
                        friendName: friend.name,
                        eventsCount: eventsCount,
                        onTap: () => navigateWithAnimation(context, const EventListPage()),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add Friends action
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
