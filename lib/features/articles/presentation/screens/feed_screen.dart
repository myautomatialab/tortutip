import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tortutip/config/routes/app_routes.dart';
import 'package:tortutip/config/theme/app_colors.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/config/theme/app_typography.dart';
import 'package:tortutip/features/articles/presentation/bloc/feed/feed_cubit.dart';
import 'package:tortutip/features/articles/presentation/bloc/feed/feed_state.dart';
import 'package:tortutip/features/articles/presentation/widgets/feed_card_stack.dart';
import 'package:tortutip/features/articles/presentation/widgets/feed_para_ti_chip.dart';
import 'package:tortutip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tortutip/features/auth/presentation/bloc/auth_state.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final FeedCubit _cubit;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _cubit = GetIt.instance<FeedCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        _userId = authState.user.id;
        _cubit.loadFeed(_userId!);
      }
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'TortuTip',
            style: AppTypography.h1.copyWith(color: AppColors.primary),
          ),
          centerTitle: true,
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: const SizedBox.shrink(),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => context.push(AppRoutes.editProfile),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              const Center(child: FeedParaTiChip()),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: BlocBuilder<FeedCubit, FeedState>(
                  builder: (context, state) {
                    if (state is FeedInitial || state is FeedLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (state is FeedLoaded) {
                      if (state.articles.isEmpty ||
                          state.currentIndex >= state.articles.length) {
                        return Center(
                          child: Text(
                            'No hay más artículos',
                            style: AppTypography.body
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        );
                      }
                      return Center(
                        child: FeedCardStack(
                          articles: state.articles,
                          currentIndex: state.currentIndex,
                          savedArticleIds: state.savedArticleIds,
                          onSwipe: _cubit.onSwipe,
                          onBookmark: _cubit.toggleBookmark,
                        ),
                      );
                    }

                    if (state is FeedLoadingMore) {
                      return Center(
                        child: FeedCardStack(
                          articles: state.articles,
                          currentIndex: state.currentIndex,
                          savedArticleIds: const {},
                          onSwipe: () {},
                          onBookmark: (_) {},
                        ),
                      );
                    }

                    if (state is FeedError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.message,
                              style: AppTypography.body
                                  .copyWith(color: AppColors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextButton(
                              onPressed: _userId != null
                                  ? () => _cubit.loadFeed(_userId!)
                                  : null,
                              child: Text(
                                'Reintentar',
                                style: AppTypography.label
                                    .copyWith(color: AppColors.primary),
                              ),
                            ),
                          ],
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
      ),
    );
  }
}
