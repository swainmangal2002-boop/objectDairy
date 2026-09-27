import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ============================================================
  // BRAND COLORS
  // ============================================================

  static const Color primary = Color(0xFF7567F8);
  static const Color primaryDark = Color(0xFF5E52D6);
  static const Color primaryLight = Color(0xFFEAE7FF);

  static const Color navy = Color(0xFF171A35);
  static const Color navyLight = Color(0xFF292D59);

  static const Color mint = Color(0xFF38C99A);
  static const Color mintLight = Color(0xFFE2F8F0);

  // ============================================================
  // BACKGROUND COLORS
  // ============================================================

  static const Color background = Color(0xFFF6F7FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFF1F2F8);

  // ============================================================
  // TEXT COLORS
  // ============================================================

  static const Color textDark = Color(0xFF1D2035);
  static const Color textMedium = Color(0xFF55586D);
  static const Color textGrey = Color(0xFF777A8A);
  static const Color textLight = Color(0xFF999CAA);

  // ============================================================
  // BORDER COLORS
  // ============================================================

  static const Color border = Color(0xFFE5E6EF);
  static const Color borderDark = Color(0xFFDCDDE7);

  // ============================================================
  // CATEGORY COLORS
  // ============================================================

  static const Color electronics = Color(0xFF7567F8);
  static const Color books = Color(0xFF4F8EF7);
  static const Color furniture = Color(0xFFE58A45);
  static const Color documents = Color(0xFF5B9BD5);
  static const Color appliances = Color(0xFF38BFA0);
  static const Color accessories = Color(0xFFE56B9F);
  static const Color other = Color(0xFF7567F8);

  // ============================================================
  // STATUS COLORS
  // ============================================================

  static const Color success = Color(0xFF38C99A);
  static const Color warning = Color(0xFFF2A93B);
  static const Color error = Color(0xFFE05260);
  static const Color info = Color(0xFF4F8EF7);

  // ============================================================
  // MAIN THEME
  // ============================================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      brightness: Brightness.light,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ).copyWith(
        primary: primary,
        onPrimary: Colors.white,
        secondary: mint,
        onSecondary: Colors.white,
        surface: surface,
        onSurface: textDark,
        error: error,
        onError: Colors.white,
      ),

      scaffoldBackgroundColor: background,

      fontFamily: 'Roboto',

      // ========================================================
      // APP BAR
      // ========================================================

      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textDark,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),

      // ========================================================
      // INPUT FIELDS
      // ========================================================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        hintStyle: const TextStyle(
          color: textLight,
          fontSize: 13,
        ),

        labelStyle: const TextStyle(
          color: textMedium,
          fontSize: 13,
        ),

        prefixIconColor: textGrey,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: border,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: border,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: primary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: error,
            width: 1.5,
          ),
        ),
      ),

      // ========================================================
      // CARDS
      // ========================================================

      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: border,
          ),
        ),
      ),

      // ========================================================
      // BUTTONS
      // ========================================================

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          side: const BorderSide(
            color: primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // ========================================================
      // FLOATING ACTION BUTTON
      // ========================================================

      floatingActionButtonTheme:
      const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
        ),
      ),

      // ========================================================
      // CHIPS
      // ========================================================

      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: primary,
        disabledColor: surfaceSoft,

        side: const BorderSide(
          color: borderDark,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        labelStyle: const TextStyle(
          color: textDark,
          fontSize: 12,
        ),

        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 4,
        ),
      ),

      // ========================================================
      // DIVIDERS
      // ========================================================

      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),

      // ========================================================
      // ICON THEME
      // ========================================================

      iconTheme: const IconThemeData(
        color: textMedium,
        size: 24,
      ),

      // ========================================================
      // SNACKBAR
      // ========================================================

      snackBarTheme: SnackBarThemeData(
        backgroundColor: navy,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // CATEGORY COLOR HELPER
  // ============================================================

  static Color categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return electronics;

      case 'books':
        return books;

      case 'furniture':
        return furniture;

      case 'documents':
        return documents;

      case 'appliances':
        return appliances;

      case 'accessories':
        return accessories;

      default:
        return other;
    }
  }

  // ============================================================
  // CATEGORY ICON HELPER
  // ============================================================

  static IconData categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Icons.devices_outlined;

      case 'books':
        return Icons.menu_book_outlined;

      case 'furniture':
        return Icons.chair_outlined;

      case 'documents':
        return Icons.description_outlined;

      case 'appliances':
        return Icons.kitchen_outlined;

      case 'accessories':
        return Icons.watch_outlined;

      default:
        return Icons.inventory_2_outlined;
    }
  }
}