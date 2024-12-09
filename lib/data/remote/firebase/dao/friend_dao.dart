import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/friend.dart';

class FriendDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextId() async {
    final counterDoc = _firestore.collection('counters').doc('friends');
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterDoc);
      int currentId = snapshot.exists ? snapshot['value'] as int : 0;
      transaction.update(counterDoc, {'value': currentId + 1});
      return currentId + 1;
    });
  }

  Future<void> addFriend(Friend friend) async {
    friend.id = await _getNextId();
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
