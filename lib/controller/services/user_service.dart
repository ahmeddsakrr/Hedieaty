import '../../data/local/database/app_database.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/remote/firebase/models/user.dart' as RemoteUser;

class UserService {
  final UserRepository _userRepository;

  UserService(AppDatabase db) : _userRepository = UserRepository(db);

  Future<RemoteUser.User?> getUser(String phoneNumber) async {
    return await _userRepository.getUserByPhoneNumber(phoneNumber);
  }

  Future<void> updateUser(RemoteUser.User updatedUser) async {
    await _userRepository.updateUser(updatedUser);
  }

  String getUserPassword(String phoneNumber) {
    return _userRepository.getUserPassword(phoneNumber);
  }

  Future<void> updateUserProfilePicture(String userId, String url) async {
    RemoteUser.User? user = await getUser(userId);
    if (user != null) {
      user.profilePictureUrl = url;
      await updateUser(user);
    }
  }
}
