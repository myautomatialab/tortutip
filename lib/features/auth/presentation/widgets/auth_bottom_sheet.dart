import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_typography.dart';
import '../../../../shared/widgets/tortutip_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthBottomSheet extends StatelessWidget {
  const AuthBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.xl),
          const _BoltIconCircle(),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'Bienvenido a TortuTip',
            style: AppTypography.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Protegemos tu privacidad. Solo Google.',
            style: AppTypography.subtitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.huge),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError && state.message.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return TortuGoogleButton(
                isLoading: state is AuthLoading,
                onTap: () {
                  context.read<AuthBloc>().add(const SignInWithGoogleEvent());
                },
              );
            },
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _BoltIconCircle extends StatelessWidget {
  const _BoltIconCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.avatarSizeLg,
      height: AppSpacing.avatarSizeLg,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.12),
      ),
      child: const Icon(
        Icons.bolt,
        color: AppColors.primary,
        size: AppSpacing.iconSizeLg,
      ),
    );
  }
}
