import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification.dart';

class NotificationDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextId() async {
    final counterDoc = _firestore.collection('counters').doc('notifications');
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterDoc);
      int currentId = snapshot.exists ? snapshot['value'] as int : 0;
      transaction.update(counterDoc, {'value': currentId + 1});
      return currentId + 1;
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
