import 'package:flutter/material.dart';
import '../../components/custom_search_bar.dart';
import '../../widgets/friend/friend_list_item.dart';
import '../event/event_list_page.dart';
import '../profile/profile_page.dart';
import '../../../controller/strategies/friend_search_context.dart';
import '../../../controller/strategies/search_by_name.dart';
import '../../../controller/utils/navigation_utils.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> friends = List.generate(10, (index) => 'Friend $index');
  List<String> filteredFriends = [];
  String searchQuery = "";
  final SearchContext _searchContext = SearchContext();

  @override
  void initState() {
    super.initState();
    filteredFriends = friends;
    _searchContext.setSearchStrategy(SearchByName());
  }

  void _searchFriends(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredFriends = friends;
      } else {
        filteredFriends = _searchContext.performSearch(friends, query);
      }
    });
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
                  return FriendListItem(
                    friendName: filteredFriends[index],
                    eventsCount: index % 2 == 0 ? 1 : 0,
                    onTap: () => navigateWithAnimation(context, const EventListPage()),
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
