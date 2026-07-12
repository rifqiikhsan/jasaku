import 'package:flutter/material.dart';
import 'package:jasaku/features/home/domain/entities/category_entity.dart';
import '../../../../app/theme.dart';
import 'category_item.dart';

class CategorySection extends StatelessWidget {
  final List<CategoryEntity> categories;
  const CategorySection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kategori Jasa',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              InkWell(
                splashColor: Colors.blue.withValues(alpha: 0.2),
                highlightColor: Colors.blue.withValues(alpha: 0.1),
                onTap: () {},
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: categories
                .take(5)
                .map(
                  (c) => CategoryItem(
                    icon: c.catEmoji ?? '',
                    label: c.catDesc ?? '',
                    color: c.catColor,
                    onTap: () {},
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
