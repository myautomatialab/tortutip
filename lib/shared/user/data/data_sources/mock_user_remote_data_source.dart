import 'package:tortutip/shared/user/data/data_sources/user_remote_data_source.dart';
import 'package:tortutip/shared/user/data/models/user_model.dart';

class MockUserRemoteDataSource implements UserRemoteDataSource {
  static final UserModel _mockUser = UserModel(
    id: 'mock_user_001',
    name: 'Usuario Mock',
    email: 'mock@tortutip.com',
    avatarUrl: '',
    bio: '',
    role: 'reader',
    gender: '',
    ageRange: '',
    createdAt: DateTime(2024, 1, 1),
  );

  static const List<String> _mockCategoryIds = [
    'mock_cat_mindfulness',
    'mock_cat_nutrition',
    'mock_cat_movement',
    'mock_cat_sleep',
  ];

  @override
  Future<UserModel> getCurrentUser() async => _mockUser;

  @override
  Future<void> updateUserRole(String userId, String role) async =>
      Future.value();

  @override
  Future<void> selectUserCategories(
    String userId,
    List<String> categoryIds,
  ) async =>
      Future.value();

  @override
  Future<UserModel> updateUserProfile(UserModel user) async => user;

  @override
  Future<List<String>> getUserCategoryIds(String userId) async =>
      _mockCategoryIds;

  @override
  Future<UserModel> getUserById(String userId) async {
    return UserModel(
      id: userId,
      name: 'Autor Mock',
      email: '$userId@tortutip.com',
      avatarUrl: 'https://i.pravatar.cc/150?u=$userId',
      bio: 'Escritor apasionado por el bienestar y la salud.',
      role: 'writer',
      gender: '',
      ageRange: '',
      createdAt: DateTime(2024, 1, 1),
    );
  }
}
