import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/features/articles/domain/use_cases/get_article_detail_use_case.dart';
import 'article_detail_state.dart';

class ArticleDetailCubit extends Cubit<ArticleDetailState> {
  final GetArticleDetailUseCase _getArticleDetail;
  ArticleDetailCubit(this._getArticleDetail) : super(ArticleDetailInitial());

  Future<void> loadArticle(String articleId) async {
    emit(ArticleDetailLoading());
    final result = await _getArticleDetail(articleId);
    if (result.data != null) {
      emit(ArticleDetailLoaded(result.data!));
    } else {
      emit(ArticleDetailError(result.error.toString()));
    }
  }
}
