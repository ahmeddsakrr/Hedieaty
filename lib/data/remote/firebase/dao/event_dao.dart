import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createEvent(Event event) async {
    await _firestore.collection('events').doc(event.id.toString()).set(event.toMap());
  }

  Future<List<Event>> getEventsByUser(String userId) async {
    final querySnapshot = await _firestore
        .collection('events')
        .where('user_id', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();
  }

  Future<void> updateEvent(Event event) async {
    await _firestore.collection('events').doc(event.id.toString()).update(event.toMap());
  }

  Future<void> deleteEvent(int eventId) async {
    await _firestore.collection('events').doc(eventId.toString()).delete();
  }
}
