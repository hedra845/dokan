import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Brand Colors - Modern, vibrant & professional palette
const Color kEmeraldGreen = Color(0xFF10B981); // Modern vibrant emerald green
const Color kEmeraldDark = Color(0xFF047857);  // Deep emerald
const Color kEmeraldLight = Color(0xFFECFDF5); // Soft mint tint
const Color kEmeraldLight2 = Color(0xFFD1FAE5);

const Color kDark = Color(0xFF0F172A); // Modern slate navy
const Color kGrey = Color(0xFF64748B); // Slate secondary text
const Color kLightGrey = Color(0xFFF8FAFC); // Subtle background slate
const Color kCardBorder = Color(0xFFE2E8F0); // Delicate subtle border
const Color kWhite = Colors.white;

const Color kStarYellow = Color(0xFFF59E0B);
const Color kDiscountYellow = Color(0xFFFBBF24);
const Color kDiscountOrange = Color(0xFFF97316);
const Color kRed = Color(0xFFEF4444);

// Compatibility aliases
const Color kOrange = kEmeraldGreen;
const Color kOrangeDark = kEmeraldDark;
const Color kOrangeLight = kEmeraldLight;
const Color kGreen = kEmeraldGreen;

// Modern Luxury Dark & Neon Emerald Palette
const Color kDarkBackground = Color(0xFF0B131E); // Ultra deep obsidian slate
const Color kDarkSurface = Color(0xFF131F2E);    // Deep card surface
const Color kDarkCard = Color(0xFF192739);       // Elevated card surface
const Color kDarkBorder = Color(0xFF23354C);     // Glass border stroke
const Color kNeonEmerald = Color(0xFF10E79D);     // Vibrant glowing neon emerald
const Color kDarkTextPrimary = Color(0xFFF1F5F9); // Crisp white text
const Color kDarkTextSecondary = Color(0xFF94A3B8); // Muted slate text

/// Modern Elevation and Soft Shadow Styles
class AppShadows {
  static const List<BoxShadow> neon = [
    BoxShadow(
      color: Color(0x4010E79D),
      blurRadius: 18,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x080F172A),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0C0F172A),
      blurRadius: 16,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x3310B981),
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x140F172A),
      blurRadius: 24,
      spreadRadius: 0,
      offset: Offset(0, 10),
    ),
  ];
}

/// Unified Theme Configuration
class AppTheme {
  static ThemeData get theme {
    final cairoFontFamily = GoogleFonts.cairo().fontFamily;
    final cairoBaseTextTheme = GoogleFonts.cairoTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kEmeraldGreen,
        primary: kEmeraldGreen,
        secondary: kEmeraldDark,
        surface: kWhite,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      fontFamily: cairoFontFamily,
      textTheme: cairoBaseTextTheme.apply(
        fontFamily: cairoFontFamily,
        bodyColor: kDark,
        displayColor: kDark,
      ),
      primaryTextTheme: cairoBaseTextTheme.apply(
        fontFamily: cairoFontFamily,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: kWhite,
        foregroundColor: kDark,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: cairoFontFamily,
          color: kDark,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: kDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kEmeraldGreen,
          foregroundColor: kWhite,
          elevation: 2,
          shadowColor: kEmeraldGreen.withAlpha(80),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: TextStyle(
            fontFamily: cairoFontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kEmeraldGreen,
          side: const BorderSide(color: kEmeraldGreen, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: TextStyle(
            fontFamily: cairoFontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kEmeraldGreen,
          textStyle: TextStyle(
            fontFamily: cairoFontFamily,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kCardBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kCardBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kEmeraldGreen, width: 1.8),
        ),
        labelStyle: TextStyle(fontFamily: cairoFontFamily, color: kGrey),
        hintStyle: TextStyle(fontFamily: cairoFontFamily, color: kGrey, fontSize: 13),
      ),
      cardTheme: CardThemeData(
        color: kWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: kCardBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kWhite,
        selectedItemColor: kEmeraldGreen,
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedLabelStyle: TextStyle(
          fontFamily: cairoFontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: cairoFontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
