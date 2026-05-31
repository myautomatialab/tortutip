import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/shared/user/domain/entities/user_entity.dart';
import 'package:tortutip/shared/user/domain/repository/user_repository.dart';

class GetUserByIdUseCase implements UseCase<DataState<UserEntity>, String> {
  final UserRepository _repository;
  GetUserByIdUseCase(this._repository);

  @override
  Future<DataState<UserEntity>> call(String params) {
    return _repository.getUserById(params);
  }
}
