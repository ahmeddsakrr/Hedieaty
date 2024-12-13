import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextId() async {
    final counterDoc = _firestore.collection('counters').doc('events');
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

  Stream<List<Event>> getPublishedEventsForUser(String userId) {
    return _firestore
        .collection('events')
        .where('user_id', isEqualTo: userId)
        .where('is_published', isEqualTo: true)
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
