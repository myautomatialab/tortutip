import 'package:go_router/go_router.dart';

import '../../../config/routes/app_routes.dart';
import '../presentation/screens/article_detail_screen.dart';
import '../presentation/screens/create_article_screen.dart';
import '../presentation/screens/feed_screen.dart';

class ArticlesRoutes {
  ArticlesRoutes._();

  // Fuera del shell — sin TabBar
  static final routes = <RouteBase>[
    GoRoute(
      path: AppRoutes.create,
      builder: (_, _) => const CreateArticleScreen(),
    ),
    GoRoute(
      path: '/article/:articleId',
      builder: (_, state) => ArticleDetailScreen(
        articleId: state.pathParameters['articleId']!,
      ),
    ),
  ];

  // Dentro del shell — con TabBar
  static final shellRoutes = <RouteBase>[
    GoRoute(
      path: AppRoutes.feed,
      pageBuilder: (_, _) => const NoTransitionPage(child: FeedScreen()),
      routes: [
        GoRoute(
          path: ':articleId',
          builder: (_, state) => ArticleDetailScreen(
            articleId: state.pathParameters['articleId']!,
          ),
        ),
      ],
    ),
  ];
}
