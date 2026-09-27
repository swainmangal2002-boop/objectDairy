import 'package:flutter/material.dart';

import '../models/history_event.dart';
import '../theme/app_theme.dart';

class AddHistoryEventScreen extends StatefulWidget {
  const AddHistoryEventScreen({super.key});

  @override
  State<AddHistoryEventScreen> createState() =>
      _AddHistoryEventScreenState();
}

class _AddHistoryEventScreenState
    extends State<AddHistoryEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedType = 'Purchase';
  DateTime selectedDate = DateTime.now();

  final List<String> eventTypes = [
    'Purchase',
    'Repair',
    'Maintenance',
    'Location Change',
    'Other',
  ];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // EVENT ICON
  // ------------------------------------------------------------

  IconData _getEventIcon(String type) {
    switch (type.toLowerCase()) {
      case 'purchase':
        return Icons.shopping_bag_outlined;

      case 'repair':
        return Icons.build_outlined;

      case 'maintenance':
        return Icons.handyman_outlined;

      case 'location change':
        return Icons.location_on_outlined;

      default:
        return Icons.more_horiz_rounded;
    }
  }

  // ------------------------------------------------------------
  // EVENT COLOR
  // ------------------------------------------------------------

  Color _getEventColor(String type) {
    switch (type.toLowerCase()) {
      case 'purchase':
        return AppTheme.primary;

      case 'repair':
        return AppTheme.error;

      case 'maintenance':
        return AppTheme.warning;

      case 'location change':
        return AppTheme.info;

      default:
        return AppTheme.mint;
    }
  }

  // ------------------------------------------------------------
  // DATE FORMAT
  // ------------------------------------------------------------

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ------------------------------------------------------------
  // DATE PICKER
  // ------------------------------------------------------------

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context)
                .colorScheme
                .copyWith(
              primary: AppTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  // ------------------------------------------------------------
  // SAVE EVENT
  // ------------------------------------------------------------

  void _saveEvent() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final event = HistoryEvent(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      type: selectedType,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      date: selectedDate,
    );

    Navigator.pop(context, event);
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

  Widget _dateField() {
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppTheme.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: AppTheme.primary,
                size: 21,
              ),
            ),

            const SizedBox(width: 12),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Date',
                    style: TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3),
                ],
              ),
            ),

            Text(
              _formatDate(selectedDate),
              style: const TextStyle(
                color: AppTheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(width: 5),

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
    final eventColor = _getEventColor(selectedType);
    final eventIcon = _getEventIcon(selectedType);

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Add History Event',
          style: TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.w800,
          ),
        ),
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
            // EVENT PREVIEW
            // ====================================================

            Container(
              padding: const EdgeInsets.all(20),
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
                      color: eventColor.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(
                        color: eventColor.withOpacity(0.25),
                      ),
                    ),
                    child: Icon(
                      eventIcon,
                      color: eventColor,
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
                          'New Timeline Event',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Record a ${selectedType.toLowerCase()} event',
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
            // EVENT TYPE
            // ====================================================

            _sectionHeader(
              Icons.category_outlined,
              'Event Type',
              'What happened to this item?',
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              initialValue: selectedType,
              decoration: const InputDecoration(
                labelText: 'Event Type',
                prefixIcon: Icon(
                  Icons.timeline_rounded,
                ),
              ),
              items: eventTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Row(
                    children: [
                      Icon(
                        _getEventIcon(type),
                        size: 19,
                        color: _getEventColor(type),
                      ),
                      const SizedBox(width: 10),
                      Text(type),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedType = value;
                  });
                }
              },
            ),

            const SizedBox(height: 27),

            // ====================================================
            // EVENT DETAILS
            // ====================================================

            _sectionHeader(
              Icons.edit_note_rounded,
              'Event Details',
              'Describe what happened',
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: titleController,
              textCapitalization:
              TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Event Title',
                hintText: 'e.g. Screen repaired',
                prefixIcon: Icon(
                  Icons.title_rounded,
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Please enter an event title';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            _dateField(),

            const SizedBox(height: 14),

            TextFormField(
              controller: descriptionController,
              maxLines: 5,
              textCapitalization:
              TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText:
                'Add additional details about this event...',
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
            // SAVE
            // ====================================================

            SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: _saveEvent,
                icon: const Icon(
                  Icons.add_rounded,
                ),
                label: const Text(
                  'Add to Timeline',
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