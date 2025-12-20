import 'package:flutter/material.dart';

class AppColors {
  // Main Brand Colors
  static const Color primary = Color(0xFF003366); // Royal Blue (Trust)
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color secondary = Color(
    0xFF10B981,
  ); // Emerald Green (Success/Money)

  // Background Colors
  static const Color background = Color(
    0xFFF8FAFC,
  ); // Very light grey (Easy on eyes)
  static const Color surface = Colors.white; // Cards/Dialogs

  // Text Colors
  static const Color textPrimary = Color(
    0xFF1E293B,
  ); // Dark Slate (Readable Black)
  static const Color textSecondary = Color(
    0xFF64748B,
  ); // Grey text for subtitles
  static const Color textInverse = Colors.white;

  // Validation Colors
  static const Color error = Color(0xFFEF4444); // Red
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Amber

  // UI Elements
  static const Color border = Color(0xFFE2E8F0); // Light border for inputs
  static const Color divider = Color(0xFFCBD5E1);
}
