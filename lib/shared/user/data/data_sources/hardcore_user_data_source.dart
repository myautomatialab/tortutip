import 'package:tortutip/features/auth/hardcore/hardcore_data_fixtures.dart';
import 'package:tortutip/shared/user/data/data_sources/user_remote_data_source.dart';
import 'package:tortutip/shared/user/data/models/user_model.dart';

class HardcoreUserDataSource implements UserRemoteDataSource {
  UserModel _currentUser = _toModel(HardcoreDataFixtures.hardcoreUser);

  static UserModel _toModel(dynamic entity) => UserModel(
        id: entity.id,
        name: entity.name,
        email: entity.email,
        avatarUrl: entity.avatarUrl,
        bio: entity.bio,
        role: entity.role,
        gender: entity.gender,
        ageRange: entity.ageRange,
        createdAt: entity.createdAt,
        streakDays: entity.streakDays,
        lastFeedDate: entity.lastFeedDate,
        overallProgress: entity.overallProgress,
      );

  @override
  Future<UserModel> getCurrentUser() async => _currentUser;

  @override
  Future<void> updateUserRole(String userId, String role) async {
    _currentUser = UserModel(
      id: _currentUser.id,
      name: _currentUser.name,
      email: _currentUser.email,
      avatarUrl: _currentUser.avatarUrl,
      bio: _currentUser.bio,
      role: role,
      gender: _currentUser.gender,
      ageRange: _currentUser.ageRange,
      createdAt: _currentUser.createdAt,
      streakDays: _currentUser.streakDays,
      lastFeedDate: _currentUser.lastFeedDate,
      overallProgress: _currentUser.overallProgress,
    );
  }

  @override
  Future<void> selectUserCategories(
    String userId,
    List<String> categoryIds,
  ) async {
    // In-memory: no-op for hardcore mode
  }

  @override
  Future<UserModel> updateUserProfile(UserModel user) async {
    _currentUser = user;
    return _currentUser;
  }

  @override
  Future<List<String>> getUserCategoryIds(String userId) async => [
        'mock_cat_mindfulness',
        'mock_cat_nutrition',
        'mock_cat_movement',
        'mock_cat_sleep',
      ];

  @override
  Future<UserModel> getUserById(String userId) async => _currentUser;

  @override
  Future<UserModel> recordFeedSwipe(String userId) async {
    final now = DateTime.now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    if (_currentUser.lastFeedDate == today) return _currentUser;

    _currentUser = UserModel(
      id: _currentUser.id,
      name: _currentUser.name,
      email: _currentUser.email,
      avatarUrl: _currentUser.avatarUrl,
      bio: _currentUser.bio,
      role: _currentUser.role,
      gender: _currentUser.gender,
      ageRange: _currentUser.ageRange,
      createdAt: _currentUser.createdAt,
      streakDays: _currentUser.streakDays + 1,
      lastFeedDate: today,
      overallProgress: (_currentUser.overallProgress + 0.01).clamp(0.0, 1.0),
    );
    return _currentUser;
  }
}
