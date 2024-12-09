import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gift.dart';

class GiftDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextId() async {
    final counterDoc = _firestore.collection('counters').doc('gifts');
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

  Future<void> createGift(Gift gift) async {
    gift.id = await _getNextId();
    await _firestore.collection('gifts').doc(gift.id.toString()).set(gift.toMap());
  }

  Stream<List<Gift>> getGiftsByEvent(int eventId) {
    return _firestore
        .collection('gifts')
        .where('event_id', isEqualTo: eventId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Gift.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> updateGift(Gift gift) async {
    await _firestore.collection('gifts').doc(gift.id.toString()).update(gift.toMap());
  }

  Future<void> deleteGift(int giftId) async {
    await _firestore.collection('gifts').doc(giftId.toString()).delete();
  }

  Stream<Gift> getGift(int giftId) {
    return _firestore
        .collection('gifts')
        .doc(giftId.toString())
        .snapshots()
        .map((docSnapshot) {
        return Gift.fromMap(docSnapshot.data()!);
    });
  }

  Future<void> updateGiftStatus(int giftId, String status) async {
    await _firestore.collection('gifts').doc(giftId.toString()).update({'status': status});
  }
}
