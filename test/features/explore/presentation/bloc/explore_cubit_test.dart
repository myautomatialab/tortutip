import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/features/categories/domain/entities/category_entity.dart';
import 'package:tortutip/features/categories/domain/use_cases/get_all_categories_use_case.dart';
import 'package:tortutip/features/explore/presentation/bloc/explore_cubit.dart';
import 'package:tortutip/features/explore/presentation/bloc/explore_state.dart';
import 'package:tortutip/features/tortu_feed/domain/repository/tortu_feed_repository.dart';
import 'package:tortutip/features/tortu_feed/domain/use_cases/get_category_progress_use_case.dart';

class MockGetAllCategoriesUseCase extends Mock
    implements GetAllCategoriesUseCase {}

class MockGetCategoryProgressUseCase extends Mock
    implements GetCategoryProgressUseCase {}

void main() {
  late ExploreCubit cubit;
  late MockGetAllCategoriesUseCase mockGetAllCategories;
  late MockGetCategoryProgressUseCase mockGetCategoryProgress;

  setUp(() {
    mockGetAllCategories = MockGetAllCategoriesUseCase();
    mockGetCategoryProgress = MockGetCategoryProgressUseCase();
    registerFallbackValue(
        const GetCategoryProgressParams(userId: 'u', categoryId: 'c'));
    cubit = ExploreCubit(mockGetAllCategories, mockGetCategoryProgress);
  });

  tearDown(() => cubit.close());

  group('ExploreCubit', () {
    final categories = [
      const CategoryEntity(
        id: 'cat_1',
        name: 'Fitness',
        description: 'Get fit',
        iconUrl: 'https://example.com/fitness.jpg',
      ),
    ];

    blocTest<ExploreCubit, ExploreState>(
      'should_emit_loading_then_loaded_when_categories_succeed',
      build: () {
        when(() => mockGetAllCategories(const NoParams()))
            .thenAnswer((_) async => DataSuccess(categories));
        return cubit;
      },
      act: (c) => c.loadExplore(),
      expect: () => [
        isA<ExploreLoading>(),
        isA<ExploreLoaded>(),
      ],
      verify: (_) {
        verify(() => mockGetAllCategories(const NoParams())).called(1);
      },
    );

    blocTest<ExploreCubit, ExploreState>(
      'should_set_streakDays_to_14_when_loaded',
      build: () {
        when(() => mockGetAllCategories(const NoParams()))
            .thenAnswer((_) async => DataSuccess(categories));
        return cubit;
      },
      act: (c) => c.loadExplore(),
      expect: () => [
        isA<ExploreLoading>(),
        isA<ExploreLoaded>().having((s) => s.streakDays, 'streakDays', 14),
      ],
    );

    blocTest<ExploreCubit, ExploreState>(
      'should_emit_loaded_with_categoryProgress_when_categoryId_provided',
      build: () {
        when(() => mockGetAllCategories(const NoParams()))
            .thenAnswer((_) async => DataSuccess(categories));
        when(() => mockGetCategoryProgress(any()))
            .thenAnswer((_) async => const DataSuccess(0.05));
        return cubit;
      },
      act: (c) => c.loadExplore(userId: 'user_1', categoryId: 'cat_1'),
      expect: () => [
        isA<ExploreLoading>(),
        isA<ExploreLoaded>()
            .having((s) => s.categoryProgress, 'categoryProgress', 0.05),
      ],
    );

    blocTest<ExploreCubit, ExploreState>(
      'should_emit_loaded_with_zero_progress_when_no_categoryId',
      build: () {
        when(() => mockGetAllCategories(const NoParams()))
            .thenAnswer((_) async => DataSuccess(categories));
        return cubit;
      },
      act: (c) => c.loadExplore(),
      expect: () => [
        isA<ExploreLoading>(),
        isA<ExploreLoaded>()
            .having((s) => s.categoryProgress, 'categoryProgress', 0.0),
      ],
    );

    blocTest<ExploreCubit, ExploreState>(
      'should_emit_loading_then_error_when_categories_fail',
      build: () {
        when(() => mockGetAllCategories(const NoParams()))
            .thenAnswer((_) async => DataFailed(Exception('error')));
        return cubit;
      },
      act: (c) => c.loadExplore(),
      expect: () => [
        isA<ExploreLoading>(),
        isA<ExploreError>(),
      ],
    );
  });
}
