import 'friend_search_strategy.dart';

class SearchByName implements SearchStrategy {
  @override
  List<String> search(List<String> friends, String query) {
    return friends.where((friend) {
      return friend.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}