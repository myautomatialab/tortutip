import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/features/categories/domain/use_cases/get_all_categories_use_case.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetAllCategoriesUseCase _getAllCategories;
  CategoryCubit(this._getAllCategories) : super(CategoryInitial());

  Future<void> loadCategories() async {
    emit(CategoryLoading());
    final result = await _getAllCategories(NoParams());
    if (result.data != null) {
      emit(CategoryLoaded(result.data!));
    } else {
      emit(CategoryError(result.error.toString()));
    }
  }
}
