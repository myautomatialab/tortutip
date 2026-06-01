import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tortutip/config/routes/app_routes.dart';
import 'package:tortutip/features/bookmarks/presentation/bloc/bookmarks_cubit.dart';
import 'package:tortutip/features/bookmarks/presentation/screens/bookmarks_screen.dart';
import 'package:tortutip/injection/injection_container.dart';

class BookmarksRoutes {
  BookmarksRoutes._();

  static final routes = <RouteBase>[
    GoRoute(
      path: AppRoutes.bookmarks,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<BookmarksCubit>(),
        child: const BookmarksScreen(),
      ),
    ),
  ];
}
