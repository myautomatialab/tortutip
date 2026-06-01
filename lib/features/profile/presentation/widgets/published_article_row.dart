import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tortutip/config/theme/app_colors.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/config/theme/app_typography.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/shared/widgets/tortutip_chip.dart';

class PublishedArticleRow extends StatelessWidget {
  final ArticleEntity article;
  final String categoryName;
  final VoidCallback onTapView;
  final VoidCallback onTapDelete;
  final VoidCallback onTapEdit;

  const PublishedArticleRow({
    super.key,
    required this.article,
    required this.categoryName,
    required this.onTapView,
    required this.onTapDelete,
    required this.onTapEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: SizedBox(
            width: 60,
            height: 60,
            child: article.coverHorizontalUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: article.coverHorizontalUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: AppColors.surface),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textTertiary,
                        size: AppSpacing.iconSizeMd,
                      ),
                    ),
                  )
                : Container(color: AppColors.surface),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TortuCategoryChip.fromName(categoryName),
              const SizedBox(height: AppSpacing.xs),
              Text(
                article.title,
                style: AppTypography.body.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
          onSelected: (value) {
            switch (value) {
              case 'view':
                onTapView();
              case 'edit':
                onTapEdit();
              case 'delete':
                _confirmDelete(context);
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'view', child: Text('Ver')),
            const PopupMenuItem(value: 'edit', child: Text('Editar')),
            const PopupMenuItem(
              value: 'delete',
              child: Text(
                'Eliminar',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar artículo'),
        content: const Text(
          '¿Seguro que quieres eliminar este artículo? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onTapDelete();
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
