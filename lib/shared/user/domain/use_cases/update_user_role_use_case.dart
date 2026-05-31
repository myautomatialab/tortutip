import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/shared/user/domain/repository/user_repository.dart';

class UpdateUserRoleParams {
  final String userId;
  final String role;
  const UpdateUserRoleParams({required this.userId, required this.role});
}

class UpdateUserRoleUseCase implements UseCase<DataState<bool>, UpdateUserRoleParams> {
  final UserRepository _repository;
  UpdateUserRoleUseCase(this._repository);

  @override
  Future<DataState<bool>> call(UpdateUserRoleParams params) {
    return _repository.updateUserRole(params.userId, params.role);
  }
}
