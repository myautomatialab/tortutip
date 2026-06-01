import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/features/categories/domain/entities/category_entity.dart';
import 'package:tortutip/features/categories/domain/use_cases/get_all_categories_use_case.dart';
import 'package:tortutip/features/explore/presentation/bloc/explore_state.dart';
import 'package:tortutip/features/tortu_feed/domain/repository/tortu_feed_repository.dart';
import 'package:tortutip/features/tortu_feed/domain/use_cases/get_category_progress_use_case.dart';

class ExploreCubit extends Cubit<ExploreState> {
  final GetAllCategoriesUseCase _getAllCategories;
  final GetCategoryProgressUseCase _getCategoryProgress;

  ExploreCubit(
    this._getAllCategories,
    this._getCategoryProgress,
  ) : super(const ExploreInitial());

  Future<void> loadExplore({
    String userId = '',
    String categoryId = '',
  }) async {
    emit(const ExploreLoading());

    if (categoryId.isEmpty) {
      final result = await _getAllCategories(const NoParams());
      if (result.isSuccess) {
        emit(ExploreLoaded(
          categories: result.data!,
          streakDays: 14,
          categoryProgress: 0.0,
        ));
      } else {
        emit(const ExploreError('No se pudieron cargar las categorías'));
      }
      return;
    }

    final results = await Future.wait([
      _getAllCategories(const NoParams()),
      _getCategoryProgress(
          GetCategoryProgressParams(userId: userId, categoryId: categoryId)),
    ]);

    final categoriesResult = results[0];
    final progressResult = results[1];

    if (!categoriesResult.isSuccess) {
      emit(const ExploreError('No se pudieron cargar las categorías'));
      return;
    }

    final progress = progressResult.isSuccess
        ? (progressResult.data as double? ?? 0.0)
        : 0.0;

    emit(ExploreLoaded(
      categories: List<CategoryEntity>.from(categoriesResult.data as List),
      streakDays: 14,
      categoryProgress: progress,
    ));
  }
}
