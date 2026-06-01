import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class TortuTipTabBar extends StatelessWidget {
  final String? avatarUrl;
  final VoidCallback onProfileTap;

  const TortuTipTabBar({
    super.key,
    required this.avatarUrl,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Text(
              'TortuTip',
              style: AppTypography.h2.copyWith(fontWeight: FontWeight.w800),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onProfileTap,
              child: _ProfileAvatar(avatarUrl: avatarUrl),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;

  const _ProfileAvatar({required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final hasImage = avatarUrl != null && avatarUrl!.isNotEmpty;
    return CircleAvatar(
      radius: AppSpacing.avatarSizeMd / 2,
      backgroundColor: AppColors.surface,
      child: hasImage
          ? ClipOval(
              child: Image.network(
                avatarUrl!,
                width: AppSpacing.avatarSizeMd,
                height: AppSpacing.avatarSizeMd,
                fit: BoxFit.cover,
                errorBuilder: (_, e, stack) => const Icon(
                  Icons.person_outline,
                  size: AppSpacing.iconMd,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : const Icon(
              Icons.person_outline,
              size: AppSpacing.iconMd,
              color: AppColors.textSecondary,
            ),
    );
  }
}
