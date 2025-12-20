import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import this
import 'app_colors.dart';

class AppTextStyles {
  // Use 'Poppins' as the base font
  static TextStyle get _baseFont => GoogleFonts.poppins();

  // Headings
  static TextStyle get h1 => _baseFont.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle get h2 => _baseFont.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get h3 => _baseFont.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body Text
  static TextStyle get bodyLarge => _baseFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => _baseFont.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodySmall => _baseFont.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle get button => _baseFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  // Used for: "Terms & Conditions", "Secure" badges, fine print
  static TextStyle get caption => _baseFont.copyWith(
    fontSize: 11, // Slightly smaller than bodySmall
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary.withOpacity(0.8),
    letterSpacing: 0.2,
  );
}
