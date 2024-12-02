import 'package:hedieaty/controller/services/user_service.dart';

import '../../data/local/database/app_database.dart';
import '../../data/repositories/friend_repository.dart';
import '../../data/remote/firebase/models/user.dart' as RemoteUser;

class FriendService {
  final FriendRepository _friendRepository;
  final UserService _userService;

  FriendService(AppDatabase db)
      : _friendRepository = FriendRepository(db),
        _userService = UserService(db);

  /// Fetch all friends for a specific user ID.
  Stream<List<RemoteUser.User>> getFriendsForUser(String userId) {
    return _friendRepository.getAllFriendsForUser(userId).asyncMap((friends) async {
      final users = await Future.wait(
        friends.map((friend) => _userService.getUser(friend.friendUserId)),
      );
      return users.whereType<RemoteUser.User>().toList();
    });
  }

  /// Search friends by name or phone number.
  Stream<List<RemoteUser.User>> searchFriends(String userId, String query) {
    final lowerQuery = query.toLowerCase();

    return getFriendsForUser(userId).map((friends) {
      return friends.where((user) {
        final name = user.name.toLowerCase();
        final phoneNumber = user.phoneNumber.toLowerCase();
        return name.contains(lowerQuery) || phoneNumber.contains(lowerQuery);
      }).toList();
    });
  }

}
