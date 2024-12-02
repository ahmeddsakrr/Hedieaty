import '../app_database.dart';

class UserDao {
  final AppDatabase _db;
  UserDao(this._db);

  Future<void> insertUser(User user) async {
    await _db.into(_db.users).insert(user);
  }

  Stream<List<User>> watchAllUsers() {
    return _db.select(_db.users).watch();
  }

  Future<User?> findUserByPhoneNumber(String phoneNumber) {
    return (_db.select(_db.users)..where((u) => u.phoneNumber.equals(phoneNumber))).getSingleOrNull();
  }

  Future<void> updateUser(User updatedUser) async {
    await _db.update(_db.users).replace(updatedUser);
  }

  Future<void> insertOrUpdateUser(User user) async {
    await _db.into(_db.users).insertOnConflictUpdate(user);
  }
}
