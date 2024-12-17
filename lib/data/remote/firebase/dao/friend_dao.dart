import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/friend.dart';

class FriendDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextId() async {
    final counterDoc = _firestore.collection('counters').doc('friends');
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterDoc);
      if (!snapshot.exists) {
        transaction.set(counterDoc, {'value': 0});
        return 1;
      }
      int currentId = snapshot['value'] as int;
      int nextId = currentId + 1;
      transaction.update(counterDoc, {'value': nextId});
      return nextId;
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

  Future<bool> isFriend(String userId, String friendUserId) async {
    final snapshot = await _firestore
        .collection('friends')
        .where('user_id', isEqualTo: userId)
        .where('friend_user_id', isEqualTo: friendUserId)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }
}
