import '../../data/local/database/app_database.dart';
import '../../data/repositories/user_repository.dart';

class UserService {
  final UserRepository _userRepository;

  UserService(AppDatabase db) : _userRepository = UserRepository(db);

  Future<User?> getUser(String phoneNumber) async {
    return await _userRepository.getUserByPhoneNumber(phoneNumber);
  }

  Future<void> updateUser(User updatedUser) async {
    await _userRepository.updateUser(updatedUser);
  }
}
