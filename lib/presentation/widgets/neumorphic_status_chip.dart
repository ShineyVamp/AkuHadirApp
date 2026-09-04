import 'package:flutter/material.dart';
import 'package:akuhadir/core/constants/app_colors.dart';
class NeumorphicStatusChip extends StatelessWidget {
  final String status;

  const NeumorphicStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    String label = status;

    final lower = status.toLowerCase();
    if (lower == 'masuk' || lower == 'hadir') {
      textColor = AppColors.success;
      bgColor = AppColors.success.withValues(alpha: 0.15);
      label = 'Hadir';
    } else if (lower == 'izin') {
      textColor = AppColors.warning;
      bgColor = AppColors.warning.withValues(alpha: 0.15);
      label = 'Izin';
    } else {
      textColor = AppColors.danger;
      bgColor = AppColors.danger.withValues(alpha: 0.15);
      label = 'Alfa';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: textColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
