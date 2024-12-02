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

  Stream<List<RemoteFriend.Friend>> getAllFriendsForUser(String userId) {
    return _remoteFriendDao
        .getFriendsByUser(userId)
        .handleError((error) {
      return _localFriendDao
          .findFriendsByUserPhoneNumber(userId)
          .map((localFriends) => localFriends.map((f) => FriendAdapter.fromLocal(f)).toList());
    }).map((remoteFriends) {
      for (final remoteFriend in remoteFriends) {
        final localFriend = FriendAdapter.fromRemote(remoteFriend);
        _localFriendDao.insertOrUpdateFriend(localFriend);
      }
      return remoteFriends;
    });
  }

}
