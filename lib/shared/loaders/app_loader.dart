// lib/shared/widgets/app_loaders.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SpinningArcLoader extends StatelessWidget {
  const SpinningArcLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.border.withOpacity(
            0.5,
          ), // Faint grey ring background
          width: 3,
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primary,
            ), // Navy Blue
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
