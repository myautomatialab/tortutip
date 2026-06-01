import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/features/auth/data/repository/hardcore_auth_repository_impl.dart';
import 'package:tortutip/shared/user/domain/entities/user_entity.dart';

class EnterHardcoreModeUseCase
    implements UseCase<DataState<UserEntity>, NoParams> {
  final HardcoreAuthRepositoryImpl _repository;

  EnterHardcoreModeUseCase(this._repository);

  @override
  Future<DataState<UserEntity>> call(NoParams params) =>
      _repository.enterHardcoreMode();
}
