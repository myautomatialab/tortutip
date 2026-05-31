// UNICO lugar donde se importa Firestore para usuarios
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tortutip/shared/user/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getCurrentUser(String userId);
  Future<void> updateUserRole(String userId, String role);
  Future<void> selectUserCategories(String userId, List<String> categoryIds);
  Future<UserModel> updateUserProfile(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore _firestore;
  UserRemoteDataSourceImpl(this._firestore);

  @override
  Future<UserModel> getCurrentUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return UserModel.fromRawData({'id': doc.id, ...?doc.data()});
  }

  @override
  Future<void> updateUserRole(String userId, String role) async {
    await _firestore.collection('users').doc(userId).update({'role': role});
  }

  @override
  Future<void> selectUserCategories(String userId, List<String> categoryIds) async {
    final batch = _firestore.batch();
    final ref = _firestore.collection('user_categories');
    for (final id in categoryIds) {
      // ID compuesto = unique constraint: misma combinación siempre sobrescribe el mismo doc
      batch.set(ref.doc('${userId}_$id'), {'user_id': userId, 'category_id': id});
    }
    await batch.commit();
  }

  @override
  Future<UserModel> updateUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.id).update({
      'name': user.name,
      'bio': user.bio,
      'avatar_url': user.avatarUrl,
    });
    return user;
  }
}
