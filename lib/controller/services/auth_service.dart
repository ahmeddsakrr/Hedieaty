import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hedieaty/data/repositories/user_repository.dart';
import '../../data/remote/firebase/models/user.dart' as RemoteUser;

import '../../data/local/database/app_database.dart' as AppDatabase;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository;

  AuthService(AppDatabase.AppDatabase db) : _userRepository = UserRepository(db);

  Future<User?> signup(String name, String email, String phoneNumber, String password) async {
    RemoteUser.User? user = await _userRepository.getUserByPhoneNumber(phoneNumber);
    if (user == null) {
      try {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? firebaseUser = result.user;
        if (firebaseUser != null) {
          await _userRepository.addUser(RemoteUser.User(
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            password: password,
          ));
        }
        await _saveCurrentUserPhoneNumber(phoneNumber);
        return firebaseUser;
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
        return null;
      }
    }
    return null;
  }

  Future<User?> login(String phoneNumber, String password) async {
    RemoteUser.User? user = await _userRepository.getUserByPhoneNumber(phoneNumber);
    if (user != null) {
      try {
        UserCredential result = await _auth.signInWithEmailAndPassword(
          email: user.email,
          password: password,
        );
        await _saveCurrentUserPhoneNumber(phoneNumber);
        return result.user;
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
        return null;
      }
    }
    return null;
  }

  Future<String> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('current_user_phone_number') ?? '';
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> _saveCurrentUserPhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user_phone_number', phoneNumber);
  }
}
