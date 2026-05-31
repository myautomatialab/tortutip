import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/config/auth_routes.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/articles/config/articles_routes.dart';
import '../../features/onboarding/config/onboarding_routes.dart';
import '../../features/profile/config/profile_routes.dart';
import 'app_routes.dart';
import 'app_shell.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: AppRoutes.login,
      debugLogDiagnostics: true,
      refreshListenable: _AuthNotifier(context.read<AuthBloc>()),
      redirect: (context, state) => _redirect(context, state),
      routes: [
        ...AuthRoutes.routes,
        ...OnboardingRoutes.routes,
        ...ArticlesRoutes.routes,

        // Un único ShellRoute que mantiene AppShell vivo entre tabs
        ShellRoute(
          builder: (_, _, child) => AppShell(child: child),
          routes: [
            ...ArticlesRoutes.shellRoutes,
            ...ProfileRoutes.shellRoutes,
          ],
        ),
      ],
      errorBuilder: (_, state) => Scaffold(
        body: Center(
          child: Text('Ruta no encontrada: ${state.error}'),
        ),
      ),
    );
  }

  static String? _redirect(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthBloc>().state;
    final location = state.matchedLocation;
    final isOnLogin = location == AppRoutes.login;
    final isOnboarding = location.startsWith('/onboarding');

    if (authState is! AuthAuthenticated) {
      return (!isOnLogin && !isOnboarding) ? AppRoutes.login : null;
    }

    final user = authState.user;

    if (isOnLogin) {
      return user.role.isEmpty ? AppRoutes.onboardingCategories : AppRoutes.feed;
    }

    if (!isOnboarding && user.role.isEmpty) {
      return AppRoutes.onboardingCategories;
    }

    return null;
  }
}

class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(AuthBloc bloc) {
    bloc.stream.listen((_) => notifyListeners());
  }
}
