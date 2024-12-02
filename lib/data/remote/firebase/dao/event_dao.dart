import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createEvent(Event event) async {
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
