import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gift.dart';

class GiftDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createGift(Gift gift) async {
    await _firestore.collection('gifts').doc(gift.id.toString()).set(gift.toMap());
  }

  Future<List<Gift>> getGiftsByEvent(int eventId) async {
    final querySnapshot = await _firestore
        .collection('gifts')
        .where('event_id', isEqualTo: eventId)
        .get();

    return querySnapshot.docs.map((doc) => Gift.fromMap(doc.data())).toList();
  }

  Future<void> updateGift(Gift gift) async {
    await _firestore.collection('gifts').doc(gift.id.toString()).update(gift.toMap());
  }

  Future<void> deleteGift(int giftId) async {
    await _firestore.collection('gifts').doc(giftId.toString()).delete();
  }
}
