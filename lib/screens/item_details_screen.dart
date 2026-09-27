import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../theme/app_theme.dart';
import 'edit_item_screen.dart';
import 'history_screen.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Item item;

  const ItemDetailsScreen({
    super.key,
    required this.item,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  Item get item => widget.item;

  // ------------------------------------------------------------
  // WARRANTY STATUS
  // ------------------------------------------------------------

  String get warrantyStatus {
    if (item.warrantyExpiry == null) {
      return 'No Warranty';
    }

    final today = DateTime.now();

    final expiry = DateTime(
      item.warrantyExpiry!.year,
      item.warrantyExpiry!.month,
      item.warrantyExpiry!.day,
    );

    final currentDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final difference = expiry.difference(currentDate).inDays;

    if (difference < 0) {
      return 'Expired';
    }

    if (difference <= 30) {
      return 'Expiring Soon';
    }

    return 'Active';
  }

  int? get warrantyDaysRemaining {
    if (item.warrantyExpiry == null) {
      return null;
    }

    final today = DateTime.now();

    final expiry = DateTime(
      item.warrantyExpiry!.year,
      item.warrantyExpiry!.month,
      item.warrantyExpiry!.day,
    );

    final currentDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    return expiry.difference(currentDate).inDays;
  }

  Color get warrantyColor {
    switch (warrantyStatus) {
      case 'Active':
        return AppTheme.success;

      case 'Expiring Soon':
        return AppTheme.warning;

      case 'Expired':
        return AppTheme.error;

      default:
        return AppTheme.textGrey;
    }
  }

  IconData get warrantyIcon {
    switch (warrantyStatus) {
      case 'Active':
        return Icons.verified_rounded;

      case 'Expiring Soon':
        return Icons.warning_amber_rounded;

      case 'Expired':
        return Icons.cancel_outlined;

      default:
        return Icons.info_outline_rounded;
    }
  }

  // ------------------------------------------------------------
  // DATE FORMAT
  // ------------------------------------------------------------

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ------------------------------------------------------------
  // EDIT
  // ------------------------------------------------------------

  Future<void> _editItem() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditItemScreen(item: item),
      ),
    );

    setState(() {});
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader() {
    final categoryColor =
    AppTheme.categoryColor(item.category);

    final categoryIcon =
    AppTheme.categoryIcon(item.category);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        24,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.navy,
            AppTheme.navyLight,
            AppTheme.primaryDark,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),

              const Spacer(),

              IconButton(
                onPressed: _editItem,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: categoryColor.withOpacity(0.30),
                  ),
                ),
                child: Icon(
                  categoryIcon,
                  color: Colors.white,
                  size: 34,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      item.category,
                      style: const TextStyle(
                        color: Color(0xFFC9CBE0),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // INFORMATION CARD
  // ------------------------------------------------------------

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    Color? iconColor,
  }) {
    final color = iconColor ?? AppTheme.primary;

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textGrey,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // WARRANTY CARD
  // ------------------------------------------------------------

  Widget _buildWarrantyCard() {
    final days = warrantyDaysRemaining;

    String message;

    if (item.warrantyExpiry == null) {
      message = 'No warranty expiry date has been added.';
    } else if (days! < 0) {
      message =
      'Warranty expired ${days.abs()} days ago.';
    } else if (days == 0) {
      message = 'Warranty expires today.';
    } else if (days == 1) {
      message = 'Warranty expires tomorrow.';
    } else if (days <= 30) {
      message = 'Warranty expires in $days days.';
    } else {
      message = 'Warranty is currently active.';
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: warrantyColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: warrantyColor.withOpacity(0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: warrantyColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  warrantyIcon,
                  color: warrantyColor,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Warranty Status',
                      style: TextStyle(
                        color: AppTheme.textGrey,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      warrantyStatus,
                      style: TextStyle(
                        color: warrantyColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (item.warrantyExpiry != null) ...[
            const Divider(),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.event_outlined,
                  size: 18,
                  color: AppTheme.textGrey,
                ),

                const SizedBox(width: 8),

                const Text(
                  'Expiry Date',
                  style: TextStyle(
                    color: AppTheme.textGrey,
                    fontSize: 12,
                  ),
                ),

                const Spacer(),

                Text(
                  _formatDate(item.warrantyExpiry!),
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
          ],

          Text(
            message,
            style: TextStyle(
              color: warrantyColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // HISTORY BUTTON
  // ------------------------------------------------------------

  Widget _buildHistoryButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HistoryScreen(item: item),
          ),
        );

        setState(() {});
      },
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.navy,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.timeline_rounded,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 13),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'View repairs, maintenance and updates',
                    style: TextStyle(
                      color: Color(0xFFBFC2DB),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 17,
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

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  20,
                  16,
                  30,
                ),
                children: [
                  const Text(
                    'Purchase Information',
                    style: TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.calendar_today_outlined,
                          title: 'Purchase Date',
                          value: _formatDate(
                            item.purchaseDate,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.currency_rupee_rounded,
                          title: 'Purchase Price',
                          value:
                          '₹${item.purchasePrice.toStringAsFixed(2)}',
                          iconColor: AppTheme.mint,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.location_on_outlined,
                    title: 'Current Location',
                    value: item.location.isEmpty
                        ? 'Location not added'
                        : item.location,
                    iconColor: AppTheme.info,
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Warranty',
                    style: TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildWarrantyCard(),

                  if (item.description.isNotEmpty) ...[
                    const SizedBox(height: 24),

                    const Text(
                      'Description',
                      style: TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.border,
                        ),
                      ),
                      child: Text(
                        item.description,
                        style: const TextStyle(
                          color: AppTheme.textMedium,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  _buildHistoryButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}