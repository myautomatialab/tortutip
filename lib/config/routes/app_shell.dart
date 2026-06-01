import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tortutip/features/articles/presentation/bloc/feed/feed_cubit.dart';
import 'package:tortutip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tortutip/features/auth/presentation/bloc/auth_state.dart';

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
    if (location.startsWith('/feed')) return 0;
    if (location.startsWith('/explore')) return 2;
    return -1;
  }

  void _onTabTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.feed);
      case 1:
        final authState = context.read<AuthBloc>().state;
        if (authState is AuthAuthenticated && authState.user.role == 'writer') {
          context.push(AppRoutes.create).then((_) {
            // Refresh feed when returning from create screen
            GetIt.instance<FeedCubit>().refresh();
          });
        }
      case 2:
        context.go(AppRoutes.explore);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: TortuTipTabBar(
        currentIndex: _currentIndex(context),
        onTabTap: (i) => _onTabTap(context, i),
      ),
    );
  }
}
