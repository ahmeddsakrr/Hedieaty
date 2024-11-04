import '../database/app_database.dart';
import '../database/dao/user_dao.dart';
import '../database/models/user_table.dart';

class UserRepository {
  final UserDao _userDao;
  UserRepository(AppDatabase db) : _userDao = UserDao(db);

  Future<void> addUser(User user) async {
    await _userDao.insertUser(user);
  }

  Stream<List<User>> getAllUsers() {
    return _userDao.watchAllUsers();
  }

  Future<User?> getUserByPhoneNumber(String phoneNumber) {
    return _userDao.findUserByPhoneNumber(phoneNumber);
  }
}
