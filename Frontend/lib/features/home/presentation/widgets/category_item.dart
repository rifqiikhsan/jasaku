import 'package:flutter/material.dart';
import 'package:jasaku/app/theme.dart';
import 'package:jasaku/shared/extensions/color_extension.dart';

class CategoryItem extends StatelessWidget {
  final String icon;
  final String label;
  final String? color;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: AppTheme.accent.withValues(alpha: 0.2),
          highlightColor: AppTheme.accent.withValues(alpha: 0.1),
          onTap: onTap,
          child: Ink(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.toColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 28)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF333333),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
