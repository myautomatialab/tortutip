import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import 'tortutip_tab_bar.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({
    super.key,
    required this.child,
  });

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/feed'))    return 0;
    if (location.startsWith('/explore')) return 2;
    return 0;
  }

  void _onTabTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.feed);
      case 1:
        context.push(AppRoutes.create);
      case 2:
        context.go(AppRoutes.explore);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: TortuTipTabBar(
        currentIndex: _currentIndex(context),
        onTabTap: (i) => _onTabTap(context, i),
      ),
    );
  }
}
