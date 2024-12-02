import '../adapters/friend_adapter.dart';
import '../local/database/app_database.dart';
import '../local/database/dao/friend_dao.dart';
import '../remote/firebase/dao/friend_dao.dart' as RemoteFriendDao;
import '../remote/firebase/models/friend.dart' as RemoteFriend;

class FriendRepository {
  final FriendDao _localFriendDao;
  final RemoteFriendDao.FriendDAO _remoteFriendDao = RemoteFriendDao.FriendDAO();
  FriendRepository(AppDatabase db) : _localFriendDao = FriendDao(db);

  Future<void> addFriend(RemoteFriend.Friend friend) async {
    await _remoteFriendDao.addFriend(friend);
    final localFriend = FriendAdapter.fromRemote(friend);
    await _localFriendDao.insertOrUpdateFriend(localFriend);
  }

  Future<List<RemoteFriend.Friend>> getAllFriendsForUser(String userId) async {
    try {
      final remoteFriends = await _remoteFriendDao.getFriendsByUser(userId);
      for (final remoteFriend in remoteFriends) {
        final localFriend = FriendAdapter.fromRemote(remoteFriend);
        await _localFriendDao.insertOrUpdateFriend(localFriend);
      }
      return remoteFriends;
    } catch (e) {
      final localFriends = await _localFriendDao.findFriendsByUserPhoneNumber(userId);
      return localFriends.map((f) => FriendAdapter.fromLocal(f)).toList();
    }
  }
}
