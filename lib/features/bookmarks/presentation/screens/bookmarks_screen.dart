import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tortutip/config/routes/app_routes.dart';
import 'package:tortutip/config/theme/app_colors.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/config/theme/app_typography.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tortutip/features/auth/presentation/bloc/auth_state.dart';
import 'package:tortutip/features/bookmarks/presentation/bloc/bookmarks_cubit.dart';
import 'package:tortutip/features/bookmarks/presentation/bloc/bookmarks_state.dart';
import 'package:tortutip/shared/widgets/tortutip_app_bar.dart';
import 'package:tortutip/shared/widgets/tortutip_article_list_card.dart';
import 'package:tortutip/shared/widgets/tortutip_button.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookmarksCubit>().loadBookmarks(_userId(context));
    });
  }

  String _userId(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) return authState.user.id;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TortuAppBar(
        title: 'Mis Marcadores',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<BookmarksCubit, BookmarksState>(
        builder: (context, state) {
          if (state is BookmarksInitial) return const SizedBox.shrink();
          if (state is BookmarksLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BookmarksEmpty) return _buildEmptyState(context);
          if (state is BookmarksLoaded) return _buildList(context, state);
          if (state is BookmarksError) return _buildError(context, state.message);
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bookmark_border,
              color: AppColors.textSecondary,
              size: 64,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Aún no tienes marcadores',
              style: AppTypography.h2.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Guarda artículos que te interesen para leerlos después.',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            TortuPrimaryButton(
              label: 'Explorar artículos',
              onTap: () => context.go(AppRoutes.feed),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, BookmarksLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '— GUARDADOS',
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Mis Marcadores',
                style: AppTypography.hero.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Los artículos que has guardado para leer más tarde.',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async =>
                context.read<BookmarksCubit>().loadBookmarks(_userId(context)),
            child: ListView.separated(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.md,
                bottom: AppSpacing.floatingTabBarClearance,
              ),
              itemCount:
                  state.articles.length + (state.hasMore ? 1 : 0),
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.lg),
              itemBuilder: (context, index) {
                if (index == state.articles.length) {
                  return _buildLoadMoreButton(context);
                }
                return _buildArticleCard(context, state.articles[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Center(
        child: TextButton(
          onPressed: () =>
              context.read<BookmarksCubit>().loadMore(_userId(context)),
          child: Text(
            'Cargar más',
            style: AppTypography.body.copyWith(color: AppColors.primaryDark),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, ArticleEntity article) {
    return TortuArticleListCard(
      article: article,
      isSaved: true,
      onTap: () => context.push(AppRoutes.articleDetailPath(article.id)),
      onBookmarkTap: () => _onUnsave(context, article),
    );
  }

  void _onUnsave(BuildContext context, ArticleEntity article) {
    final cubit = context.read<BookmarksCubit>();
    cubit.unsaveArticle(_userId(context), article.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Eliminado de marcadores'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () => cubit.loadBookmarks(_userId(context)),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            TortuPrimaryButton(
              label: 'Reintentar',
              onTap: () => context
                  .read<BookmarksCubit>()
                  .loadBookmarks(_userId(context)),
            ),
          ],
        ),
      ),
    );
  }
}
