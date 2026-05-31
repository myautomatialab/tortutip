import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';

class TortuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showTitle;

  const TortuAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.showTitle = true,
  });

  factory TortuAppBar.main({List<Widget>? actions}) {
    return TortuAppBar(
      title: 'TortuTip',
      actions: actions,
    );
  }

  factory TortuAppBar.detail({required String title, List<Widget>? actions}) {
    return TortuAppBar(
      title: title,
      actions: actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: leading,
      title: showTitle
          ? Text(
              title ?? 'TortuTip',
              style: AppTypography.h2,
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
