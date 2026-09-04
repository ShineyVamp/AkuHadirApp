import 'package:flutter/material.dart';
import 'package:akuhadir/core/theme/neumorphic_decorations.dart';
class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? color;
  final bool isSmall;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 18,
    this.onTap,
    this.color,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final boxDecoration = isSmall
        ? NeumorphicDecorations.extrudedSm(
            isDark: isDark,
            borderRadius: borderRadius,
            color: color,
          )
        : NeumorphicDecorations.extruded(
            isDark: isDark,
            borderRadius: borderRadius,
            color: color,
          );

    Widget content = Container(
      margin: margin,
      padding: padding,
      decoration: boxDecoration,
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}
