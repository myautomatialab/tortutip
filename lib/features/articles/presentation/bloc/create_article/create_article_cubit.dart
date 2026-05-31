import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/features/articles/domain/params/publish_article_params.dart';
import 'package:tortutip/features/articles/domain/use_cases/publish_article_use_case.dart';
import 'create_article_state.dart';

class CreateArticleCubit extends Cubit<CreateArticleState> {
  final PublishArticleUseCase _publishArticle;
  CreateArticleCubit(this._publishArticle) : super(CreateArticleInitial());

  Future<void> publish(PublishArticleParams params) async {
    emit(CreateArticleLoading());
    final result = await _publishArticle(params);
    if (result.data != null) {
      emit(CreateArticleSuccess(result.data!));
    } else {
      emit(CreateArticleError(result.error.toString()));
    }
  }
}
