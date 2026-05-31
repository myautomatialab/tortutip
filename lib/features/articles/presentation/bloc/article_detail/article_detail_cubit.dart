import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/features/articles/domain/use_cases/get_article_detail_use_case.dart';
import 'article_detail_state.dart';

class ArticleDetailCubit extends Cubit<ArticleDetailState> {
  final GetArticleDetailUseCase _getArticleDetail;
  ArticleDetailCubit(this._getArticleDetail) : super(const ArticleDetailInitial());

  Future<void> loadArticle(String articleId) async {
    emit(const ArticleDetailLoading());
    final result = await _getArticleDetail(articleId);
    if (result.isSuccess) {
      emit(ArticleDetailLoaded(result.data!));
    } else {
      emit(ArticleDetailError(_mapErrorToMessage(result.error!)));
    }
  }

  String _mapErrorToMessage(Exception error) {
    if (error is FirebaseException) {
      return switch (error.code) {
        'permission-denied' => 'No tienes permiso para ver este artículo',
        'not-found'         => 'El artículo no existe',
        'unavailable'       => 'Sin conexión. Inténtalo de nuevo',
        _                   => 'Algo salió mal. Inténtalo de nuevo',
      };
    }
    return 'Algo salió mal. Inténtalo de nuevo';
  }
}
