import 'package:tortutip/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:tortutip/features/auth/hardcore/hardcore_data_fixtures.dart';
import 'package:tortutip/features/auth/hardcore/hardcore_session.dart';
import 'package:tortutip/shared/user/domain/entities/user_entity.dart';

class HardcoreAuthDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserEntity> signInWithGoogle() {
    throw UnimplementedError('Not available in hardcore mode');
  }

  @override
  Future<void> signOut() async {
    HardcoreSession.end();
  }

  @override
  Future<UserEntity?> checkCurrentUser() async {
    if (HardcoreSession.isActive) {
      return HardcoreDataFixtures.hardcoreUser;
    }
    return null;
  }

  @override
  Future<void> deleteCurrentUser() {
    throw UnimplementedError('Not available in hardcore mode');
  }
}
