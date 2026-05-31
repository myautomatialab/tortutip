import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/features/articles/domain/params/publish_article_params.dart';

abstract class ArticleRepository {
  Future<DataState<List<ArticleEntity>>> getFeedArticles(List<String> categoryIds);
  Future<DataState<ArticleEntity>> getArticleDetail(String articleId);
  Future<DataState<ArticleEntity>> publishArticle(PublishArticleParams params);
  Future<DataState<bool>> saveArticle(String userId, String articleId);
  Future<DataState<List<ArticleEntity>>> getUserArticles(String userId);
  Future<DataState<List<String>>> getSavedArticleIds(String userId);
  Future<DataState<List<ArticleEntity>>> getFeedArticlesPaged(List<String> categoryIds, int page, int pageSize);
  Future<DataState<bool>> unsaveArticle(String userId, String articleId);
  Future<DataState<List<ArticleEntity>>> getRelatedArticles(String categoryId, String excludeArticleId);
}
