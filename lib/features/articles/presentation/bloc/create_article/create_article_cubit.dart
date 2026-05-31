import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/features/articles/domain/params/publish_article_params.dart';
import 'package:tortutip/features/articles/domain/use_cases/publish_article_use_case.dart';
import 'create_article_state.dart';

class CreateArticleCubit extends Cubit<CreateArticleState> {
  final PublishArticleUseCase _publishArticle;
  CreateArticleCubit(this._publishArticle) : super(const CreateArticleInitial());

  Future<void> publish(PublishArticleParams params) async {
    emit(const CreateArticleLoading());
    final result = await _publishArticle(params);
    if (result.isSuccess) {
      emit(CreateArticleSuccess(result.data!));
    } else {
      emit(CreateArticleError(_mapErrorToMessage(result.error!)));
    }
  }

  String _mapErrorToMessage(Exception error) {
    if (error is FirebaseException) {
      return switch (error.code) {
        'permission-denied' => 'No tienes permiso para publicar artículos',
        'unavailable'       => 'Sin conexión. Inténtalo de nuevo',
        _                   => 'No se pudo publicar el artículo. Inténtalo de nuevo',
      };
    }
    return 'No se pudo publicar el artículo. Inténtalo de nuevo';
  }
}
