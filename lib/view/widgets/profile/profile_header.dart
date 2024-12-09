import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/controller/services/user_service.dart';
import '../../../controller/services/auth_service.dart';
import 'profile_info_field.dart';
import 'package:hedieaty/data/local/database/app_database.dart';
import '../../../data/remote/firebase/models/user.dart' as RemoteUser;


class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  bool isLoading = true;

  final UserService _userService = UserService(AppDatabase());
  final AuthService _authService = AuthService(AppDatabase());

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      String userId = await _authService.getCurrentUser();
      final user = await _userService.getUser(userId);
      if (user != null) {
        setState(() {
          nameController = TextEditingController(text: user.name);
          phoneController = TextEditingController(text: user.phoneNumber);
          emailController = TextEditingController(text: user.email);
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not found")));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching profile: $e");
      }
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to load profile details")));
    }
  }

  Future<void> _saveUserProfile() async {
    String userId = await _authService.getCurrentUser();
    final updatedUser = RemoteUser.User(
      name: nameController.text,
      phoneNumber: phoneController.text,
      email: emailController.text,
      password: _userService.getUserPassword(userId),
    );
    await _userService.updateUser(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('images/user.jpg'),
        ),
        const SizedBox(height: 10),
        ProfileInfoField(
          label: "Name",
          controller: nameController,
          validator: (value) => value!.isEmpty ? "Name cannot be empty" : null,
          onSaved: _saveUserProfile,
        ),
        ProfileInfoField(
          label: "Phone No.",
          controller: phoneController,
          validator: (value) => value!.isEmpty ? "Phone number cannot be empty" : null,
          onSaved: _saveUserProfile,
        ),
        ProfileInfoField(
          label: "Email",
          controller: emailController,
          validator: (value) => value!.isEmpty ? "Email cannot be empty" : null,
          onSaved: _saveUserProfile,
        ),
      ],
    );
  }
}
