import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final bool isNumber;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.isNumber = false,
    this.maxLength,
    this.inputFormatters,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    // Keeps your UI clean and consistent across the ENTIRE app
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
      maxLength: maxLength,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.digitsOnly, ...(inputFormatters ?? [])]
          : inputFormatters,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: AppColors.primary,
          size: AppDimens.iconMedium,
        ),
        // The borders and colors are already handled by your AppTheme!
      ),
    );
  }
}
