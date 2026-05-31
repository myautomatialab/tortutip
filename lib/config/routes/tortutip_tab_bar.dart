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
        AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.xxl,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 20,
              color: Colors.black.withValues(alpha: 0.4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TabIcon(
              icon: Icons.edit_outlined,
              selected: currentIndex == 0,
              onTap: () => onTabTap(0),
            ),
            _TabIcon(
              icon: Icons.bookmark_border,
              selected: currentIndex == 1,
              onTap: () => onTabTap(1),
            ),
            _TabIconCenter(onTap: () => onTabTap(2)),
            _TabIcon(
              icon: Icons.camera_alt_outlined,
              selected: currentIndex == 3,
              onTap: () => onTabTap(3),
            ),
            _TabIcon(
              icon: Icons.more_horiz,
              selected: currentIndex == 4,
              onTap: () => onTabTap(4),
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
          color: selected
              ? AppColors.textOnDark
              : AppColors.textOnDark.withValues(alpha: 0.54),
          size: 26,
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
        width: 52,
        height: 52,
        decoration: const BoxDecoration(
          color: AppColors.primaryDark,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.search,
          color: AppColors.textOnDark,
          size: 22,
        ),
      ),
    );
  }
}
