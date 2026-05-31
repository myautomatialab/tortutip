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

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/feed')) return 0;
    if (location.startsWith('/explore')) return 2;
    return -1;
  }

  void _onTabTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Lápiz: create if writer, placeholder otherwise
        final authState = context.read<AuthBloc>().state;
        if (authState is AuthAuthenticated &&
            authState.user.role == 'writer') {
          context.push(AppRoutes.create);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Función disponible para escritores')),
          );
        }
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guardados próximamente')),
        );
      case 2:
        context.go(AppRoutes.explore);
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cámara próximamente')),
        );
      case 4:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Más opciones próximamente')),
        );
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
