import 'package:go_router/go_router.dart';

import '../../../config/routes/app_routes.dart';
import '../../../config/routes/app_shell.dart';
import '../presentation/screens/article_detail_screen.dart';
import '../presentation/screens/create_article_screen.dart';
import '../presentation/screens/feed_screen.dart';

class ArticlesRoutes {
  ArticlesRoutes._();

  static final routes = <RouteBase>[
    // Crear — fuera del shell, sin TabBar
    GoRoute(
      path: AppRoutes.create,
      builder: (_, _) => const CreateArticleScreen(),
    ),

    // ShellRoute — Feed con TabBar
    ShellRoute(
      builder: (_, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.feed,
          pageBuilder: (_, _) => const NoTransitionPage(
            child: FeedScreen(),
          ),
          routes: [
            // Push desde Feed — sale del shell, sin TabBar
            GoRoute(
              path: ':articleId',
              builder: (_, state) => ArticleDetailScreen(
                articleId: state.pathParameters['articleId']!,
              ),
            ),
          ],
        ),
      ],
    ),
  ];
}
