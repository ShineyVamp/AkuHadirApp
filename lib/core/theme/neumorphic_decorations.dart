import 'package:flutter/material.dart';
import 'package:AbsenDulu/core/constants/app_colors.dart';

class NeumorphicDecorations {
  static BoxDecoration extruded({
    required bool isDark,
    double borderRadius = 18,
    Color? color,
    BoxShape shape = BoxShape.rectangle,
    Border? border,
  }) {
    final baseColor =
        color ?? (isDark ? AppColors.cardBgDark : AppColors.cardBg);
    final shadowDark = isDark
        ? AppColors.darkShadowDark.withValues(alpha: 0.8)
        : AppColors.shadowDark.withValues(alpha: 0.6);
    final shadowLight = isDark
        ? AppColors.darkShadowLight.withValues(alpha: 0.5)
        : AppColors.shadowLight.withValues(alpha: 0.9);

    return BoxDecoration(
      color: baseColor,
      shape: shape,
      borderRadius: shape == BoxShape.circle
          ? null
          : BorderRadius.circular(borderRadius),
      border: border,
      boxShadow: [
        BoxShadow(
          color: shadowDark,
          offset: const Offset(6, 6),
          blurRadius: 14,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: shadowLight,
          offset: const Offset(-6, -6),
          blurRadius: 14,
          spreadRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration extrudedSm({
    required bool isDark,
    double borderRadius = 12,
    Color? color,
    BoxShape shape = BoxShape.rectangle,
    Border? border,
  }) {
    final baseColor =
        color ?? (isDark ? AppColors.cardBgDark : AppColors.cardBg);
    final shadowDark = isDark
        ? AppColors.darkShadowDark.withValues(alpha: 0.7)
        : AppColors.shadowDark.withValues(alpha: 0.5);
    final shadowLight = isDark
        ? AppColors.darkShadowLight.withValues(alpha: 0.4)
        : AppColors.shadowLight.withValues(alpha: 0.85);

    return BoxDecoration(
      color: baseColor,
      shape: shape,
      borderRadius: shape == BoxShape.circle
          ? null
          : BorderRadius.circular(borderRadius),
      border: border,
      boxShadow: [
        BoxShadow(
          color: shadowDark,
          offset: const Offset(3, 3),
          blurRadius: 8,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: shadowLight,
          offset: const Offset(-3, -3),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration insetWell({
    required bool isDark,
    double borderRadius = 14,
    Color? color,
    Border? border,
  }) {
    final baseColor =
        color ?? (isDark ? const Color(0xFF131922) : AppColors.cardBg);
    final shadowDark = isDark
        ? AppColors.darkShadowDark.withValues(alpha: 0.6)
        : AppColors.shadowDark.withValues(alpha: 0.4);

    return BoxDecoration(
      color: baseColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: border ?? Border.all(color: shadowDark, width: 1),
    );
  }

  static BoxDecoration primaryPill({Color? color, double borderRadius = 18}) {
    final btnColor = color ?? AppColors.primary;
    return BoxDecoration(
      color: btnColor,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: btnColor.withValues(alpha: 0.35),
          offset: const Offset(0, 8),
          blurRadius: 18,
          spreadRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration navDock({required bool isDark}) {
    final baseColor = isDark ? AppColors.cardBgDark : AppColors.cardBg;
    final shadowDark = isDark
        ? AppColors.darkShadowDark.withValues(alpha: 0.7)
        : AppColors.shadowDark.withValues(alpha: 0.35);
    final shadowLight = isDark
        ? AppColors.darkShadowLight.withValues(alpha: 0.3)
        : AppColors.shadowLight.withValues(alpha: 0.9);

    return BoxDecoration(
      color: baseColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      boxShadow: [
        BoxShadow(
          color: shadowDark,
          offset: const Offset(0, -4),
          blurRadius: 16,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: shadowLight,
          offset: const Offset(0, -1),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ],
    );
  }
}
