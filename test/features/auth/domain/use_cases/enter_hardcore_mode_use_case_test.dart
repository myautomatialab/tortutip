import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/features/auth/data/repository/hardcore_auth_repository_impl.dart';
import 'package:tortutip/features/auth/domain/use_cases/enter_hardcore_mode_use_case.dart';
import 'package:tortutip/features/auth/hardcore/hardcore_session.dart';
import 'package:tortutip/shared/user/domain/entities/user_entity.dart';

class MockHardcoreAuthRepositoryImpl extends Mock
    implements HardcoreAuthRepositoryImpl {}

void main() {
  late EnterHardcoreModeUseCase useCase;
  late MockHardcoreAuthRepositoryImpl mockRepository;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    HardcoreSession.end();
    mockRepository = MockHardcoreAuthRepositoryImpl();
    useCase = EnterHardcoreModeUseCase(mockRepository);
  });

  group('EnterHardcoreModeUseCase', () {
    final tUser = UserEntity(
      id: 'hardcore_001',
      name: 'Alex Hardcore',
      email: 'hardcore@tortutip.dev',
      avatarUrl: '',
      bio: '',
      role: 'writer',
      gender: 'male',
      ageRange: '25-34',
      createdAt: DateTime(2024),
    );

    test(
      'should_return_DataSuccess_with_hardcore_user_when_repository_returns_success',
      () async {
        when(() => mockRepository.enterHardcoreMode())
            .thenAnswer((_) async => DataSuccess(tUser));

        final result = await useCase(const NoParams());

        expect(result, isA<DataSuccess<UserEntity>>());
        expect(result.data, equals(tUser));
        verify(() => mockRepository.enterHardcoreMode()).called(1);
      },
    );

    test(
      'should_return_DataFailed_when_repository_returns_failure',
      () async {
        final exception = Exception('Hardcore error');
        when(() => mockRepository.enterHardcoreMode())
            .thenAnswer((_) async => DataFailed(exception));

        final result = await useCase(const NoParams());

        expect(result, isA<DataFailed<UserEntity>>());
        expect(result.error, equals(exception));
      },
    );
  });
}
