import 'package:flutter/material.dart';
import '../models/history_event.dart';

class AddHistoryEventScreen extends StatefulWidget {
  const AddHistoryEventScreen({super.key});

  @override
  State<AddHistoryEventScreen> createState() =>
      _AddHistoryEventScreenState();
}

class _AddHistoryEventScreenState
    extends State<AddHistoryEventScreen> {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedType = 'Repair';
  DateTime selectedDate = DateTime.now();

  final eventTypes = [
    'Purchase',
    'Repair',
    'Maintenance',
    'Location Change',
    'Other',
  ];

  Future<void> selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void saveEvent() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final event = HistoryEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: selectedType,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      date: selectedDate,
    );

    Navigator.pop(context, event);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  IconData getEventIcon(String type) {
    switch (type) {
      case 'Purchase':
        return Icons.shopping_bag_outlined;
      case 'Repair':
        return Icons.build_outlined;
      case 'Maintenance':
        return Icons.handyman_outlined;
      case 'Location Change':
        return Icons.location_on_outlined;
      default:
        return Icons.edit_note_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add History'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.secondaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Icon(
                    getEventIcon(selectedType),
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Record an important event',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Keep a complete history of your belonging.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            DropdownButtonFormField<String>(
              initialValue: selectedType,
              decoration: const InputDecoration(
                labelText: 'Event Type',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: eventTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
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

            const SizedBox(height: 18),

            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Event Title',
                hintText: 'Example: Screen repaired',
                prefixIcon: Icon(Icons.title_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter an event title';
                }
                return null;
              },
            ),

            const SizedBox(height: 18),

            InkWell(
              onTap: selectDate,
              borderRadius: BorderRadius.circular(16),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Event Date',
                  prefixIcon: Icon(Icons.calendar_month_outlined),
                ),
                child: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
              ),
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Add details about this event...',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes_outlined),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: saveEvent,
                icon: const Icon(Icons.save_outlined),
                label: const Text(
                  'Save History Event',
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