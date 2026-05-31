import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/features/articles/domain/use_cases/get_feed_articles_use_case.dart';
import 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  final GetFeedArticlesUseCase _getFeedArticles;
  FeedCubit(this._getFeedArticles) : super(const FeedInitial());

  Future<void> loadFeed(List<String> categoryIds) async {
    emit(const FeedLoading());
    final result = await _getFeedArticles(categoryIds);
    if (result.isSuccess) {
      emit(FeedLoaded(result.data!));
    } else {
      emit(FeedError(_mapErrorToMessage(result.error!)));
    }
  }

  String _mapErrorToMessage(Exception error) {
    if (error is FirebaseException) {
      return switch (error.code) {
        'permission-denied' => 'No tienes permiso para realizar esta acción',
        'not-found'         => 'El contenido no existe',
        'unavailable'       => 'Sin conexión. Inténtalo de nuevo',
        _                   => 'Algo salió mal. Inténtalo de nuevo',
      };
    }
    return 'Algo salió mal. Inténtalo de nuevo';
  }
}
