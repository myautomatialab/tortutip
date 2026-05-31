// UNICO lugar donde se importa Firebase Auth y Google Sign-In
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tortutip/shared/user/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> checkCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._auth, this._googleSignIn, this._firestore);

  @override
  Future<UserModel> signInWithGoogle() async {
    // google_sign_in 7.x: authenticate() reemplaza a signIn()
    final googleUser = await _googleSignIn.authenticate();
    final idToken = googleUser.authentication.idToken;

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user!;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      await _firestore.collection('users').doc(user.uid).set({
        'id': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'avatar_url': user.photoURL ?? '',
        'bio': '',
        'role': 'reader',
        'gender': '',
        'age_range': '',
        'created_at': DateTime.now().toIso8601String(),
      });
    }
    final fresh = await _firestore.collection('users').doc(user.uid).get();
    return UserModel.fromRawData({'id': user.uid, ...?fresh.data()});
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Future<UserModel?> checkCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;
    return UserModel.fromRawData({'id': user.uid, ...?doc.data()});
  }
}
