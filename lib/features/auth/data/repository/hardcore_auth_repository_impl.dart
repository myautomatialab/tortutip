import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/features/auth/hardcore/hardcore_data_fixtures.dart';
import 'package:tortutip/features/auth/hardcore/hardcore_session.dart';
import 'package:tortutip/shared/user/domain/entities/user_entity.dart';

class HardcoreAuthRepositoryImpl {
  Future<DataState<UserEntity>> enterHardcoreMode() async {
    try {
      HardcoreSession.start();
      return DataSuccess(HardcoreDataFixtures.hardcoreUser);
    } on Exception catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<bool>> signOut() async {
    HardcoreSession.end();
    return const DataSuccess(true);
  }

  Future<DataState<UserEntity>> signInWithGoogle() async {
    return DataFailed(Exception('Not available in hardcore mode'));
  }

  Future<DataState<UserEntity>> checkCurrentAuth() async {
    if (HardcoreSession.isActive) {
      return DataSuccess(HardcoreDataFixtures.hardcoreUser);
    }
    return DataFailed(Exception('No active hardcore session'));
  }

  Future<DataState<bool>> deleteAccount() async {
    return DataFailed(Exception('Not available in hardcore mode'));
  }
}
