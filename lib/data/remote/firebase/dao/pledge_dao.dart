import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pledge.dart';

class PledgeDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createPledge(Pledge pledge) async {
    await _firestore.collection('pledges').doc(pledge.id.toString()).set(pledge.toMap());
  }

  Future<List<Pledge>> getPledgesByUser(String userId) async {
    final querySnapshot = await _firestore
        .collection('pledges')
        .where('user_id', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) => Pledge.fromMap(doc.data())).toList();
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
