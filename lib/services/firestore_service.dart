import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/item_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _itemsCollection {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('items');
  }

  Future<void> addItem(Item item) async {
    await _itemsCollection.doc(item.id).set({
      'name': item.name,
      'category': item.category,
      'purchaseDate': item.purchaseDate.toIso8601String(),
      'purchasePrice': item.purchasePrice,
      'location': item.location,
      'warrantyExpiry':
      item.warrantyExpiry?.toIso8601String(),
      'description': item.description,
    });
  }

  Stream<List<Item>> getItems() {
    return _itemsCollection
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return Item(
          id: doc.id,
          name: data['name'] ?? '',
          category: data['category'] ?? '',
          purchaseDate: DateTime.parse(
            data['purchaseDate'],
          ),
          purchasePrice:
          (data['purchasePrice'] ?? 0).toDouble(),
          location: data['location'] ?? '',
          warrantyExpiry:
          data['warrantyExpiry'] != null
              ? DateTime.parse(
            data['warrantyExpiry'],
          )
              : null,
          description: data['description'] ?? '',
        );
      }).toList();
    });
  }

  Future<void> deleteItem(String itemId) async {
    await _itemsCollection.doc(itemId).delete();
  }
}