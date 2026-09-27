import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../theme/app_theme.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppTheme.categoryColor(item.category);
    final categoryIcon = AppTheme.categoryIcon(item.category);

    final hasWarranty = item.warrantyExpiry != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppTheme.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Item icon
              Container(
                height: 62,
                width: 62,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: categoryColor.withOpacity(0.12),
                  ),
                ),
                child: Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: 29,
                ),
              ),

              const SizedBox(width: 14),

              // Item information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      item.category,
                      style: TextStyle(
                        color: categoryColor,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 9),

                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: AppTheme.textGrey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.location.isEmpty
                                ? 'Location not added'
                                : item.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppTheme.textGrey,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    // Warranty
                    Row(
                      children: [
                        Icon(
                          hasWarranty
                              ? Icons.verified_outlined
                              : Icons.info_outline_rounded,
                          size: 14,
                          color: hasWarranty
                              ? AppTheme.success
                              : AppTheme.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hasWarranty
                              ? 'Warranty available'
                              : 'No warranty added',
                          style: TextStyle(
                            color: hasWarranty
                                ? AppTheme.success
                                : AppTheme.textLight,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              // Menu
              PopupMenuButton<String>(
                tooltip: 'Item options',
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppTheme.textGrey,
                  size: 22,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    onDelete();
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
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Delete',
                          style: TextStyle(
                            color: AppTheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}