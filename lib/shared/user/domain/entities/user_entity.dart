import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String bio;
  final String role; // 'reader' | 'writer'
  final String gender;
  final String ageRange;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.bio,
    required this.role,
    required this.gender,
    required this.ageRange,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatarUrl,
        bio,
        role,
        gender,
        ageRange,
        createdAt,
      ];
}
