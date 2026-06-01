import 'package:equatable/equatable.dart';
import 'package:tortutip/features/categories/domain/entities/category_entity.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object> get props => [];
}

class ExploreInitial extends ExploreState {
  const ExploreInitial();
}

class ExploreLoading extends ExploreState {
  const ExploreLoading();
}

class ExploreLoaded extends ExploreState {
  final List<CategoryEntity> categories;
  final int streakDays;

  const ExploreLoaded({required this.categories, required this.streakDays});

  @override
  List<Object> get props => [categories, streakDays];
}

class ExploreError extends ExploreState {
  final String message;

  const ExploreError(this.message);

  @override
  List<Object> get props => [message];
}
