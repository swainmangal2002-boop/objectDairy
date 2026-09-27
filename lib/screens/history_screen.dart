import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../models/history_event.dart';
import '../theme/app_theme.dart';
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
  Item get item => widget.item;

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

      case 'other':
        return Icons.more_horiz_rounded;

      default:
        return Icons.history_rounded;
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

      case 'other':
        return AppTheme.mint;

      default:
        return AppTheme.primary;
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
  // ADD EVENT
  // ------------------------------------------------------------

  Future<void> _addEvent() async {
    final event = await Navigator.push<HistoryEvent>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddHistoryEventScreen(),
      ),
    );

    if (event != null) {
      setState(() {
        item.history.add(event);
        item.history.sort(
              (a, b) => b.date.compareTo(a.date),
        );
      });
    }
  }

  // ------------------------------------------------------------
  // DELETE EVENT
  // ------------------------------------------------------------

  void _deleteEvent(HistoryEvent event) {
    setState(() {
      item.history.removeWhere(
            (element) => element.id == event.id,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('History event deleted'),
      ),
    );
  }

  // ------------------------------------------------------------
  // EVENT CARD
  // ------------------------------------------------------------

  Widget _buildEventCard(
      HistoryEvent event,
      int index,
      bool isLast,
      ) {
    final eventColor = _getEventColor(event.type);
    final eventIcon = _getEventIcon(event.type);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --------------------------------------------------------
        // TIMELINE
        // --------------------------------------------------------

        SizedBox(
          width: 54,
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: eventColor.withValues(alpha:0.10),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: eventColor.withValues(alpha:0.18),
                  ),
                ),
                child: Icon(
                  eventIcon,
                  color: eventColor,
                  size: 20,
                ),
              ),

              if (!isLast)
                Container(
                  width: 2,
                  height: 105,
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: eventColor.withValues(alpha:0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // --------------------------------------------------------
        // EVENT CONTENT
        // --------------------------------------------------------

        Expanded(
          child: Container(
            margin: EdgeInsets.only(
              bottom: isLast ? 0 : 14,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: eventColor.withValues(alpha:0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event type + date
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: eventColor.withValues(alpha:0.09),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.type,
                        style: TextStyle(
                          color: eventColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    const Spacer(),

                    Text(
                      _formatDate(event.date),
                      style: const TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 10.5,
                      ),
                    ),

                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      icon: const Icon(
                        Icons.more_horiz_rounded,
                        color: AppTheme.textLight,
                        size: 19,
                      ),
                      onSelected: (value) {
                        if (value == 'delete') {
                          _deleteEvent(event);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline_rounded,
                                color: AppTheme.error,
                                size: 19,
                              ),
                              SizedBox(width: 9),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: AppTheme.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 11),

                // Title
                Text(
                  event.title,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                // Description
                if (event.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Text(
                    event.description,
                    style: const TextStyle(
                      color: AppTheme.textGrey,
                      fontSize: 11.5,
                      height: 1.45,
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

  // ------------------------------------------------------------
  // EMPTY STATE
  // ------------------------------------------------------------

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.timeline_rounded,
              color: AppTheme.primary,
              size: 40,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'No history yet',
            style: TextStyle(
              color: AppTheme.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Record purchases, repairs, maintenance, '
                'location changes and other important events.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textGrey,
              fontSize: 12,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: _addEvent,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add First Event'),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final events = [...item.history];

    events.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Item History',
          style: TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          110,
        ),
        children: [
          // ======================================================
          // HEADER
          // ======================================================

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
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha:0.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.timeline_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${events.length} recorded '
                            '${events.length == 1 ? 'event' : 'events'}',
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

          const SizedBox(height: 26),

          // ======================================================
          // TIMELINE TITLE
          // ======================================================

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Timeline',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
              ),

              if (events.isNotEmpty)
                Text(
                  'Newest first',
                  style: const TextStyle(
                    color: AppTheme.textGrey,
                    fontSize: 11,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // ======================================================
          // EVENTS
          // ======================================================

          if (events.isEmpty)
            _buildEmptyState()
          else
            ...List.generate(
              events.length,
                  (index) {
                return _buildEventCard(
                  events[index],
                  index,
                  index == events.length - 1,
                );
              },
            ),
        ],
      ),

      // ========================================================
      // ADD EVENT BUTTON
      // ========================================================

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addEvent,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Event',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}