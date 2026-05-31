import 'dart:math';

import 'package:tortutip/features/articles/data/data_sources/mock_article_remote_data_source.dart';
import 'package:tortutip/features/articles/data/models/article_model.dart';
import 'package:tortutip/features/explore/data/data_sources/explore_remote_data_source.dart';

class MockExploreRemoteDataSource implements ExploreRemoteDataSource {
  final MockArticleRemoteDataSource _articleDataSource =
      MockArticleRemoteDataSource();

  @override
  Future<List<ArticleModel>> getArticlesByCategory(
    String categoryId,
    int page,
    int pageSize,
  ) async {
    final allForCategory = (await _articleDataSource.getFeedArticles([]))
        .where((a) => a.categoryId == categoryId)
        .toList();

    final start = page * pageSize;
    if (start >= allForCategory.length) return [];
    return allForCategory.sublist(
      start,
      min(start + pageSize, allForCategory.length),
    );
  }
}
