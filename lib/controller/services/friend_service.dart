import 'package:hedieaty/controller/services/user_service.dart';

import '../../data/local/database/app_database.dart';
import '../../data/repositories/friend_repository.dart';

class FriendService {
  final FriendRepository _friendRepository;
  final UserService _userService;

  FriendService(AppDatabase db)
      : _friendRepository = FriendRepository(db),
        _userService = UserService(db);

  /// Fetch all friends for a specific user ID.
  Future<List<User>> getFriendsForUser(String userId) async {
    final friends = await _friendRepository.getAllFriendsForUser(userId);
    final users = await Future.wait(
      friends.map((friend) => _userService.getUser(friend.friendUserId)),
    );
    return users.whereType<User>().toList(); // Exclude null users
  }

  /// Search friends by name or phone number.
  Future<List<User>> searchFriends(String userId, String query) async {
    final friends = await getFriendsForUser(userId);
    final lowerQuery = query.toLowerCase();

    return friends.where((user) {
      final name = user.name.toLowerCase();
      final phoneNumber = user.phoneNumber.toLowerCase();
      return name.contains(lowerQuery) || phoneNumber.contains(lowerQuery);
    }).toList();
  }
}
