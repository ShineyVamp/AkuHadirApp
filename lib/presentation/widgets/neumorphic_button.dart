import 'package:flutter/material.dart';
import 'package:akuhadir/core/constants/app_colors.dart';import 'package:akuhadir/core/theme/neumorphic_decorations.dart';
class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;
  final double height;
  final double? width;
  final double borderRadius;
  final Color? color;

  const NeumorphicButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isPrimary = false,
    this.isLoading = false,
    this.height = 50,
    this.width,
    this.borderRadius = 16,
    this.color,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    BoxDecoration decoration;
    if (widget.isPrimary) {
      decoration = NeumorphicDecorations.primaryPill(
        color: widget.color ?? AppColors.primary,
        borderRadius: widget.borderRadius,
      );
    } else {
      if (_isPressed) {
        decoration = NeumorphicDecorations.insetWell(
          isDark: isDark,
          borderRadius: widget.borderRadius,
          color: widget.color,
        );
      } else {
        decoration = NeumorphicDecorations.extruded(
          isDark: isDark,
          borderRadius: widget.borderRadius,
          color: widget.color,
        );
      }
    }

    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed != null && !widget.isLoading) {
          setState(() => _isPressed = true);
        }
      },
      onTapUp: (_) {
        if (widget.onPressed != null && !widget.isLoading) {
          setState(() => _isPressed = false);
          widget.onPressed?.call();
        }
      },
      onTapCancel: () {
        if (widget.onPressed != null && !widget.isLoading) {
          setState(() => _isPressed = false);
        }
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: decoration,
          alignment: Alignment.center,
          child: widget.isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: widget.isPrimary ? Colors.white : AppColors.primary,
                  ),
                )
              : widget.child,
        ),
      ),
    );
  }
}
