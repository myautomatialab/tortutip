import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tortutip/config/routes/app_routes.dart';
import 'package:tortutip/config/theme/app_colors.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/config/theme/app_typography.dart';
import 'package:tortutip/features/categories/domain/entities/category_entity.dart';
import 'package:tortutip/features/search/presentation/bloc/search_cubit.dart';
import 'package:tortutip/features/search/presentation/bloc/search_state.dart';
import 'package:tortutip/features/search/presentation/widgets/article_result_card.dart';
import 'package:tortutip/features/search/presentation/widgets/category_result_card.dart';
import 'package:tortutip/features/search/presentation/widgets/creator_result_card.dart';
import 'package:tortutip/features/search/presentation/widgets/recent_search_row.dart';
import 'package:tortutip/features/search/presentation/widgets/search_bar_widget.dart';
import 'package:tortutip/features/search/presentation/widgets/search_empty_state.dart';
import 'package:tortutip/features/search/presentation/widgets/search_skeleton.dart';
import 'package:tortutip/features/search/presentation/widgets/suggestion_row.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<SearchCubit>().loadInitial();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onCancel() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),
            SearchBarWidget(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (query) {
                context.read<SearchCubit>().onQueryChanged(query);
              },
              onCancel: _onCancel,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return _buildInitialView(state);
                  }
                  if (state is SearchSuggesting) {
                    return _buildSuggestingView(state);
                  }
                  if (state is SearchLoading) {
                    return const SearchSkeleton();
                  }
                  if (state is SearchLoaded) {
                    return _buildResultsView(state);
                  }
                  if (state is SearchEmpty) {
                    return SearchEmptyState(
                      suggestedCategories: state.suggestedCategories,
                      onCategoryTap: (cat) =>
                          _onCategoryTap(context, cat),
                    );
                  }
                  if (state is SearchError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xxl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message,
                                style: AppTypography.body,
                                textAlign: TextAlign.center),
                            const SizedBox(height: AppSpacing.lg),
                            TextButton(
                              onPressed: () {
                                final q = _controller.text.trim();
                                if (q.isNotEmpty) {
                                  context.read<SearchCubit>().search(q);
                                }
                              },
                              child: Text(
                                'Retry',
                                style: AppTypography.body
                                    .copyWith(color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialView(SearchInitial state) {
    if (state.recentSearches.isEmpty) {
      return Center(
        child: Text(
          'Start searching...',
          style: AppTypography.subtitle,
        ),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          child: Text('Recent searches', style: AppTypography.label),
        ),
        ...state.recentSearches.map(
          (q) => RecentSearchRow(
            query: q,
            onTap: () {
              _controller.text = q;
              _controller.selection = TextSelection.fromPosition(
                TextPosition(offset: q.length),
              );
              context.read<SearchCubit>().search(q);
            },
            onRemove: () => context.read<SearchCubit>().removeRecent(q),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestingView(SearchSuggesting state) {
    return ListView(
      children: state.suggestions
          .map(
            (s) => SuggestionRow(
              suggestion: s,
              query: state.query,
              onTap: (value) {
                _controller.text = value;
                context.read<SearchCubit>().search(value);
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildResultsView(SearchLoaded state) {
    return DefaultTabController(
      length: 3,
      initialIndex: state.activeTab,
      child: Column(
        children: [
          _buildTabBar(state),
          if (state.activeTab == 0 && state.articles.isNotEmpty)
            _buildCategoryFilters(state),
          Expanded(
            child: TabBarView(
              children: [
                _buildArticlesTab(state),
                _buildCategoriesTab(state),
                _buildCreatorsTab(state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(SearchLoaded state) {
    return TabBar(
      onTap: (idx) => context.read<SearchCubit>().setTab(idx),
      labelStyle: AppTypography.label,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondary,
      indicatorColor: AppColors.primary,
      tabs: [
        Tab(text: 'Articles (${state.articles.length})'),
        Tab(text: 'Categories (${state.categories.length})'),
        Tab(text: 'Creators (${state.creators.length})'),
      ],
    );
  }

  Widget _buildCategoryFilters(SearchLoaded state) {
    final articleCategories = state.articles
        .map((a) => a.categoryId)
        .toSet()
        .toList();

    if (articleCategories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: [
          _filterChip('all', 'All', state.activeFilter),
          ...articleCategories.map(
            (catId) {
              final catName = state.categories
                  .firstWhere(
                    (c) => c.id == catId,
                    orElse: () => CategoryEntity(
                        id: catId, name: catId, description: '', iconUrl: ''),
                  )
                  .name;
              return _filterChip(catId, catName, state.activeFilter);
            },
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String value, String label, String activeFilter) {
    final isActive = activeFilter == value;
    return GestureDetector(
      onTap: () => context.read<SearchCubit>().setFilter(value),
      child: Container(
        margin: const EdgeInsets.only(right: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
              color: isActive ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(
            color: isActive ? AppColors.textOnDark : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildArticlesTab(SearchLoaded state) {
    final articles = state.filteredArticles;
    if (articles.isEmpty) {
      return Center(
        child: Text('No articles found', style: AppTypography.subtitle),
      );
    }
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (_, index) {
        final article = articles[index];
        final catName = state.categories
            .firstWhere(
              (c) => c.id == article.categoryId,
              orElse: () => CategoryEntity(
                  id: '', name: '', description: '', iconUrl: ''),
            )
            .name;
        return AnimatedOpacity(
          duration:
              Duration(milliseconds: 200 + (index * 50)),
          opacity: 1.0,
          child: ArticleResultCard(
            article: article,
            query: state.query,
            categoryName: catName,
            onTap: () => context.push(
              AppRoutes.articlePath(article.id),
              extra: article,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesTab(SearchLoaded state) {
    if (state.categories.isEmpty) {
      return Center(
        child: Text('No categories found', style: AppTypography.subtitle),
      );
    }
    return ListView.builder(
      itemCount: state.categories.length,
      itemBuilder: (_, index) {
        final category = state.categories[index];
        return CategoryResultCard(
          category: category,
          articleCount: state.articles
              .where((a) => a.categoryId == category.id)
              .length,
          onTap: () => _onCategoryTap(context, category),
        );
      },
    );
  }

  Widget _buildCreatorsTab(SearchLoaded state) {
    if (state.creators.isEmpty) {
      return Center(
        child: Text('No creators found', style: AppTypography.subtitle),
      );
    }
    return ListView.builder(
      itemCount: state.creators.length,
      itemBuilder: (_, index) {
        return CreatorResultCard(creator: state.creators[index]);
      },
    );
  }

  void _onCategoryTap(BuildContext context, CategoryEntity category) {
    context.push(
      AppRoutes.exploreCategoryPath(category.id),
      extra: category,
    );
  }
}
