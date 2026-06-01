import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tortutip/config/theme/app_colors.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/config/theme/app_typography.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/shared/widgets/tortutip_chip.dart';

class SavedArticleThumbnail extends StatelessWidget {
  final ArticleEntity article;
  final String categoryName;
  final VoidCallback onTap;

  const SavedArticleThumbnail({
    super.key,
    required this.article,
    required this.categoryName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: article.coverHorizontalUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: article.coverHorizontalUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.surface,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.surface,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    )
                  : Container(color: AppColors.surface),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TortuCategoryChip.fromName(categoryName),
          const SizedBox(height: AppSpacing.xs),
          Text(
            article.title,
            style: AppTypography.body.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
