import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/features/articles/data/data_sources/article_remote_data_source.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/features/articles/domain/params/publish_article_params.dart';
import 'package:tortutip/features/articles/domain/repository/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource _dataSource;
  ArticleRepositoryImpl(this._dataSource);

  @override
  Future<DataState<List<ArticleEntity>>> getFeedArticles(
      List<String> categoryIds) async {
    try {
      final models = await _dataSource.getFeedArticles(categoryIds);
      return DataSuccess(models.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<ArticleEntity>> getArticleDetail(String articleId) async {
    try {
      final model = await _dataSource.getArticleDetail(articleId);
      return DataSuccess(model.toEntity());
    } on Exception catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<ArticleEntity>> publishArticle(
      PublishArticleParams params) async {
    try {
      final model = await _dataSource.publishArticle(params);
      return DataSuccess(model.toEntity());
    } on Exception catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<bool>> saveArticle(String userId, String articleId) async {
    try {
      await _dataSource.saveArticle(userId, articleId);
      return const DataSuccess(true);
    } on Exception catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<ArticleEntity>>> getUserArticles(String userId) async {
    try {
      final models = await _dataSource.getUserArticles(userId);
      return DataSuccess(models.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return DataFailed(e);
    }
  }
}
