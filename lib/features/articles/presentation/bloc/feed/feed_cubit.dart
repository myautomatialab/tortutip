import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/features/articles/domain/use_cases/get_feed_articles_use_case.dart';
import 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  final GetFeedArticlesUseCase _getFeedArticles;
  FeedCubit(this._getFeedArticles) : super(FeedInitial());

  Future<void> loadFeed(List<String> categoryIds) async {
    emit(FeedLoading());
    final result = await _getFeedArticles(categoryIds);
    if (result.data != null) {
      emit(FeedLoaded(result.data!));
    } else {
      emit(FeedError(result.error.toString()));
    }
  }
}
