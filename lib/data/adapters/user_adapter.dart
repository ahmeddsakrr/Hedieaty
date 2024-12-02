import '../local/database/app_database.dart';
import '../remote/firebase/models/user.dart' as RemoteUser;

class UserAdapter {
  static User fromRemote(RemoteUser.User user) {
    return User(
      phoneNumber: user.phoneNumber,
      name: user.name,
      email: user.email,
      profilePictureUrl: user.profilePictureUrl,
    );
  }

  static RemoteUser.User fromLocal(User user) {
    return RemoteUser.User(
      phoneNumber: user.phoneNumber,
      name: user.name,
      email: user.email!,
      profilePictureUrl: user.profilePictureUrl,
      password: '', // Password isn't stored locally
    );
  }
}
