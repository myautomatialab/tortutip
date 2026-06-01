import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tortutip/features/articles/data/models/article_model.dart';
import 'package:tortutip/features/categories/data/models/category_model.dart';
import 'package:tortutip/shared/user/data/models/user_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<ArticleModel>> searchArticles(String query, int limit);
  Future<List<CategoryModel>> searchCategories(String query);
  Future<List<UserModel>> searchCreators(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final FirebaseFirestore _firestore;

  // Unicode upper bound for prefix search in Firestore
  static const String _prefixSuffix = '';

  SearchRemoteDataSourceImpl(this._firestore);

  @override
  Future<List<ArticleModel>> searchArticles(String query, int limit) async {
    final snapshot = await _firestore
        .collection('articles')
        .where('status', isEqualTo: 'published')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThan: query + _prefixSuffix)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return ArticleModel.fromRawData(data);
    }).toList();
  }

  @override
  Future<List<CategoryModel>> searchCategories(String query) async {
    final snapshot = await _firestore
        .collection('categories')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + _prefixSuffix)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return CategoryModel.fromRawData(data);
    }).toList();
  }

  @override
  Future<List<UserModel>> searchCreators(String query) async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'writer')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + _prefixSuffix)
        .limit(10)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return UserModel.fromRawData(data);
    }).toList();
  }
}
