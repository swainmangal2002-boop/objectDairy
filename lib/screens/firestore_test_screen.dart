import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../services/firestore_service.dart';

class FirestoreTestScreen extends StatelessWidget {
  FirestoreTestScreen({super.key});

  final FirestoreService firestoreService =
  FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Test'),
      ),
      body: StreamBuilder<List<Item>>(
        stream: firestoreService.getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(
              child: Text('No items found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.inventory_2_outlined,
                  ),
                  title: Text(item.name),
                  subtitle: Text(
                    '${item.category} • ${item.location}',
                  ),
                  trailing: Text(
                    '₹${item.purchasePrice}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}