import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../services/item_service.dart';
import '../services/warranty_service.dart';
import '../widgets/item_card.dart';
import '../theme/app_theme.dart';
import 'add_item_screen.dart';
import 'item_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ItemService itemService = ItemService();
  final TextEditingController searchController = TextEditingController();

  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
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

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // FILTER
  // ------------------------------------------------------------

  List<Item> getFilteredItems() {
    final query = searchController.text.trim().toLowerCase();

    return itemService.items.where((item) {
      final matchesSearch =
          item.name.toLowerCase().contains(query) ||
              item.category.toLowerCase().contains(query) ||
              item.location.toLowerCase().contains(query);

      final matchesCategory =
          selectedCategory == 'All' ||
              item.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // ------------------------------------------------------------
  // ADD ITEM
  // ------------------------------------------------------------

  Future<void> _addItem() async {
    final item = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddItemScreen(),
      ),
    );

    if (item != null) {
      setState(() {
        itemService.addItem(item);
      });
    }
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildTopBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha:0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.14),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha:0.12),
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: Colors.white.withValues(alpha:0.16),
                ),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: Colors.white,
                size: 27,
              ),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ObjectDiary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your belongings. Your history.',
                    style: TextStyle(
                      color: Color(0xFFBFC2DB),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha:0.09),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha:0.13),
                ),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // STAT CARD
  // ------------------------------------------------------------

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String title,
    required Color iconColor,
    required Color iconBackground,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppTheme.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.035),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppTheme.textGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SEARCH
  // ------------------------------------------------------------

  Widget _buildSearchSection() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppTheme.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.025),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText:
              'Search belongings, categories or locations...',
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppTheme.textMedium,
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                onPressed: () {
                  searchController.clear();
                },
                icon: const Icon(
                  Icons.close_rounded,
                  size: 20,
                ),
              )
                  : null,
              filled: false,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 17,
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) =>
            const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categories[index];
              final selected = selectedCategory == category;

              return FilterChip(
                selected: selected,
                label: Text(category),
                onSelected: (_) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
                labelStyle: TextStyle(
                  color: selected
                      ? Colors.white
                      : AppTheme.textDark,
                  fontSize: 12,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
                backgroundColor: AppTheme.surface,
                selectedColor: AppTheme.primary,
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color: selected
                      ? AppTheme.primary
                      : AppTheme.borderDark,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // EMPTY STATE
  // ------------------------------------------------------------

  Widget _buildEmptyState({
    required bool hasItems,
  }) {
    final hasFilters =
        searchController.text.isNotEmpty ||
            selectedCategory != 'All';

    return Padding(
      padding: const EdgeInsets.only(
        top: 48,
        left: 20,
        right: 20,
      ),
      child: Column(
        children: [
          Container(
            width: 105,
            height: 105,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppTheme.primaryLight,
                  Color(0xFFDCD7FF),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFD1CBFF),
              ),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: AppTheme.primary,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            hasFilters
                ? 'No belongings found'
                : 'Start your ObjectDiary',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            hasFilters
                ? 'Try another search or category.'
                : 'Add your belongings and start keeping their digital history.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppTheme.textGrey,
            ),
          ),

          const SizedBox(height: 22),

          if (hasFilters)
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  searchController.clear();
                  selectedCategory = 'All';
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Clear Filters'),
            )
          else
            FilledButton.icon(
              onPressed: _addItem,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Your First Item'),
            ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // DELETE
  // ------------------------------------------------------------

  void _deleteItem(Item item) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text(
            'Are you sure you want to delete "${item.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.error,
              ),
              onPressed: () {
                setState(() {
                  itemService.deleteItem(item.id);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${item.name} deleted successfully',
                    ),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
// ------------------------------------------------------------
// WARRANTY ALERT
// ------------------------------------------------------------

  Widget _buildWarrantyAlert(int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.warning.withValues(alpha:0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.warning.withValues(alpha:0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppTheme.warning.withValues(alpha:0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppTheme.warning,
              size: 25,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count ${count == 1 ? 'item' : 'items'} expiring soon',
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Check your warranty before it expires.',
                  style: TextStyle(
                    color: AppTheme.textGrey,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.warning,
            size: 16,
          ),
        ],
      ),
    );
  }
  // ------------------------------------------------------------
  // MAIN SCREEN
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final allItems = itemService.items;
    final filteredItems = getFilteredItems();

    final warrantyCount = allItems.where((item) {
      return WarrantyService.isActive(item);
    }).length;

    final expiringSoonCount =
        WarrantyService.getExpiringItems(allItems).length;

    return Scaffold(
      backgroundColor: AppTheme.background,

      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),

            Expanded(
              child: RefreshIndicator(
                color: AppTheme.primary,
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    18,
                    16,
                    100,
                  ),
                  children: [
                    // Statistics
                    Row(
                      children: [
                        _buildStatCard(
                          icon: Icons.inventory_2_outlined,
                          value: '${allItems.length}',
                          title: 'Total Items',
                          iconColor: AppTheme.primary,
                          iconBackground:
                          AppTheme.primaryLight,
                        ),

                        const SizedBox(width: 12),

                        _buildStatCard(
                          icon: Icons.verified_outlined,
                          value: '$warrantyCount',
                          title: 'With Warranty',
                          iconColor: AppTheme.mint,
                          iconBackground:
                          AppTheme.mintLight,
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    if (expiringSoonCount > 0) ...[
                      _buildWarrantyAlert(expiringSoonCount),
                      const SizedBox(height: 22),
                    ],

                    _buildSearchSection(),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'My Belongings',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textDark,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ),
                        Text(
                          '${filteredItems.length} items',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    if (filteredItems.isEmpty)
                      _buildEmptyState(
                        hasItems: allItems.isNotEmpty,
                      )
                    else
                      ...filteredItems.map(
                            (item) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: ItemCard(
                            item: item,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ItemDetailsScreen(
                                        item: item,
                                      ),
                                ),
                              );

                              setState(() {});
                            },
                            onDelete: () {
                              _deleteItem(item);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha:0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _addItem,
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Add Item',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}