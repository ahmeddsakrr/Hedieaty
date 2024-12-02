import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/friend.dart';

class FriendDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFriend(Friend friend) async {
    await _firestore.collection('friends').doc(friend.id.toString()).set(friend.toMap());
  }

  Stream<List<Friend>> getFriendsByUser(String userId) {
    return _firestore
        .collection('friends')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Friend.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> removeFriend(int friendId) async {
    await _firestore.collection('friends').doc(friendId.toString()).delete();
  }
}
