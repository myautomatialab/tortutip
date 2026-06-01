import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tortutip/config/theme/app_colors.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/config/theme/app_typography.dart';
import 'package:tortutip/features/categories/domain/entities/category_entity.dart';
import 'package:tortutip/shared/widgets/tortutip_skeleton.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = _getCategoryStyle(category.name);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: SizedBox(
          height: AppSpacing.categoryCardHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: category.iconUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) => const TortuSkeletonImage(),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.surface,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, AppColors.overlayDark],
                    stops: [0.3, 1.0],
                  ),
                ),
              ),
              Positioned(
                bottom: AppSpacing.md,
                left: AppSpacing.md,
                right: AppSpacing.md,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: style.$1,
                      child: Icon(style.$2, color: AppColors.white, size: 16),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        category.name,
                        style: AppTypography.bodyLg.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Category-specific colors are not in the design token system because they
  // represent brand identities for individual content categories, not UI states.
  (Color, IconData) _getCategoryStyle(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('food') || lower.contains('nutrition')) {
      return (const Color(0xFFF5C842), Icons.restaurant);
    }
    if (lower.contains('fitness') || lower.contains('movement')) {
      return (const Color(0xFF5B8A3C), Icons.fitness_center);
    }
    if (lower.contains('meditation') || lower.contains('mindfulness')) {
      return (const Color(0xFF5B7FD4), Icons.self_improvement);
    }
    if (lower.contains('mental') || lower.contains('sleep')) {
      return (const Color(0xFFE87844), Icons.psychology);
    }
    return (AppColors.primaryDark, Icons.article);
  }
}
