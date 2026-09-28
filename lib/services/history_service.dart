import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    return user.uid;
  }

  Future<void> addHistory({
    required String itemId,
    required String title,
    required String description,
    required String type,
  }) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('items')
        .doc(itemId)
        .collection('history')
        .add({
      'title': title,
      'description': description,
      'type': type,
      'date': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getHistory(
      String itemId,
      ) {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('items')
        .doc(itemId)
        .collection('history')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<void> deleteHistory({
    required String itemId,
    required String historyId,
  }) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('items')
        .doc(itemId)
        .collection('history')
        .doc(historyId)
        .delete();
  }
}