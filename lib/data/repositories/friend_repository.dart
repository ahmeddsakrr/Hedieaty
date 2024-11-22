import '../local/database/app_database.dart';
import '../local/database/dao/friend_dao.dart';
import '../local/database/models/friend_table.dart';

class FriendRepository {
  final FriendDao _friendDao;
  FriendRepository(AppDatabase db) : _friendDao = FriendDao(db);

  Future<void> addFriend(Friend friend) async {
    await _friendDao.insertFriend(friend);
  }

  Stream<List<Friend>> getAllFriends() {
    return _friendDao.watchAllFriends();
  }

  Future<List<Friend>> getFriendsForUser(String phoneNumber) {
    return _friendDao.findFriendsByUserPhoneNumber(phoneNumber);
  }
}
