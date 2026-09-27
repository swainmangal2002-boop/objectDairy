import 'package:flutter/material.dart';

import '../models/item_model.dart';
import 'history_screen.dart';

class ItemDetailsScreen extends StatelessWidget {
  final Item item;

  const ItemDetailsScreen({
    super.key,
    required this.item,
  });

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 55,
            child: Icon(
              Icons.inventory_2,
              size: 55,
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              item.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Text(
              item.category,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),

          const SizedBox(height: 24),

          _infoTile(
            Icons.currency_rupee,
            'Purchase Price',
            '₹${item.purchasePrice.toStringAsFixed(2)}',
          ),

          _infoTile(
            Icons.calendar_month,
            'Purchase Date',
            formatDate(item.purchaseDate),
          ),

          _infoTile(
            Icons.location_on,
            'Current Location',
            item.location,
          ),

          _infoTile(
            Icons.verified,
            'Warranty',
            item.warrantyExpiry == null
                ? 'Not available'
                : formatDate(item.warrantyExpiry!),
          ),

          _infoTile(
            Icons.notes,
            'Description',
            item.description.isEmpty
                ? 'No description'
                : item.description,
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HistoryScreen(
                      item: item,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.history),
              label: const Text(
                'View Item History',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
      IconData icon,
      String title,
      String value,
      ) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(value),
      ),
    );
  }
}