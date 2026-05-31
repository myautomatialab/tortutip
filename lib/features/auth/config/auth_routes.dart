import 'package:go_router/go_router.dart';

import '../../../config/routes/app_routes.dart';
import '../presentation/screens/login_screen.dart';

class AuthRoutes {
  AuthRoutes._();

  static final routes = <RouteBase>[
    GoRoute(
      path: AppRoutes.login,
      builder: (_, _) => const LoginScreen(),
    ),
  ];
}
