import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/controller/services/user_service.dart';
import 'package:hedieaty/view/components/notification.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../controller/services/auth_service.dart';
import '../../../controller/services/imgbb_service.dart';
import 'profile_info_field.dart';
import 'package:hedieaty/data/local/database/app_database.dart';
import '../../../data/remote/firebase/models/user.dart' as RemoteUser;
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  String? profilePicUrl;
  bool isLoading = true;

  final UserService _userService = UserService(AppDatabase());
  final AuthService _authService = AuthService(AppDatabase());
  final ImgbbService _imgbbService = ImgbbService();

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
          profilePicUrl = user.profilePictureUrl;
          isLoading = false;
        });
      } else {
        NotificationHelper.showNotification(context, "Failed to fetch profile", isSuccess: false);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching profile: $e");
      }
      setState(() {
        isLoading = false;
      });
      NotificationHelper.showNotification(context, "Failed to fetch profile", isSuccess: false);
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

  Future<void> _updateProfilePicture() async {
    try {
      if (await Permission.photos.request().isGranted) {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          final url = await _imgbbService.uploadImage(image.path);
          if (url != null) {
            String userId = await _authService.getCurrentUser();
            await _userService.updateUserProfilePicture(userId, url);
            setState(() {
              profilePicUrl = url;
            });
            NotificationHelper.showNotification(context, "Profile picture updated successfully");
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error uploading profile picture: $e");
      }
      NotificationHelper.showNotification(context, "Failed to update profile picture", isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        GestureDetector(
          onTap: _updateProfilePicture,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: profilePicUrl != null
                ? NetworkImage(profilePicUrl!)
                : const AssetImage('images/user.jpg') as ImageProvider,
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
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
