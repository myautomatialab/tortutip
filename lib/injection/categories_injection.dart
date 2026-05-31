import 'package:get_it/get_it.dart';

import '../features/categories/data/data_sources/category_remote_data_source.dart';
import '../features/categories/data/data_sources/mock_category_remote_data_source.dart';
import '../features/categories/data/repository/category_repository_impl.dart';
import '../features/categories/domain/repository/category_repository.dart';
import '../features/categories/domain/use_cases/get_all_categories_use_case.dart';
import '../features/categories/presentation/bloc/category_cubit.dart';

final sl = GetIt.instance;

void initCategoriesDependencies() {
  // DataSource — using mock until Firestore is populated
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => MockCategoryRemoteDataSource(),
  );

  // Repository
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl()),
  );

  // Use case
  sl.registerLazySingleton(() => GetAllCategoriesUseCase(sl()));

  // Cubit
  sl.registerFactory(() => CategoryCubit(sl()));
}
