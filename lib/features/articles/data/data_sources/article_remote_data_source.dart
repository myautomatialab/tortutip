import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tortutip/features/articles/data/models/article_model.dart';
import 'package:tortutip/features/articles/domain/params/publish_article_params.dart';

abstract class ArticleRemoteDataSource {
  Future<List<ArticleModel>> getFeedArticles(List<String> categoryIds);
  Future<ArticleModel> getArticleDetail(String articleId);
  Future<ArticleModel> publishArticle(PublishArticleParams params);
  Future<void> saveArticle(String userId, String articleId);
  Future<List<ArticleModel>> getUserArticles(String userId);
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  final FirebaseFirestore _firestore;
  // ignore: unused_field
  final FirebaseStorage _storage;
  ArticleRemoteDataSourceImpl(this._firestore, this._storage);

  @override
  Future<List<ArticleModel>> getFeedArticles(List<String> categoryIds) async {
    final snapshot = await _firestore
        .collection('articles')
        .where('category_id', whereIn: categoryIds)
        .where('status', isEqualTo: 'published')
        .orderBy('published_at', descending: true)
        .get();
    return snapshot.docs
        .map((doc) =>
            ArticleModel.fromRawData({'id': doc.id, ...doc.data()}))
        .toList();
  }

  @override
  Future<ArticleModel> getArticleDetail(String articleId) async {
    final doc =
        await _firestore.collection('articles').doc(articleId).get();
    return ArticleModel.fromRawData({'id': doc.id, ...?doc.data()});
  }

  @override
  Future<ArticleModel> publishArticle(PublishArticleParams params) async {
    final now = DateTime.now().toIso8601String();
    final data = {
      'author_id': params.authorId,
      'category_id': params.categoryId,
      'title': params.title,
      'body': params.body,
      'cover_vertical_url': params.coverVerticalUrl,
      'cover_horizontal_url': params.coverHorizontalUrl,
      'status': 'published',
      'read_time_minutes': (params.body.split(' ').length / 200).ceil(),
      'save_count': 0,
      'published_at': now,
      'created_at': now,
    };
    final ref = await _firestore.collection('articles').add(data);
    return ArticleModel.fromRawData({'id': ref.id, ...data});
  }

  @override
  Future<void> saveArticle(String userId, String articleId) async {
    await _firestore.collection('saved_articles').add({
      'user_id': userId,
      'article_id': articleId,
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<List<ArticleModel>> getUserArticles(String userId) async {
    final snapshot = await _firestore
        .collection('articles')
        .where('author_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .get();
    return snapshot.docs
        .map((doc) =>
            ArticleModel.fromRawData({'id': doc.id, ...doc.data()}))
        .toList();
  }
}
