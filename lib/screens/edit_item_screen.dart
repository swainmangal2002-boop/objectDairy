import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../theme/app_theme.dart';

class EditItemScreen extends StatefulWidget {
  final Item item;

  const EditItemScreen({
    super.key,
    required this.item,
  });

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController locationController;
  late TextEditingController descriptionController;

  late String selectedCategory;
  late DateTime purchaseDate;
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
  void initState() {
    super.initState();

    final item = widget.item;

    nameController = TextEditingController(text: item.name);
    priceController = TextEditingController(
      text: item.purchasePrice.toStringAsFixed(2),
    );
    locationController =
        TextEditingController(text: item.location);
    descriptionController =
        TextEditingController(text: item.description);

    selectedCategory = item.category;
    purchaseDate = item.purchaseDate;
    warrantyExpiry = item.warrantyExpiry;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
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
  // DATE PICKER
  // ------------------------------------------------------------

  Future<void> _selectDate({
    required bool warranty,
  }) async {
    final initialDate = warranty
        ? (warrantyExpiry ?? DateTime.now())
        : purchaseDate;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
            Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;

    setState(() {
      if (warranty) {
        warrantyExpiry = date;
      } else {
        purchaseDate = date;
      }
    });
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
            crossAxisAlignment:
            CrossAxisAlignment.start,
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
          color: AppTheme.surface,
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
                crossAxisAlignment:
                CrossAxisAlignment.start,
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
                    selected
                        ? _formatDate(date)
                        : subtitle,
                    style: TextStyle(
                      color: selected
                          ? AppTheme.primary
                          : AppTheme.textGrey,
                      fontSize: 11.5,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.w400,
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
  // UPDATE ITEM
  // ------------------------------------------------------------

  void _updateItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final price =
    double.tryParse(priceController.text.trim());

    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid price'),
        ),
      );
      return;
    }

    widget.item.name = nameController.text.trim();
    widget.item.category = selectedCategory;
    widget.item.purchasePrice = price;
    widget.item.purchaseDate = purchaseDate;
    widget.item.location =
        locationController.text.trim();
    widget.item.warrantyExpiry = warrantyExpiry;
    widget.item.description =
        descriptionController.text.trim();

    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final categoryColor =
    AppTheme.categoryColor(selectedCategory);

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Edit Item',
          style: TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Save changes',
            onPressed: _updateItem,
            icon: const Icon(
              Icons.check_rounded,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            40,
          ),
          children: [
            // ====================================================
            // ITEM PREVIEW
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
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF4A4D78),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color:
                      categoryColor.withValues(alpha:0.15),
                      borderRadius:
                      BorderRadius.circular(17),
                    ),
                    child: Icon(
                      AppTheme.categoryIcon(
                        selectedCategory,
                      ),
                      color: categoryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Update Your Item',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Editing ${widget.item.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFBFC2DB),
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 27),

            // ====================================================
            // BASIC INFORMATION
            // ====================================================

            _sectionHeader(
              Icons.info_outline_rounded,
              'Basic Information',
              'Update the item details',
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: nameController,
              textCapitalization:
              TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                prefixIcon: Icon(
                  Icons.inventory_2_outlined,
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Please enter the item name';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              initialValue: categories.contains(
                selectedCategory,
              )
                  ? selectedCategory
                  : 'Other',
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(
                  Icons.category_outlined,
                ),
              ),
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Row(
                    children: [
                      Icon(
                        AppTheme.categoryIcon(category),
                        size: 18,
                        color:
                        AppTheme.categoryColor(category),
                      ),
                      const SizedBox(width: 9),
                      Text(category),
                    ],
                  ),
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

            const SizedBox(height: 27),

            // ====================================================
            // PURCHASE DETAILS
            // ====================================================

            _sectionHeader(
              Icons.shopping_bag_outlined,
              'Purchase Details',
              'Update purchase information',
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: priceController,
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Purchase Price',
                prefixIcon: Icon(
                  Icons.currency_rupee_rounded,
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Please enter the purchase price';
                }

                if (double.tryParse(value.trim()) ==
                    null) {
                  return 'Enter a valid price';
                }

                return null;
              },
            ),

            const SizedBox(height: 14),

            _dateField(
              title: 'Purchase Date',
              subtitle: 'Select purchase date',
              date: purchaseDate,
              onTap: () =>
                  _selectDate(warranty: false),
              icon: Icons.calendar_today_outlined,
            ),

            const SizedBox(height: 27),

            // ====================================================
            // LOCATION
            // ====================================================

            _sectionHeader(
              Icons.location_on_outlined,
              'Storage & Location',
              'Update where the item is kept',
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: locationController,
              textCapitalization:
              TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Current Location',
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Please enter the location';
                }
                return null;
              },
            ),

            const SizedBox(height: 27),

            // ====================================================
            // WARRANTY
            // ====================================================

            _sectionHeader(
              Icons.verified_outlined,
              'Warranty',
              'Update warranty information',
            ),

            const SizedBox(height: 14),

            _dateField(
              title: 'Warranty Expiry',
              subtitle: 'Optional',
              date: warrantyExpiry,
              onTap: () =>
                  _selectDate(warranty: true),
              icon: Icons.verified_outlined,
            ),

            if (warrantyExpiry != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      warrantyExpiry = null;
                    });
                  },
                  icon: const Icon(
                    Icons.clear_rounded,
                    size: 17,
                  ),
                  label: const Text(
                    'Remove warranty date',
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.error,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // ====================================================
            // DESCRIPTION
            // ====================================================

            _sectionHeader(
              Icons.notes_outlined,
              'Additional Information',
              'Update notes and other details',
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: descriptionController,
              maxLines: 5,
              textCapitalization:
              TextCapitalization.sentences,
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
                onPressed: _updateItem,
                icon: const Icon(
                  Icons.save_outlined,
                ),
                label: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: TextButton(
                onPressed: () =>
                    Navigator.pop(context),
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