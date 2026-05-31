import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tortutip/features/articles/data/models/article_model.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';

abstract class ExploreRemoteDataSource {
  Future<List<ArticleEntity>> getArticlesByCategory(
    String categoryId,
    int page,
    int pageSize,
  );
}

class ExploreRemoteDataSourceImpl implements ExploreRemoteDataSource {
  final FirebaseFirestore _firestore;

  ExploreRemoteDataSourceImpl(this._firestore);

  @override
  Future<List<ArticleEntity>> getArticlesByCategory(
    String categoryId,
    int page,
    int pageSize,
  ) async {
    final totalItems = (page + 1) * pageSize;

    final snapshot = await _firestore
        .collection('articles')
        .where('category_id', isEqualTo: categoryId)
        .where('status', isEqualTo: 'published')
        .orderBy('published_at', descending: true)
        .limit(totalItems)
        .get();

    final allModels = snapshot.docs
        .map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return ArticleModel.fromRawData(data);
        })
        .toList();

    final skipCount = page * pageSize;
    if (skipCount >= allModels.length) return [];
    return allModels.sublist(skipCount);
  }
}
