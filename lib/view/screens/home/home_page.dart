import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/controller/services/auth_service.dart';
import 'package:hedieaty/controller/services/event_service.dart';
import 'package:hedieaty/controller/services/user_service.dart';
import '../../../data/local/database/app_database.dart' as local;
import '../../../controller/services/friend_service.dart';
import '../../components/custom_search_bar.dart';
import '../../components/notification.dart';
import '../../widgets/friend/friend_list_item.dart';
import '../../widgets/home/add_friend_dialog.dart';
import '../event/event_list_page.dart';
import '../profile/profile_page.dart';
import '../../../controller/utils/navigation_utils.dart';
import '../../../data/remote/firebase/models/user.dart';
import 'package:hedieaty/data/remote/firebase/models/friend.dart';
import '../notifications/notification_list_page.dart';


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
  final UserService _userService = UserService(local.AppDatabase());
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

  Future<void> _addFriend(Friend friend) async {
    try {
      String currentUserId = await _authService.getCurrentUser();
      final currentUser = await _userService.getUser(currentUserId);
      if (currentUser == null) {
        NotificationHelper.showNotification(context, 'Failed to retrieve your account information.', isSuccess: false,);
        return;
      }
      if (friend.friendUserId == currentUser.phoneNumber) {
        NotificationHelper.showNotification(context, 'You cannot add yourself as a friend.', isSuccess: false,);
        return;
      }
      final friendUser = await _userService.getUser(friend.friendUserId);
      if (friendUser == null) {
        NotificationHelper.showNotification(context, 'The entered phone number does not exist.', isSuccess: false,);
        return;
      }
      if (await _friendService.isFriend(currentUserId, friend.friendUserId)) {
        NotificationHelper.showNotification(context, 'This user is already your friend.', isSuccess: false,);
        return;
      }
      await _friendService.addFriend(friend);
      String friendName = await _userService.getUser(friend.friendUserId).then((value) => value?.name) ?? '';
      NotificationHelper.showNotification(context, 'Friend $friendName was added successfully!',);
    } catch (e) {
      if (kDebugMode) {
        print('Error adding friend: $e');
      }
      NotificationHelper.showNotification(context, 'Failed to add friend', isSuccess: false);
    }
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
            onPressed: () => navigateWithAnimation(ProfilePage()),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () async {
              String userId = await _authService.getCurrentUser();
              navigateWithAnimation(NotificationsListPage(userId: userId));
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  String userId = await _authService.getCurrentUser();
                  navigateWithAnimation(EventListPage(userId: userId, canManageEvents: true,));
                },
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
                            profileImageUrl: friend.profilePictureUrl,
                            onTap: () => navigateWithAnimation(EventListPage(userId: friend.phoneNumber, canManageEvents: false,)),
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
        onPressed: () async {
          final userId = await _authService.getCurrentUser();
          if (userId.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) => AddFriendDialog(
                onSave: _addFriend,
                userId: userId,
              ),
            );
          } else {
            NotificationHelper.showNotification(context, 'Failed to fetch user ID', isSuccess: false);
          }
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
