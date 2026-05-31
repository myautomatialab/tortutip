import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/features/articles/domain/use_cases/get_article_detail_use_case.dart';
import 'package:tortutip/features/articles/presentation/bloc/article_detail/article_detail_cubit.dart';
import 'package:tortutip/features/articles/presentation/bloc/article_detail/article_detail_state.dart';

class MockGetArticleDetailUseCase extends Mock
    implements GetArticleDetailUseCase {}

void main() {
  late ArticleDetailCubit cubit;
  late MockGetArticleDetailUseCase mockGetArticleDetail;

  final article = ArticleEntity(
    id: 'art_1',
    authorId: 'user_1',
    categoryId: 'cat_1',
    title: 'Title',
    body: 'Body',
    coverVerticalUrl: '',
    coverHorizontalUrl: '',
    status: 'published',
    readTimeMinutes: 3,
    saveCount: 0,
    createdAt: DateTime(2024),
  );

  setUp(() {
    mockGetArticleDetail = MockGetArticleDetailUseCase();
    cubit = ArticleDetailCubit(mockGetArticleDetail);
  });

  tearDown(() => cubit.close());

  group('ArticleDetailCubit.loadArticle', () {
    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'should_emit_Loading_then_Loaded_when_use_case_succeeds',
      build: () {
        when(() => mockGetArticleDetail('art_1'))
            .thenAnswer((_) async => DataSuccess(article));
        return cubit;
      },
      act: (c) => c.loadArticle('art_1'),
      expect: () => [
        isA<ArticleDetailLoading>(),
        isA<ArticleDetailLoaded>(),
      ],
    );

    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'should_emit_Loading_then_Error_when_use_case_fails',
      build: () {
        when(() => mockGetArticleDetail('art_1'))
            .thenAnswer((_) async => DataFailed(Exception('not found')));
        return cubit;
      },
      act: (c) => c.loadArticle('art_1'),
      expect: () => [
        isA<ArticleDetailLoading>(),
        isA<ArticleDetailError>(),
      ],
    );
  });
}
