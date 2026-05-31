import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/features/articles/domain/use_cases/get_feed_articles_use_case.dart';
import 'package:tortutip/features/articles/presentation/bloc/feed/feed_cubit.dart';
import 'package:tortutip/features/articles/presentation/bloc/feed/feed_state.dart';

class MockGetFeedArticlesUseCase extends Mock
    implements GetFeedArticlesUseCase {}

void main() {
  late FeedCubit cubit;
  late MockGetFeedArticlesUseCase mockGetFeedArticles;

  setUp(() {
    mockGetFeedArticles = MockGetFeedArticlesUseCase();
    cubit = FeedCubit(mockGetFeedArticles);
  });

  tearDown(() => cubit.close());

  group('FeedCubit.loadFeed', () {
    final categoryIds = ['cat_1'];
    final articles = <ArticleEntity>[];

    blocTest<FeedCubit, FeedState>(
      'should_emit_Loading_then_Loaded_when_use_case_succeeds',
      build: () {
        when(() => mockGetFeedArticles(categoryIds))
            .thenAnswer((_) async => DataSuccess(articles));
        return cubit;
      },
      act: (c) => c.loadFeed(categoryIds),
      expect: () => [
        isA<FeedLoading>(),
        isA<FeedLoaded>(),
      ],
    );

    blocTest<FeedCubit, FeedState>(
      'should_emit_Loading_then_Error_when_use_case_fails',
      build: () {
        when(() => mockGetFeedArticles(categoryIds))
            .thenAnswer((_) async => DataFailed(Exception('error')));
        return cubit;
      },
      act: (c) => c.loadFeed(categoryIds),
      expect: () => [
        isA<FeedLoading>(),
        isA<FeedError>(),
      ],
    );
  });
}
