import 'package:go_router/go_router.dart';

import '../../../config/routes/app_routes.dart';
import '../../../config/routes/app_shell.dart';
import '../presentation/screens/edit_profile_screen.dart';
import '../presentation/screens/explore_screen.dart';

class ProfileRoutes {
  ProfileRoutes._();

  static final routes = <RouteBase>[
    // ShellRoute — Explorar con TabBar
    ShellRoute(
      builder: (_, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.explore,
          pageBuilder: (_, _) => const NoTransitionPage(
            child: ExploreScreen(),
          ),
          routes: [
            // Push desde Explorar — sale del shell, sin TabBar
            GoRoute(
              path: 'edit',
              builder: (_, _) => const EditProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ];
}
