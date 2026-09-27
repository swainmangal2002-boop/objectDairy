import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../theme/app_theme.dart';

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

  DateTime? purchaseDate;
  DateTime? warrantyExpiry;

  final List<String> categories = [
    'Electronics',
    'Books',
    'Furniture',
    'Documents',
    'Appliances',
    'Accessories',
    'Other',
  ];

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // DATE PICKER
  // ------------------------------------------------------------

  Future<void> _selectDate({
    required bool warranty,
  }) async {
    final initialDate = warranty
        ? (warrantyExpiry ?? DateTime.now())
        : (purchaseDate ?? DateTime.now());

    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected == null) return;

    setState(() {
      if (warranty) {
        warrantyExpiry = selected;
      } else {
        purchaseDate = selected;
      }
    });
  }

  // ------------------------------------------------------------
  // DATE FORMAT
  // ------------------------------------------------------------

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Select date';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ------------------------------------------------------------
  // SAVE ITEM
  // ------------------------------------------------------------

  void _saveItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (purchaseDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select the purchase date'),
        ),
      );
      return;
    }

    final price =
        double.tryParse(priceController.text.trim()) ?? 0;

    final item = Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      category: selectedCategory,
      purchaseDate: purchaseDate!,
      purchasePrice: price,
      location: locationController.text.trim(),
      warrantyExpiry: warrantyExpiry,
      description: descriptionController.text.trim(),
    );

    Navigator.pop(context, item);
  }

  // ------------------------------------------------------------
  // SECTION HEADER
  // ------------------------------------------------------------

  Widget _sectionHeader(
      IconData icon,
      String title,
      String subtitle,
      ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: AppTheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppTheme.textGrey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // DATE FIELD
  // ------------------------------------------------------------

  Widget _dateField({
    required String title,
    required String subtitle,
    required DateTime? date,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    final selected = date != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? AppTheme.primary.withValues(alpha:0.35)
                : AppTheme.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primaryLight
                    : AppTheme.surfaceSoft,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: selected
                    ? AppTheme.primary
                    : AppTheme.textGrey,
                size: 21,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    selected ? _formatDate(date) : subtitle,
                    style: TextStyle(
                      color: selected
                          ? AppTheme.primary
                          : AppTheme.textGrey,
                      fontSize: 11.5,
                      fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.textLight,
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Add New Item',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            120,
          ),
          children: [
            // ====================================================
            // INTRO
            // ====================================================

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.navy,
                    AppTheme.navyLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFF4A4D78),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha:0.10),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Record a belonging',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Add details so you can keep its history organized.',
                          style: TextStyle(
                            color: Color(0xFFBFC2DB),
                            fontSize: 11.5,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // ====================================================
            // BASIC INFORMATION
            // ====================================================

            _sectionHeader(
              Icons.info_outline_rounded,
              'Basic Information',
              'Tell us about your belonging',
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                hintText: 'e.g. MacBook Air M4',
                prefixIcon: Icon(
                  Icons.inventory_2_outlined,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the item name';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(
                  Icons.category_outlined,
                ),
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

            const SizedBox(height: 28),

            // ====================================================
            // PURCHASE DETAILS
            // ====================================================

            _sectionHeader(
              Icons.shopping_bag_outlined,
              'Purchase Details',
              'Keep track of when and how much',
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Purchase Price',
                hintText: 'e.g. 75000',
                prefixIcon: Icon(
                  Icons.currency_rupee_rounded,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the purchase price';
                }

                if (double.tryParse(value.trim()) == null) {
                  return 'Enter a valid price';
                }

                return null;
              },
            ),

            const SizedBox(height: 14),

            _dateField(
              title: 'Purchase Date',
              subtitle: 'When did you purchase it?',
              date: purchaseDate,
              onTap: () => _selectDate(warranty: false),
              icon: Icons.calendar_today_outlined,
            ),

            const SizedBox(height: 28),

            // ====================================================
            // STORAGE
            // ====================================================

            _sectionHeader(
              Icons.location_on_outlined,
              'Storage & Location',
              'Where is this item currently kept?',
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: locationController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'e.g. Bedroom, Office, Locker',
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the location';
                }
                return null;
              },
            ),

            const SizedBox(height: 28),

            // ====================================================
            // WARRANTY
            // ====================================================

            _sectionHeader(
              Icons.verified_outlined,
              'Warranty',
              'Save the warranty expiry date',
            ),

            const SizedBox(height: 14),

            _dateField(
              title: 'Warranty Expiry',
              subtitle: 'Optional',
              date: warrantyExpiry,
              onTap: () => _selectDate(warranty: true),
              icon: Icons.verified_outlined,
            ),

            const SizedBox(height: 28),

            // ====================================================
            // DESCRIPTION
            // ====================================================

            _sectionHeader(
              Icons.notes_outlined,
              'Additional Information',
              'Add notes or useful details',
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: descriptionController,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText:
                'Add notes, specifications, condition, etc.',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 72),
                  child: Icon(
                    Icons.notes_outlined,
                  ),
                ),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 30),

            // ====================================================
            // SAVE BUTTON
            // ====================================================

            SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: _saveItem,
                icon: const Icon(
                  Icons.check_rounded,
                ),
                label: const Text(
                  'Save Item',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppTheme.textGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}