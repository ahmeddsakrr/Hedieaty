import '../local/database/app_database.dart';
import '../local/database/dao/friend_dao.dart';

class FriendRepository {
  final FriendDao _friendDao;
  FriendRepository(AppDatabase db) : _friendDao = FriendDao(db);

  Future<void> addFriend(Friend friend) async {
    await _friendDao.insertFriend(friend);
  }

  Stream<List<Friend>> watchAllFriends() {
    return _friendDao.watchAllFriends();
  }

  Future<List<Friend>> getAllFriendsForUser(String phoneNumber) async {
    return await _friendDao.findFriendsByUserPhoneNumber(phoneNumber).first;
  }
}
