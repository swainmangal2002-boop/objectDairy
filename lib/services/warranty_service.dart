import '../models/item_model.dart';

class WarrantyService {
  WarrantyService._();

  /// Returns the number of days remaining until warranty expiry.
  /// Negative value means the warranty has already expired.
  static int? daysRemaining(Item item) {
    if (item.warrantyExpiry == null) {
      return null;
    }

    final today = DateTime.now();

    final currentDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final expiryDate = DateTime(
      item.warrantyExpiry!.year,
      item.warrantyExpiry!.month,
      item.warrantyExpiry!.day,
    );

    return expiryDate.difference(currentDate).inDays;
  }

  /// Checks whether the warranty is currently active.
  static bool isActive(Item item) {
    final days = daysRemaining(item);

    if (days == null) {
      return false;
    }

    return days >= 0;
  }

  /// Checks whether the warranty will expire within 30 days.
  static bool isExpiringSoon(Item item) {
    final days = daysRemaining(item);

    if (days == null) {
      return false;
    }

    return days >= 0 && days <= 30;
  }

  /// Checks whether the warranty has expired.
  static bool isExpired(Item item) {
    final days = daysRemaining(item);

    if (days == null) {
      return false;
    }

    return days < 0;
  }

  /// Returns all items whose warranty expires within 30 days.
  static List<Item> getExpiringItems(List<Item> items) {
    return items.where((item) {
      return isExpiringSoon(item);
    }).toList();
  }

  /// Returns all items whose warranty has expired.
  static List<Item> getExpiredItems(List<Item> items) {
    return items.where((item) {
      return isExpired(item);
    }).toList();
  }

  /// Returns a readable reminder message.
  static String reminderMessage(Item item) {
    final days = daysRemaining(item);

    if (days == null) {
      return 'No warranty information available.';
    }

    if (days < 0) {
      final expiredDays = days.abs();

      if (expiredDays == 1) {
        return 'Warranty expired yesterday.';
      }

      return 'Warranty expired $expiredDays days ago.';
    }

    if (days == 0) {
      return 'Warranty expires today.';
    }

    if (days == 1) {
      return 'Warranty expires tomorrow.';
    }

    if (days <= 7) {
      return 'Warranty expires in $days days.';
    }

    if (days <= 30) {
      return 'Warranty expires in $days days.';
    }

    return 'Warranty is active.';
  }
}