import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/features/articles/domain/use_cases/get_user_articles_use_case.dart';
import 'package:tortutip/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:tortutip/features/profile/presentation/bloc/profile_state.dart';
import 'package:tortutip/shared/user/domain/entities/user_entity.dart';
import 'package:tortutip/shared/user/domain/use_cases/get_current_user_use_case.dart';

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockGetUserArticlesUseCase extends Mock
    implements GetUserArticlesUseCase {}

void main() {
  late ProfileCubit cubit;
  late MockGetCurrentUserUseCase mockGetCurrentUser;
  late MockGetUserArticlesUseCase mockGetUserArticles;

  final user = UserEntity(
    id: 'user_1',
    name: 'Test User',
    email: 'test@test.com',
    avatarUrl: '',
    bio: '',
    role: 'reader',
    gender: '',
    ageRange: '',
    createdAt: DateTime(2024),
  );

  final articles = <ArticleEntity>[];

  setUp(() {
    mockGetCurrentUser = MockGetCurrentUserUseCase();
    mockGetUserArticles = MockGetUserArticlesUseCase();
    cubit = ProfileCubit(mockGetCurrentUser, mockGetUserArticles);
  });

  tearDown(() => cubit.close());

  group('ProfileCubit.loadProfile', () {
    blocTest<ProfileCubit, ProfileState>(
      'should_emit_Loading_then_Loaded_when_both_use_cases_succeed',
      build: () {
        when(() => mockGetCurrentUser(const NoParams()))
            .thenAnswer((_) async => DataSuccess(user));
        when(() => mockGetUserArticles('user_1'))
            .thenAnswer((_) async => DataSuccess(articles));
        return cubit;
      },
      act: (c) => c.loadProfile('user_1'),
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileLoaded>(),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'should_emit_Loading_then_Error_when_getCurrentUser_fails',
      build: () {
        when(() => mockGetCurrentUser(const NoParams()))
            .thenAnswer((_) async => DataFailed(Exception('error')));
        return cubit;
      },
      act: (c) => c.loadProfile('user_1'),
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileError>(),
      ],
      verify: (_) {
        verifyNever(() => mockGetUserArticles(any()));
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      'should_emit_Loading_then_Error_when_getUserArticles_fails',
      build: () {
        when(() => mockGetCurrentUser(const NoParams()))
            .thenAnswer((_) async => DataSuccess(user));
        when(() => mockGetUserArticles('user_1'))
            .thenAnswer((_) async => DataFailed(Exception('error')));
        return cubit;
      },
      act: (c) => c.loadProfile('user_1'),
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileError>(),
      ],
    );
  });
}
