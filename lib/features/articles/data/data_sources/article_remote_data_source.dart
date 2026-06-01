import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tortutip/features/articles/data/models/article_model.dart';
import 'package:tortutip/features/articles/domain/params/publish_article_params.dart';
import 'package:tortutip/features/articles/domain/params/upload_article_image_params.dart';

abstract class ArticleRemoteDataSource {
  Future<List<ArticleModel>> getFeedArticles(List<String> categoryIds);
  Future<ArticleModel> getArticleDetail(String articleId);
  Future<ArticleModel> publishArticle(PublishArticleParams params);
  Future<void> saveArticle(String userId, String articleId);
  Future<List<ArticleModel>> getUserArticles(String userId);
  Future<List<String>> getSavedArticleIds(String userId);
  Future<List<ArticleModel>> getFeedArticlesPaged(List<String> categoryIds, int page, int pageSize);
  Future<void> unsaveArticle(String userId, String articleId);
  Future<List<ArticleModel>> getRelatedArticles(String categoryId, String excludeArticleId);
  Future<String> uploadArticleImage(UploadArticleImageParams params);
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  final FirebaseFirestore _firestore;
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
      'read_time_minutes': params.readTimeMinutes,
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

  @override
  Future<List<String>> getSavedArticleIds(String userId) async {
    final snapshot = await _firestore
        .collection('saved_articles')
        .where('user_id', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => doc.data()['article_id'] as String)
        .toList();
  }

  @override
  Future<List<ArticleModel>> getFeedArticlesPaged(
      List<String> categoryIds, int page, int pageSize) async {
    final limit = (page + 1) * pageSize;
    final snapshot = await _firestore
        .collection('articles')
        .where('category_id', whereIn: categoryIds)
        .where('status', isEqualTo: 'published')
        .orderBy('published_at', descending: true)
        .limit(limit)
        .get();
    final all = snapshot.docs
        .map((doc) => ArticleModel.fromRawData({'id': doc.id, ...doc.data()}))
        .toList();
    final start = page * pageSize;
    if (start >= all.length) return [];
    return all.sublist(start);
  }

  @override
  Future<void> unsaveArticle(String userId, String articleId) async {
    await _firestore
        .collection('saved_articles')
        .doc('${userId}_$articleId')
        .delete();
  }

  @override
  Future<List<ArticleModel>> getRelatedArticles(
      String categoryId, String excludeArticleId) async {
    final snapshot = await _firestore
        .collection('articles')
        .where('category_id', isEqualTo: categoryId)
        .where('status', isEqualTo: 'published')
        .limit(6)
        .get();
    return snapshot.docs
        .map((doc) => ArticleModel.fromRawData({'id': doc.id, ...doc.data()}))
        .where((a) => a.id != excludeArticleId)
        .take(5)
        .toList();
  }

  @override
  Future<String> uploadArticleImage(UploadArticleImageParams params) async {
    final orientation = params.isVertical ? 'vertical' : 'horizontal';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage.ref(
      'articles/${params.userId}/${timestamp}_$orientation.jpg',
    );
    final task = await ref.putFile(params.imageFile);
    return task.ref.getDownloadURL();
  }
}
