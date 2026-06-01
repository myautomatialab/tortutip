import 'package:flutter_test/flutter_test.dart';
import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/features/auth/data/repository/hardcore_auth_repository_impl.dart';
import 'package:tortutip/features/auth/hardcore/hardcore_session.dart';

void main() {
  late HardcoreAuthRepositoryImpl repository;

  setUp(() {
    HardcoreSession.end();
    repository = HardcoreAuthRepositoryImpl();
  });

  tearDown(() => HardcoreSession.end());

  group('HardcoreAuthRepositoryImpl.enterHardcoreMode', () {
    test(
      'enterHardcoreMode_should_activate_HardcoreSession_and_return_DataSuccess',
      () async {
        expect(HardcoreSession.isActive, isFalse);

        final result = await repository.enterHardcoreMode();

        expect(result, isA<DataSuccess>());
        expect(HardcoreSession.isActive, isTrue);
      },
    );

    test(
      'enterHardcoreMode_should_return_user_with_role_writer',
      () async {
        final result = await repository.enterHardcoreMode();

        expect(result.isSuccess, isTrue);
        expect(result.data!.role, equals('writer'));
      },
    );
  });
}
