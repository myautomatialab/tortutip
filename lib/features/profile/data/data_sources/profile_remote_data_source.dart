import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tortutip/features/articles/data/models/article_model.dart';

abstract class ProfileRemoteDataSource {
  Future<List<ArticleModel>> getSavedArticles(String userId, int limit);
  Future<List<ArticleModel>> getPublishedArticles(String authorId, int limit);
  Future<void> deleteArticle(String articleId, String userId);
  Future<String> uploadAvatar(File imageFile, String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProfileRemoteDataSourceImpl(this._firestore, this._storage);

  @override
  Future<List<ArticleModel>> getSavedArticles(
    String userId,
    int limit,
  ) async {
    final savedSnapshot = await _firestore
        .collection('saved_articles')
        .where('user_id', isEqualTo: userId)
        .orderBy('saved_at', descending: true)
        .limit(limit)
        .get();

    final articleIds = savedSnapshot.docs
        .map((doc) => doc.data()['article_id'] as String?)
        .where((id) => id != null)
        .cast<String>()
        .toList();

    if (articleIds.isEmpty) return [];

    final articleDocs = await Future.wait(
      articleIds.map(
        (id) => _firestore.collection('articles').doc(id).get(),
      ),
    );

    return articleDocs
        .where((doc) => doc.exists)
        .map((doc) {
          final data = doc.data()!;
          data['id'] = doc.id;
          return data;
        })
        .where((data) => data['status'] != 'deleted')
        .map((data) => ArticleModel.fromRawData(data))
        .toList();
  }

  @override
  Future<List<ArticleModel>> getPublishedArticles(
    String authorId,
    int limit,
  ) async {
    final snapshot = await _firestore
        .collection('articles')
        .where('author_id', isEqualTo: authorId)
        .where('status', isEqualTo: 'published')
        .orderBy('published_at', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return ArticleModel.fromRawData(data);
    }).toList();
  }

  @override
  Future<void> deleteArticle(String articleId, String userId) async {
    final doc =
        await _firestore.collection('articles').doc(articleId).get();

    if (!doc.exists) throw Exception('El artículo no existe');

    final authorId = doc.data()?['author_id'];
    if (authorId != userId) throw Exception('No autorizado');

    await _firestore
        .collection('articles')
        .doc(articleId)
        .update({'status': 'deleted'});
  }

  @override
  Future<String> uploadAvatar(File imageFile, String userId) async {
    final ref = _storage.ref('avatars/$userId.jpg');
    final bytes = await imageFile.readAsBytes();
    await ref.putData(
      bytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await ref.getDownloadURL();
  }
}
