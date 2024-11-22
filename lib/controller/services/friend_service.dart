import '../../data/local/database/app_database.dart';
import '../../data/repositories/friend_repository.dart';
import '../../data/repositories/user_repository.dart';

class FriendService {
  final FriendRepository _friendRepository;
  final UserRepository _userRepository;

  FriendService(this._friendRepository, this._userRepository);

  Future<List<Friend>> getFriends() async {
    return await _friendRepository.getAllFriends().first;
  }

  Future<void> addFriend(Friend friend) async {
    await _friendRepository.addFriend(friend);
  }

  Future<List<Friend>> searchFriends(String query) async {
    final friends = await getFriends();
    final lowerQuery = query.toLowerCase();

    final matchingFriends = await Future.wait(
      friends.map((friend) async {
        final user = await _userRepository.getUserByPhoneNumber(friend.friendUserId);
        final name = user?.name.toLowerCase() ?? '';
        final phoneNumber = friend.friendUserId.toLowerCase();

        if (name.contains(lowerQuery) || phoneNumber.contains(lowerQuery)) {
          return friend;
        }
        return null;
      }),
    );
    return matchingFriends.whereType<Friend>().toList();
  }
}
