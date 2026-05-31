import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/features/articles/data/data_sources/article_remote_data_source.dart';
import 'package:tortutip/features/articles/data/models/article_model.dart';
import 'package:tortutip/features/articles/data/repository/article_repository_impl.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/features/articles/domain/params/publish_article_params.dart';

class MockArticleRemoteDataSource extends Mock
    implements ArticleRemoteDataSource {}

void main() {
  late ArticleRepositoryImpl repository;
  late MockArticleRemoteDataSource mockDataSource;

  const params = PublishArticleParams(
    authorId: 'user_1',
    categoryId: 'cat_1',
    title: 'Title',
    body: 'Body',
    coverVerticalUrl: '',
    coverHorizontalUrl: '',
  );

  setUp(() {
    mockDataSource = MockArticleRemoteDataSource();
    repository = ArticleRepositoryImpl(mockDataSource);
    registerFallbackValue(params);
  });

  group('ArticleRepositoryImpl.getFeedArticles', () {
    test('should_return_DataSuccess_with_entities_when_datasource_succeeds',
        () async {
      when(() => mockDataSource.getFeedArticles(any()))
          .thenAnswer((_) async => <ArticleModel>[]);

      final result = await repository.getFeedArticles(['cat_1']);

      expect(result, isA<DataSuccess<List<ArticleEntity>>>());
    });

    test('should_return_DataFailed_when_datasource_throws', () async {
      when(() => mockDataSource.getFeedArticles(any()))
          .thenThrow(Exception('error'));

      final result = await repository.getFeedArticles(['cat_1']);

      expect(result, isA<DataFailed<List<ArticleEntity>>>());
    });
  });

  group('ArticleRepositoryImpl.getArticleDetail', () {
    test('should_return_DataFailed_when_datasource_throws', () async {
      when(() => mockDataSource.getArticleDetail(any()))
          .thenThrow(Exception('not found'));

      final result = await repository.getArticleDetail('art_1');

      expect(result, isA<DataFailed<ArticleEntity>>());
    });
  });

  group('ArticleRepositoryImpl.saveArticle', () {
    test('should_return_DataSuccess_when_datasource_succeeds', () async {
      when(() => mockDataSource.saveArticle(any(), any()))
          .thenAnswer((_) async {});

      final result = await repository.saveArticle('user_1', 'art_1');

      expect(result, isA<DataSuccess<bool>>());
    });

    test('should_return_DataFailed_when_datasource_throws', () async {
      when(() => mockDataSource.saveArticle(any(), any()))
          .thenThrow(Exception('error'));

      final result = await repository.saveArticle('user_1', 'art_1');

      expect(result, isA<DataFailed<bool>>());
    });
  });

  group('ArticleRepositoryImpl.getUserArticles', () {
    test('should_return_DataSuccess_with_entities_when_datasource_succeeds',
        () async {
      when(() => mockDataSource.getUserArticles(any()))
          .thenAnswer((_) async => <ArticleModel>[]);

      final result = await repository.getUserArticles('user_1');

      expect(result, isA<DataSuccess<List<ArticleEntity>>>());
    });

    test('should_return_DataFailed_when_datasource_throws', () async {
      when(() => mockDataSource.getUserArticles(any()))
          .thenThrow(Exception('error'));

      final result = await repository.getUserArticles('user_1');

      expect(result, isA<DataFailed<List<ArticleEntity>>>());
    });
  });
}
