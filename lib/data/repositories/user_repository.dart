import 'package:hedieaty/data/adapters/user_adapter.dart';

import '../local/database/app_database.dart';
import '../local/database/dao/user_dao.dart';
import '../remote/firebase/dao/user_dao.dart' as RemoteUserDao;
import '../remote/firebase/models/user.dart' as RemoteUser;


class UserRepository {
  final UserDao _localUserDao;
  final RemoteUserDao.UserDAO _remoteUserDao = RemoteUserDao.UserDAO();
  UserRepository(AppDatabase db) : _localUserDao = UserDao(db);

  Future<void> addUser(RemoteUser.User user) async {
    await _remoteUserDao.createUser(user);
    final localUser = UserAdapter.fromRemote(user);
    await _localUserDao.insertOrUpdateUser(localUser);
  }

  Future<RemoteUser.User?> getUserByPhoneNumber(String phoneNumber) async {
    try {
      final remoteUser = await _remoteUserDao.getUserByPhoneNumber(phoneNumber);
      if (remoteUser != null) {
        final localUser = UserAdapter.fromRemote(remoteUser);
        await _localUserDao.insertOrUpdateUser(localUser);
      }
      return remoteUser;
    } catch (e) {
      final localUser = await _localUserDao.findUserByPhoneNumber(phoneNumber);
      if (localUser != null) {
        return UserAdapter.fromLocal(localUser);
      }
    }
    return null;
  }

  Future<void> updateUser(RemoteUser.User user) async {
    await _remoteUserDao.updateUser(user);
    final localUser = UserAdapter.fromRemote(user);
    await _localUserDao.insertOrUpdateUser(localUser);
  }
}
