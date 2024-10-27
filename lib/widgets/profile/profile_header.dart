import 'package:flutter/material.dart';
import 'profile_info_field.dart';

class ProfileHeader extends StatelessWidget {
  final TextEditingController nameController = TextEditingController(text: "John Doe");
  final TextEditingController phoneController = TextEditingController(text: "123-456-7890");
  final TextEditingController emailController = TextEditingController(text: "johndoe@example.com");

  ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
        ),
        ProfileInfoField(
          label: "Phone No.",
          controller: phoneController,
          validator: (value) => value!.isEmpty ? "Phone number cannot be empty" : null,
        ),
        ProfileInfoField(
          label: "Email",
          controller: emailController,
          validator: (value) => value!.isEmpty ? "Email cannot be empty" : null,
        ),
      ],
    );
  }
}
