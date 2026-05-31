import 'package:go_router/go_router.dart';

import '../../../config/routes/app_routes.dart';
import '../presentation/screens/edit_profile_screen.dart';
import '../presentation/screens/explore_screen.dart';

class ProfileRoutes {
  ProfileRoutes._();

  // Dentro del shell — con TabBar
  static final shellRoutes = <RouteBase>[
    GoRoute(
      path: AppRoutes.explore,
      pageBuilder: (_, _) => const NoTransitionPage(child: ExploreScreen()),
      routes: [
        GoRoute(
          path: 'edit',
          builder: (_, _) => const EditProfileScreen(),
        ),
      ],
    ),
  ];
}
