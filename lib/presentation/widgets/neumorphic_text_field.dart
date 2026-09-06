import 'package:flutter/material.dart';
import 'package:akuhadir/core/constants/app_colors.dart';
import 'package:akuhadir/core/theme/neumorphic_decorations.dart';

class NeumorphicTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;

  const NeumorphicTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FormField<String>(
      initialValue: controller?.text ?? '',
      validator: validator != null ? (_) => validator!(controller?.text) : null,
      builder: (FormFieldState<String> field) {
        final hasError = field.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (labelText != null) ...[
              Text(
                labelText!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Container(
              decoration: NeumorphicDecorations.insetWell(
                isDark: isDark,
                borderRadius: 14,
                border: hasError
                    ? Border.all(
                        color: AppColors.danger.withValues(alpha: 0.8),
                        width: 1.2,
                      )
                    : null,
              ),
              padding: EdgeInsets.only(
                left: prefixIcon == null ? 14 : 4,
                right: suffixIcon == null ? 14 : 4,
              ),
              child: TextField(
                textAlignVertical: maxLines == 1
                    ? TextAlignVertical.center
                    : TextAlignVertical.top,
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                readOnly: readOnly,
                onTap: onTap,
                maxLines: maxLines,
                onChanged: (val) {
                  field.didChange(val);
                  if (field.hasError) {
                    field.validate();
                  }
                },
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textLowDark : AppColors.textLow,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                    maxWidth: 40,
                    maxHeight: 40,
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                    maxWidth: 40,
                    maxHeight: 40,
                  ),
                ),
              ),
            ),
            if (hasError && field.errorText != null) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 13,
                      color: AppColors.danger,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        field.errorText!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
