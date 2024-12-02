import '../app_database.dart';

class FriendDao {
  final AppDatabase _db;
  FriendDao(this._db);

  Future<void> insertFriend(Friend friend) async {
    await _db.into(_db.friends).insertOnConflictUpdate(friend);
  }

  Stream<List<Friend>> watchAllFriends() {
    return _db.select(_db.friends).watch();
  }

  /// Find all friends for a specific user by their phone number
  Stream<List<Friend>> findFriendsByUserPhoneNumber(String phoneNumber) {
    return (_db.select(_db.friends)..where((f) => f.userId.equals(phoneNumber))).watch();
  }

  Future<void> insertOrUpdateFriend(Friend friend) async {
    await _db.into(_db.friends).insertOnConflictUpdate(friend);
  }
}
