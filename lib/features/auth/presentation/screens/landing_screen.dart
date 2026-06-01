import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_typography.dart';
import '../../../../shared/widgets/tortutip_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError && state.message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Layer 0: splash image full screen
              Image.asset(
                'assets/images/splash_logo.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),

              // Layer 0.5: WELLNESS text centered over collage
              Positioned.fill(
                child: Center(
                  child: Text(
                    'WELLNESS ⊙',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.white,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              // Layer 1: Gradient overlay bottom to top
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.transparent, AppColors.background],
                      stops: [0.3, 0.7],
                    ),
                  ),
                ),
              ),

              // Layer 2: Hardcore mode trigger — discrete icon, bottom-right corner
              Positioned(
                right: AppSpacing.lg,
                bottom: AppSpacing.xxl,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () => context
                        .read<AuthBloc>()
                        .add(const EnterHardcoreModeEvent()),
                    child: Icon(
                      Icons.developer_mode,
                      size: AppSpacing.iconSizeMd,
                      color: AppColors.textTertiary.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),

              // Layer 3: Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenHorizontal,
                      vertical: AppSpacing.xxl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
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
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const Text(
                          'Crea una vida que te guste',
                          style: AppTypography.hero,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        const Text(
                          'Get better, one tip at a time.',
                          style: AppTypography.subtitle,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        TortuGoogleButton(
                          isLoading: state is AuthLoading,
                          onTap: () => context
                              .read<AuthBloc>()
                              .add(const SignInWithGoogleEvent()),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTypography.caption,
                            children: [
                              const TextSpan(
                                text: 'Si continuas, aceptas los ',
                              ),
                              TextSpan(
                                text: 'Terminos del servicio',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.primary,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    ' de TortuTip y confirmas que has leido nuestra ',
                              ),
                              TextSpan(
                                text: 'Politica de privacidad',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.primary,
                                ),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
