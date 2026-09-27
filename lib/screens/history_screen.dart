import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../models/history_event.dart';
import 'add_history_event_screen.dart';

class HistoryScreen extends StatefulWidget {
  final Item item;

  const HistoryScreen({
    super.key,
    required this.item,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> addEvent() async {
    final event = await Navigator.push<HistoryEvent>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddHistoryEventScreen(),
      ),
    );

    if (event != null) {
      setState(() {
        widget.item.history.add(event);
        widget.item.history.sort(
              (a, b) => b.date.compareTo(a.date),
        );
      });
    }
  }

  IconData getIcon(String type) {
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

  Color getColor(String type) {
    switch (type) {
      case 'Purchase':
        return Colors.green;
      case 'Repair':
        return Colors.orange;
      case 'Maintenance':
        return Colors.blue;
      case 'Location Change':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = widget.item.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item History'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addEvent,
        icon: const Icon(Icons.add),
        label: const Text('Add Event'),
      ),
      body: history.isEmpty
          ? _emptyState()
          : ListView(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          100,
        ),
        children: [
          _header(),

          const SizedBox(height: 28),

          ...history.asMap().entries.map(
                (entry) {
              final index = entry.key;
              final event = entry.value;

              return _timelineItem(
                event,
                index == history.length - 1,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.history,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.item.history.length} history event(s)',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineItem(
      HistoryEvent event,
      bool isLast,
      ) {
    final color = getColor(event.type);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 45,
          child: Column(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  getIcon(event.type),
                  color: color,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 95,
                  color: color.withValues(alpha: 0.2),
                ),
            ],
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      formatDate(event.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    event.type,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                if (event.description.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    event.description,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'No history yet',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Record repairs, maintenance, location changes and other important events.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: addEvent,
              icon: const Icon(Icons.add),
              label: const Text('Add First Event'),
            ),
          ],
        ),
      ),
    );
  }
}