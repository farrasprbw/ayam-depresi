import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';

/// Brutalist primary button — red background, hard-drop shadow, uppercase label
/// Matches: bg-brand-red, border-all-brutal, brutal-shadow, active-press
class BrutalButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const BrutalButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isPrimary = true,
  });

  @override
  State<BrutalButton> createState() => _BrutalButtonState();
}

class _BrutalButtonState extends State<BrutalButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: _isPressed
            ? Matrix4.translationValues(2.0, 2.0, 0.0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.isPrimary ? AppColors.brandRed : AppColors.surfaceContainerLowest,
          border: AppThemeConstants.brutalBorder,
          boxShadow: _isPressed
              ? AppThemeConstants.brutalShadowPressed
              : AppThemeConstants.brutalShadow,
        ),
        padding: EdgeInsets.symmetric(
          vertical: widget.isPrimary ? 20 : 16,
          horizontal: 24,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                color: widget.isPrimary ? AppColors.onPrimary : AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              widget.text,
              style: AppTypography.labelMono.copyWith(
                color: widget.isPrimary ? AppColors.onPrimary : AppColors.primary,
                fontSize: widget.isPrimary ? 18 : 16,
                letterSpacing: widget.isPrimary ? 2.0 : -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
