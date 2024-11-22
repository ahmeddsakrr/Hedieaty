import 'package:drift/drift.dart';
import '../app_database.dart';
import '../models/friend_table.dart';

class FriendDao {
  final AppDatabase _db;
  FriendDao(this._db);

  Future<void> insertFriend(Friend friend) async {
    await _db.into(_db.friends).insert(friend);
  }

  Stream<List<Friend>> watchAllFriends() {
    return _db.select(_db.friends).watch();
  }

  Future<List<Friend>> findFriendsByUserPhoneNumber(String phoneNumber) {
    return (_db.select(_db.friends)..where((f) => f.userId.equals(phoneNumber))).get();
  }
}
