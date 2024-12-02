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
}
