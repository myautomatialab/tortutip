import 'package:go_router/go_router.dart';
import 'package:tortutip/config/routes/app_routes.dart';
import 'package:tortutip/features/profile/presentation/screens/profile_screen.dart';

class ProfileRoutes {
  ProfileRoutes._();

  static final routes = <RouteBase>[
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
  ];
}
