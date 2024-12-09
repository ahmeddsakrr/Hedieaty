import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pledge.dart';

class PledgeDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextId() async {
    final counterDoc = _firestore.collection('counters').doc('pledges');
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

  Future<void> createPledge(Pledge pledge) async {
    pledge.id = await _getNextId();
    await _firestore.collection('pledges').doc(pledge.id.toString()).set(pledge.toMap());
  }

  Stream<List<Pledge>> getPledgesByUser(String userId) {
    return _firestore
        .collection('pledges')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Pledge.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> deletePledge(String userId, int pledgeId) async {
    final querySnapshot = await _firestore
        .collection('pledges')
        .where('user_id', isEqualTo: userId)
        .where('id', isEqualTo: pledgeId)
        .get();

    await querySnapshot.docs.first.reference.delete();
  }
}
