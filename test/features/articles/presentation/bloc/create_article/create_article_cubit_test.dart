import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/features/articles/domain/params/publish_article_params.dart';
import 'package:tortutip/features/articles/domain/use_cases/publish_article_use_case.dart';
import 'package:tortutip/features/articles/presentation/bloc/create_article/create_article_cubit.dart';
import 'package:tortutip/features/articles/presentation/bloc/create_article/create_article_state.dart';

class MockPublishArticleUseCase extends Mock implements PublishArticleUseCase {}

void main() {
  late CreateArticleCubit cubit;
  late MockPublishArticleUseCase mockPublishArticle;

  const params = PublishArticleParams(
    authorId: 'user_1',
    categoryId: 'cat_1',
    title: 'Title',
    body: 'Body',
    coverVerticalUrl: '',
    coverHorizontalUrl: '',
  );

  final article = ArticleEntity(
    id: 'art_1',
    authorId: 'user_1',
    categoryId: 'cat_1',
    title: 'Title',
    body: 'Body',
    coverVerticalUrl: '',
    coverHorizontalUrl: '',
    status: 'published',
    readTimeMinutes: 2,
    saveCount: 0,
    createdAt: DateTime(2024),
  );

  setUp(() {
    mockPublishArticle = MockPublishArticleUseCase();
    cubit = CreateArticleCubit(mockPublishArticle);
    registerFallbackValue(params);
  });

  tearDown(() => cubit.close());

  group('CreateArticleCubit.publish', () {
    blocTest<CreateArticleCubit, CreateArticleState>(
      'should_emit_Loading_then_Success_when_publish_succeeds',
      build: () {
        when(() => mockPublishArticle(any()))
            .thenAnswer((_) async => DataSuccess(article));
        return cubit;
      },
      act: (c) => c.publish(params),
      expect: () => [
        isA<CreateArticleLoading>(),
        isA<CreateArticleSuccess>(),
      ],
    );

    blocTest<CreateArticleCubit, CreateArticleState>(
      'should_emit_Loading_then_Error_when_publish_fails',
      build: () {
        when(() => mockPublishArticle(any()))
            .thenAnswer((_) async => DataFailed(Exception('error')));
        return cubit;
      },
      act: (c) => c.publish(params),
      expect: () => [
        isA<CreateArticleLoading>(),
        isA<CreateArticleError>(),
      ],
    );
  });
}
