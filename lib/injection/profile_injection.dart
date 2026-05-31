import 'package:get_it/get_it.dart';

import '../features/profile/presentation/bloc/profile_cubit.dart';

final sl = GetIt.instance;

void initProfileDependencies() {
  // Profile no tiene data ni domain propios.
  // Su cubit consume use_cases ya registrados en user y articles.
  sl.registerFactory(
    () => ProfileCubit(
      sl(), // GetCurrentUserUseCase — registrado en user_injection
      sl(), // GetUserArticlesUseCase — registrado en articles_injection
    ),
  );
}
