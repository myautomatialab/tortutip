import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tortutip/config/routes/app_routes.dart';
import 'package:tortutip/config/theme/app_colors.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/config/theme/app_typography.dart';
import 'package:tortutip/features/categories/domain/entities/category_entity.dart';
import 'package:tortutip/features/explore/presentation/bloc/explore_cubit.dart';
import 'package:tortutip/features/explore/presentation/bloc/explore_state.dart';
import 'package:tortutip/features/explore/presentation/widgets/category_card.dart';
import 'package:tortutip/features/explore/presentation/widgets/streak_card.dart';
import 'package:tortutip/shared/widgets/tortutip_app_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExploreCubit>().loadExplore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TortuAppBar(
        title: 'TortuTip',
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.textPrimary),
            onPressed: () => context.push(AppRoutes.editProfile),
          ),
        ],
      ),
      body: BlocBuilder<ExploreCubit, ExploreState>(
        builder: (context, state) {
          if (state is ExploreLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ExploreLoaded) {
            return _buildLoaded(context, state);
          }
          if (state is ExploreError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, ExploreLoaded state) {
    return SingleChildScrollView(
      // 100 = floating tab bar total height (tabBarHeight 76 + bottom padding 24)
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SearchBar(),
          const SizedBox(height: AppSpacing.xl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              'Kaia, your turtle 🐢',
              style: AppTypography.h2.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          StreakCard(streakDays: state.streakDays),
          const SizedBox(height: AppSpacing.xl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Text(
                  'Trending Categories',
                  style: AppTypography.h2.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'SEE ALL',
                    style: AppTypography.label
                        .copyWith(color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.0,
              ),
              itemCount: min(4, state.categories.length),
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return CategoryCard(
                  category: category,
                  onTap: () => _onCategoryTap(context, category),
                );
              },
            ),
          ),
          // 100 = floating tab bar total height (tabBarHeight 76 + bottom padding 24)
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  void _onCategoryTap(BuildContext context, CategoryEntity category) {
    context.push(
      AppRoutes.exploreCategoryPath(category.id),
      extra: category,
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Búsqueda próximamente')),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Search articles...',
              style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
