import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/features/tortu_feed/domain/repository/tortu_feed_repository.dart';

class FeedTortuUseCase implements UseCase<DataState<void>, FeedTortuParams> {
  final TortuFeedRepository _repository;

  FeedTortuUseCase(this._repository);

  @override
  Future<DataState<void>> call(FeedTortuParams params) {
    return _repository.feedTortu(params);
  }
}
