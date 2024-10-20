import 'friend_search_strategy.dart';

class SearchContext {
  SearchStrategy? _searchStrategy;

  void setSearchStrategy(SearchStrategy strategy) {
    _searchStrategy = strategy;
  }

  List<String> performSearch(List<String> friends, String query) {
    if (_searchStrategy != null) {
      return _searchStrategy!.search(friends, query);
    }
    return friends; // If no strategy is set, return the original list
  }
}
