import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_typography.dart';
import '../../../../shared/widgets/tortutip_button.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_bottom_sheet.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 0: 2x2 color grid collage
          Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(color: AppColors.categoryHealthyFood),
                    ),
                    Expanded(
                      child: Container(color: AppColors.categoryFitness),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(color: AppColors.categoryMentalHealth),
                    ),
                    Expanded(
                      child: Container(color: AppColors.categoryProductividad),
                    ),
                  ],
                ),
              ),
            ],
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

          // Layer 2: Content
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
                    Row(
                      children: [
                        Expanded(
                          child: TortuPrimaryButton(
                            label: 'Acceder',
                            onTap: () => _showAuthBottomSheet(context),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _GoogleCircleButton(
                          onTap: () => _showAuthBottomSheet(context),
                        ),
                      ],
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
  }
}

void _showAuthBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusXl),
      ),
    ),
    builder: (_) => BlocProvider.value(
      value: context.read<AuthBloc>(),
      child: const AuthBottomSheet(),
    ),
  );
}

class _GoogleCircleButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _GoogleCircleButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSpacing.buttonHeight,
        height: AppSpacing.buttonHeight,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Center(
          child: const GoogleLogoIcon(),
        ),
      ),
    );
  }
}
