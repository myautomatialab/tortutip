import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tortutip/config/routes/app_routes.dart';
import 'package:tortutip/config/theme/app_colors.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/config/theme/app_typography.dart';
import 'package:tortutip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tortutip/features/auth/presentation/bloc/auth_state.dart';
import 'package:tortutip/features/profile/presentation/bloc/edit_profile_cubit.dart';
import 'package:tortutip/features/profile/presentation/bloc/edit_profile_state.dart';
import 'package:tortutip/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:tortutip/features/profile/presentation/bloc/profile_state.dart';
import 'package:tortutip/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:tortutip/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:tortutip/features/profile/presentation/widgets/published_article_row.dart';
import 'package:tortutip/injection/injection_container.dart';
import 'package:tortutip/shared/widgets/tortutip_app_bar.dart';
import 'package:tortutip/shared/widgets/tortutip_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        _userId = authState.user.id;
        context.read<ProfileCubit>().loadProfile(_userId!);
      }
    });
  }

  void _openEditProfile(BuildContext context, ProfileLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => sl<EditProfileCubit>(),
        child: BlocListener<EditProfileCubit, EditProfileState>(
          listener: (ctx, editState) {
            if (editState is EditProfileSuccess) {
              Navigator.of(ctx).pop();
              if (_userId != null) {
                context.read<ProfileCubit>().loadProfile(_userId!);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Perfil actualizado'),
                  backgroundColor: AppColors.success,
                ),
              );
            } else if (editState is EditProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(editState.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: EditProfileScreen(user: state.user),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TortuAppBar(
        title: 'Mi Perfil',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (ctx, state) {
              if (state is ProfileLoaded) {
                return IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _openEditProfile(context, state),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileInitial || state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is ProfileError) {
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
                  TortuSecondaryButton(
                    label: 'Reintentar',
                    onTap: _userId != null
                        ? () => context.read<ProfileCubit>().loadProfile(_userId!)
                        : null,
                  ),
                ],
              ),
            );
          }

          if (state is ProfileLoaded) {
            return _ProfileBody(
              state: state,
              userId: _userId ?? '',
              onDeleteArticle: (articleId) =>
                  context.read<ProfileCubit>().deleteArticle(articleId, _userId ?? ''),
              onViewArticle: (articleId) =>
                  context.push(AppRoutes.articlePath(articleId)),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final ProfileLoaded state;
  final String userId;
  final void Function(String articleId) onDeleteArticle;
  final void Function(String articleId) onViewArticle;

  const _ProfileBody({
    required this.state,
    required this.userId,
    required this.onDeleteArticle,
    required this.onViewArticle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeaderCard(
            user: state.user,
            totalPublishedCount: state.totalPublishedCount,
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (state.publishedArticles.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
              ),
              child: Text('Mis Tips', style: AppTypography.h4),
            ),
            const SizedBox(height: AppSpacing.md),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
              ),
              itemCount: state.publishedArticles.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final article = state.publishedArticles[index];
                final category = state.categoryById(article.categoryId);
                return PublishedArticleRow(
                  article: article,
                  categoryName: category?.name ?? article.categoryId,
                  onTapView: () => onViewArticle(article.id),
                  onTapEdit: () {},
                  onTapDelete: () => onDeleteArticle(article.id),
                );
              },
            ),
          ],
          if (state.publishedArticles.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Text(
                  'Aún no tienes artículos publicados.',
                  style: AppTypography.body
                      .copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
