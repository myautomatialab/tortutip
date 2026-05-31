import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/shared/user/domain/entities/user_entity.dart';
import 'package:tortutip/shared/user/domain/repository/user_repository.dart';

class UpdateUserProfileUseCase implements UseCase<DataState<UserEntity>, UserEntity> {
  final UserRepository _repository;
  UpdateUserProfileUseCase(this._repository);

  @override
  Future<DataState<UserEntity>> call(UserEntity params) {
    return _repository.updateUserProfile(params);
  }
}
