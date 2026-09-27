import 'package:flutter/material.dart';
import '../models/item_model.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedCategory = 'Electronics';

  DateTime purchaseDate = DateTime.now();
  DateTime? warrantyExpiry;

  final categories = [
    'Electronics',
    'Books',
    'Furniture',
    'Documents',
    'Appliances',
    'Accessories',
    'Other',
  ];

  Future<void> selectPurchaseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: purchaseDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        purchaseDate = date;
      });
    }
  }

  Future<void> selectWarrantyDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        warrantyExpiry = date;
      });
    }
  }

  void saveItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final item = Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      category: selectedCategory,
      purchaseDate: purchaseDate,
      purchasePrice: double.parse(priceController.text.trim()),
      location: locationController.text.trim(),
      warrantyExpiry: warrantyExpiry,
      description: descriptionController.text.trim(),
    );

    Navigator.pop(context, item);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    locationController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Belonging'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Icon(
              Icons.inventory_2,
              size: 80,
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.inventory_2),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter item name';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Purchase Price',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter purchase price';
                }

                if (double.tryParse(value.trim()) == null) {
                  return 'Enter a valid price';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_month),
              title: const Text('Purchase Date'),
              subtitle: Text(
                '${purchaseDate.day}/${purchaseDate.month}/${purchaseDate.year}',
              ),
              onTap: selectPurchaseDate,
            ),

            const Divider(),

            TextFormField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Current Location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter current location';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.verified),
              title: const Text('Warranty Expiry'),
              subtitle: Text(
                warrantyExpiry == null
                    ? 'Not selected'
                    : '${warrantyExpiry!.day}/${warrantyExpiry!.month}/${warrantyExpiry!.year}',
              ),
              onTap: selectWarrantyDate,
            ),

            const Divider(),

            TextFormField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description / Notes',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: saveItem,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Save Belonging',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}