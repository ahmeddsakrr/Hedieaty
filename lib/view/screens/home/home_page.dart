import 'package:flutter/material.dart';
import 'package:hedieaty/controller/services/auth_service.dart';
import 'package:hedieaty/controller/services/event_service.dart';
import '../../../data/local/database/app_database.dart' as local;
import '../../../controller/services/friend_service.dart';
import '../../components/custom_search_bar.dart';
import '../../widgets/friend/friend_list_item.dart';
import '../event/event_list_page.dart';
import '../profile/profile_page.dart';
import '../../../controller/utils/navigation_utils.dart';
import '../../../data/remote/firebase/models/user.dart';


class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FriendService _friendService = FriendService(local.AppDatabase());
  final EventService _eventService = EventService(local.AppDatabase());
  final AuthService _authService = AuthService(local.AppDatabase());
  List<User> friends = [];
  List<User> filteredFriends = [];
  String searchQuery = "";
  bool isLoading = true;


  Stream<List<User>> _fetchFriends() {
    return _authService.getCurrentUser().then((currentUser) {
      return _friendService.getFriendsForUser(currentUser);
    }).asStream().asyncExpand((stream) => stream);
  }

  Stream<List<User>> _searchFriends(String query) {
    if (query.isEmpty) {
      return _fetchFriends();
    } else {
      return _authService.getCurrentUser().then((currentUser) {
        return _friendService.searchFriends(currentUser, query);
      }).asStream().asyncExpand((stream) => stream);
    }
  }

  Stream<int> _getEventCountForFriend(String phoneNumber) {
    return _eventService.getEventCountForUser(phoneNumber);
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
            onPressed: () => navigateWithAnimation(context, ProfilePage()),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
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
              onSearch: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
              hintText: "Search friends...",
            ),
            Expanded(
              child: StreamBuilder<List<User>>(
                stream: _searchFriends(searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final filteredFriends = snapshot.data ?? [];

                  if (filteredFriends.isEmpty) {
                    return Center(
                      child: Text(
                        searchQuery.isEmpty
                            ? 'You have not added any friends yet.\nStart by adding a friend to your list!'
                            : 'No friends found matching "$searchQuery".',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredFriends.length,
                    itemBuilder: (context, index) {
                      final friend = filteredFriends[index];
                      return StreamBuilder<int>(
                        stream: _getEventCountForFriend(friend.phoneNumber),
                        builder: (context, eventSnapshot) {
                          if (eventSnapshot.connectionState == ConnectionState.waiting) {
                            return const ListTile(
                              title: Text('Loading...'),
                            );
                          }

                          final eventCount = eventSnapshot.data ?? 0;
                          return FriendListItem(
                            friendName: friend.name,
                            eventsCount: eventCount,
                            onTap: () => navigateWithAnimation(context, const EventListPage()),
                          );
                        },
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
