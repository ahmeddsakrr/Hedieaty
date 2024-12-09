import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification.dart';

class NotificationDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextId() async {
    final counterDoc = _firestore.collection('counters').doc('notifications');
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

  Future<void> createNotification(Notification notification) async {
    notification.id = await _getNextId();
    await _firestore
        .collection('notifications')
        .doc(notification.id.toString())
        .set(notification.toMap());
  }

  Stream<List<Notification>> getNotificationsByUser(String userId) {
    return _firestore
        .collection('notifications')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Notification.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> updateNotification(Notification notification) async {
    await _firestore
        .collection('notifications')
        .doc(notification.id.toString())
        .update(notification.toMap());
  }

  Future<void> deleteNotification(int notificationId) async {
    await _firestore.collection('notifications').doc(notificationId.toString()).delete();
  }
}
