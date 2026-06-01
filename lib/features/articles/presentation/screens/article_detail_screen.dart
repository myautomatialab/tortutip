import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tortutip/config/routes/app_routes.dart';
import 'package:tortutip/config/theme/app_colors.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/config/theme/app_typography.dart';
import 'package:tortutip/features/articles/presentation/bloc/article_detail/article_detail_cubit.dart';
import 'package:tortutip/features/articles/presentation/bloc/article_detail/article_detail_state.dart';
import 'package:tortutip/features/articles/presentation/widgets/article_body_renderer.dart';
import 'package:tortutip/features/articles/presentation/widgets/article_cover_image.dart';
import 'package:tortutip/features/articles/presentation/widgets/author_row.dart';
import 'package:tortutip/features/articles/presentation/widgets/related_articles_section.dart';
import 'package:tortutip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tortutip/features/auth/presentation/bloc/auth_state.dart';
import 'package:tortutip/injection/injection_container.dart';
import 'package:tortutip/shared/widgets/tortutip_app_bar.dart';
import 'package:tortutip/shared/widgets/tortutip_button.dart';
import 'package:tortutip/features/tortu_feed/presentation/widgets/tortu_feed_widget.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String articleId;

  const ArticleDetailScreen({super.key, required this.articleId});

  String _currentUserId(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) return authState.user.id;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final userId = _currentUserId(context);

    return BlocProvider(
      create: (_) => sl<ArticleDetailCubit>()..loadArticle(articleId, userId),
      child: BlocConsumer<ArticleDetailCubit, ArticleDetailState>(
        listener: (context, state) {
          // No additional listener logic needed here; toggleSave returns bool
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: TortuAppBar.detail(
              title: 'Detalle',
              actions: state is ArticleDetailLoaded
                  ? [
                      IconButton(
                        icon: const Icon(Icons.share_outlined,
                            color: AppColors.primary),
                        tooltip: 'Compartir',
                        onPressed: () {
                          Share.share(
                            '${state.article.title}\n${AppRoutes.articleDetailPath(articleId)}',
                          );
                        },
                      ),
                    ]
                  : null,
            ),
            body: _buildBody(context, state, userId),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ArticleDetailState state, String userId) {
    if (state is ArticleDetailInitial) return const SizedBox.shrink();

    if (state is ArticleDetailLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state is ArticleDetailError) {
      final cubit = context.read<ArticleDetailCubit>();
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  size: AppSpacing.iconLg, color: AppColors.textSecondary),
              const SizedBox(height: AppSpacing.md),
              Text(
                state.message,
                style: AppTypography.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              TortuSecondaryButton(
                label: 'Reintentar',
                onTap: () => cubit.loadArticle(articleId, userId),
              ),
            ],
          ),
        ),
      );
    }

    if (state is ArticleDetailLoaded) {
      return Stack(
        children: [
          _buildLoaded(context, state, userId),
          TortuFeedWidget(
            isSaved: state.isSaved,
            isDoneToday: state.isDoneToday,
            userId: userId,
            articleId: state.article.id,
            categoryId: state.article.categoryId,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoaded(
      BuildContext context, ArticleDetailLoaded loaded, String userId) {
    final cubit = context.read<ArticleDetailCubit>();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ArticleCoverImage(
            imageUrl: loaded.article.coverHorizontalUrl,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: AppSpacing.xl),
              Text(
                loaded.article.title,
                style: AppTypography.h3,
              ),
              const SizedBox(height: AppSpacing.lg),
              AuthorRow(
                author: loaded.author,
                readTimeMinutes: loaded.article.readTimeMinutes,
                isSaved: loaded.isSaved,
                onToggleSave: () async {
                  final success = await cubit.toggleSave(userId);
                  if (!success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No se pudo guardar. Inténtalo de nuevo.'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Divider(color: AppColors.border),
              const SizedBox(height: AppSpacing.xl),
              ArticleBodyRenderer(body: loaded.article.body),
              const SizedBox(height: AppSpacing.huge),
              RelatedArticlesSection(
                articles: loaded.relatedArticles,
                onArticleTap: (id) =>
                    context.push(AppRoutes.articleDetailPath(id)),
              ),
              const SizedBox(height: AppSpacing.huge),
            ]),
          ),
        ),
      ],
    );
  }
}
