import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_typography.dart';
import '../../../../shared/widgets/tortutip_button.dart';

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bolt,
                      color: AppColors.primary,
                      size: AppSpacing.huge,
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
                    TortuPrimaryButton(
                      label: 'Acceder',
                      onTap: () => context.push(AppRoutes.login),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      'Al continuar aceptas los Términos y la Política de privacidad.',
                      style: AppTypography.caption,
                      textAlign: TextAlign.center,
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
