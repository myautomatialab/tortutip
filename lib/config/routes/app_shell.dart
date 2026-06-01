import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

  @override
  Widget build(BuildContext context) {
    final avatarUrl = context.select<AuthBloc, String?>(
      (bloc) => bloc.state is AuthAuthenticated
          ? (bloc.state as AuthAuthenticated).user.avatarUrl
          : null,
    );

    return Scaffold(
      body: Column(
        children: [
          TortuTipTabBar(
            avatarUrl: avatarUrl,
            onProfileTap: () => context.push(AppRoutes.profile),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
