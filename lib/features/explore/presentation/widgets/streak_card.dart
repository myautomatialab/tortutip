import 'package:flutter/material.dart';
import 'package:tortutip/config/theme/app_colors.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/config/theme/app_typography.dart';

class StreakCard extends StatelessWidget {
  final int streakDays;

  const StreakCard({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF7ED),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: 0.01,
                  color: AppColors.primary,
                  strokeWidth: 4,
                  backgroundColor: AppColors.surface,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/turtle.png',
                    width: 48,
                    height: 48,
                    errorBuilder: (_, __, ___) => Text(
                      '🐢',
                      style: AppTypography.hero,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Text(
                    '1%',
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Day $streakDays streak',
                  style: AppTypography.h2.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '🔥 Keep it up!',
                  style: AppTypography.body.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
