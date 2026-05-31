import 'package:flutter/material.dart';
import 'package:tortutip/features/categories/domain/entities/category_entity.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final bool selected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Text(category.name));
  }
}
