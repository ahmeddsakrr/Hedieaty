import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(User user) async {
    await _firestore.collection('users').doc(user.phoneNumber).set(user.toMap());
  }

  Future<User?> getUserByPhoneNumber(String phoneNumber) async {
    final doc = await _firestore.collection('users').doc(phoneNumber).get();
    if (doc.exists) {
      return User.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    await _firestore.collection('users').doc(user.phoneNumber).update(user.toMap());
  }

  Future<void> deleteUser(String phoneNumber) async {
    await _firestore.collection('users').doc(phoneNumber).delete();
  }

  String getUserPassword(String phoneNumber) {
    try {
      final doc = _firestore.collection('users').doc(phoneNumber).get();
      doc.then((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data();
          if (data != null && data.containsKey('password')) {
            return data['password'] as String;
          }
        }
        return 'password not found';
      });
    } catch (e) {
      return 'password not found';
    }
    return 'password not found';
  }
}
