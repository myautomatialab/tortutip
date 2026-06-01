import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tortutip/config/routes/app_routes.dart';
import 'package:tortutip/config/theme/app_colors.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/config/theme/app_typography.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/shared/widgets/tortutip_button.dart';

class FeedCardDetail extends StatelessWidget {
  // Closest token: avatarSizeSm (32) / 2 = 16; accepts minor visual delta from literal 18
  static const double _authorAvatarRadius = AppSpacing.avatarSizeSm / 2;

  final ArticleEntity article;

  const FeedCardDetail({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.title,
            style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            article.body,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const CircleAvatar(
                radius: _authorAvatarRadius,
                backgroundColor: AppColors.surface,
                child: Icon(
                  Icons.person,
                  size: AppSpacing.iconMd,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Autor',
                    style: AppTypography.label.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${article.readTimeMinutes} min de lectura',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          TortuPrimaryButton(
            label: 'Saber más →',
            onTap: () => context.push(AppRoutes.articleDetailPath(article.id)),
          ),
        ],
      ),
    );
  }
}
