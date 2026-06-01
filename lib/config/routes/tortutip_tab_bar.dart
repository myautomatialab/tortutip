import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class TortuTipTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabTap;

  const TortuTipTabBar({
    super.key,
    required this.currentIndex,
    required this.onTabTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.xxxl,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.huge, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TabIcon(
              icon: Icons.article_outlined,
              selected: currentIndex == 0,
              onTap: () => onTabTap(0),
            ),
            _TabIconCenter(onTap: () => onTabTap(1)),
            _TabIcon(
              icon: Icons.explore_outlined,
              selected: currentIndex == 2,
              onTap: () => onTabTap(2),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Icon(
          icon,
          color: selected ? AppColors.textOnDark : AppColors.textOnDark.withValues(alpha: 0.54),
          size: AppSpacing.iconTabBar,
        ),
      ),
    );
  }
}

class _TabIconCenter extends StatelessWidget {
  final VoidCallback onTap;
  const _TabIconCenter({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSpacing.tabCenterButtonSize,
        height: AppSpacing.tabCenterButtonSize,
        decoration: const BoxDecoration(
          color: AppColors.primaryDark,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.edit_outlined,
          color: AppColors.textOnDark,
          size: 22,
        ),
      ),
    );
  }
}
