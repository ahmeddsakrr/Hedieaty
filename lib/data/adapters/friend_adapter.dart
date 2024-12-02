import '../local/database/app_database.dart';
import '../remote/firebase/models/friend.dart' as RemoteFriend;

class FriendAdapter {
  static Friend fromRemote(RemoteFriend.Friend friend) {
    return Friend(
      id: friend.id,
      userId: friend.userId,
      friendUserId: friend.friendUserId,
    );
  }

  static RemoteFriend.Friend fromLocal(Friend friend) {
    return RemoteFriend.Friend(
      id: friend.id,
      userId: friend.userId,
      friendUserId: friend.friendUserId,
    );
  }
}
