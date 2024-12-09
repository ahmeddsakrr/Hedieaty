import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextId() async {
    final counterDoc = _firestore.collection('counters').doc('events');
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterDoc);
      int currentId = snapshot.exists ? snapshot['value'] as int : 0;
      transaction.update(counterDoc, {'value': currentId + 1});
      return currentId + 1;
    });
  }

  Future<void> createEvent(Event event) async {
    event.id = await _getNextId();
    await _firestore.collection('events').doc(event.id.toString()).set(event.toMap());
  }

  Stream<List<Event>> getEventsByUser(String userId) {
    return _firestore
        .collection('events')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Event.fromMap(doc.data()))
          .toList();
    });
  }


  Future<void> updateEvent(Event event) async {
    await _firestore.collection('events').doc(event.id.toString()).update(event.toMap());
  }

  Future<void> deleteEvent(int eventId) async {
    await _firestore.collection('events').doc(eventId.toString()).delete();
  }

  Stream<Event> getEvent(int eventId) {
    return _firestore
        .collection('events')
        .doc(eventId.toString())
        .snapshots()
        .map((docSnapshot) {
      return Event.fromMap(docSnapshot.data()!);
    });
  }
}
