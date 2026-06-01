import 'package:tortutip/shared/user/domain/entities/user_entity.dart';

class HardcoreDataFixtures {
  HardcoreDataFixtures._();

  static final UserEntity hardcoreUser = UserEntity(
    id: 'hardcore_001',
    name: 'Alex Hardcore',
    email: 'hardcore@tortutip.dev',
    avatarUrl: 'https://i.pravatar.cc/150?u=hardcore_001',
    bio: 'Apasionado del bienestar. Modo Hardcore activado.',
    role: 'writer',
    gender: 'male',
    ageRange: '25-34',
    createdAt: DateTime(2024, 1, 1),
    streakDays: 5,
    overallProgress: 0.62,
    lastFeedDate: '',
  );
}
