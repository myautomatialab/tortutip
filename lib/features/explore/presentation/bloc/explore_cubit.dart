import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/features/categories/domain/use_cases/get_all_categories_use_case.dart';
import 'package:tortutip/features/explore/presentation/bloc/explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  final GetAllCategoriesUseCase _getAllCategories;

  ExploreCubit(this._getAllCategories) : super(const ExploreInitial());

  Future<void> loadExplore() async {
    emit(const ExploreLoading());
    final result = await _getAllCategories(const NoParams());
    if (result.isSuccess) {
      emit(ExploreLoaded(categories: result.data!, streakDays: 14));
    } else {
      emit(const ExploreError('No se pudieron cargar las categorías'));
    }
  }
}
