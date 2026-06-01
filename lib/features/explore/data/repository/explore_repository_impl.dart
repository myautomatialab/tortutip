import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/features/explore/data/data_sources/explore_remote_data_source.dart';
import 'package:tortutip/features/explore/domain/repository/explore_repository.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreRemoteDataSource _dataSource;

  ExploreRepositoryImpl(this._dataSource);

  @override
  Future<DataState<List<ArticleEntity>>> getArticlesByCategory(
    String categoryId,
    int page,
    int pageSize,
  ) async {
    try {
      final models =
          await _dataSource.getArticlesByCategory(categoryId, page, pageSize);
      return DataSuccess(List<ArticleEntity>.from(models));
    } on Exception catch (e) {
      return DataFailed(e);
    } catch (e) {
      return DataFailed(Exception(e.toString()));
    }
  }
}
