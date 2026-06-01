import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/features/categories/domain/entities/category_entity.dart';
import 'package:tortutip/features/categories/domain/use_cases/get_all_categories_use_case.dart';
import 'package:tortutip/features/explore/presentation/bloc/explore_cubit.dart';
import 'package:tortutip/features/explore/presentation/bloc/explore_state.dart';

class MockGetAllCategoriesUseCase extends Mock
    implements GetAllCategoriesUseCase {}

void main() {
  late ExploreCubit cubit;
  late MockGetAllCategoriesUseCase mockGetAllCategories;

  setUp(() {
    mockGetAllCategories = MockGetAllCategoriesUseCase();
    cubit = ExploreCubit(mockGetAllCategories);
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
