import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';

/// Brutalist text input — thick border, sharp corners, monospace label
/// Matches: border-all-brutal, font-body-lg, focus:bg-surface-container-low
class BrutalTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final bool isPassword;
  final TextEditingController? controller;
  final int maxLines;

  const BrutalTextField({
    super.key,
    required this.label,
    required this.placeholder,
    this.isPassword = false,
    this.controller,
    this.maxLines = 1,
  });

  @override
  State<BrutalTextField> createState() => _BrutalTextFieldState();
}

class _BrutalTextFieldState extends State<BrutalTextField> {
  bool _obscureText = true;
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: AppTypography.labelMono.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        // Input field
        Container(
          decoration: BoxDecoration(
            color: _isFocused
                ? AppColors.surfaceContainerLow
                : AppColors.surfaceContainerLowest,
            border: AppThemeConstants.brutalBorder,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            obscureText: widget.isPassword && _obscureText,
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.onSurface,
            ),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: AppTypography.bodyLg.copyWith(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: () =>
                          setState(() => _obscureText = !_obscureText),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.onSurfaceVariant,
                          size: 24,
                        ),
                      ),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(
                minHeight: 24,
                minWidth: 48,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
