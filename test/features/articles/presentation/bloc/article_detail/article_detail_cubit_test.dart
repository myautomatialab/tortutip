import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortutip/core/resources/data_state.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/features/articles/domain/use_cases/get_article_detail_use_case.dart';
import 'package:tortutip/features/articles/domain/use_cases/get_related_articles_use_case.dart';
import 'package:tortutip/features/articles/domain/use_cases/get_saved_article_ids_use_case.dart';
import 'package:tortutip/features/articles/domain/use_cases/save_article_use_case.dart';
import 'package:tortutip/features/articles/domain/use_cases/unsave_article_use_case.dart';
import 'package:tortutip/features/articles/presentation/bloc/article_detail/article_detail_cubit.dart';
import 'package:tortutip/features/articles/presentation/bloc/article_detail/article_detail_state.dart';
import 'package:tortutip/shared/user/domain/entities/user_entity.dart';
import 'package:tortutip/shared/user/domain/use_cases/get_user_by_id_use_case.dart';

class MockGetArticleDetailUseCase extends Mock
    implements GetArticleDetailUseCase {}

class MockGetRelatedArticlesUseCase extends Mock
    implements GetRelatedArticlesUseCase {}

class MockSaveArticleUseCase extends Mock implements SaveArticleUseCase {}

class MockUnsaveArticleUseCase extends Mock implements UnsaveArticleUseCase {}

class MockGetUserByIdUseCase extends Mock implements GetUserByIdUseCase {}

class MockGetSavedArticleIdsUseCase extends Mock
    implements GetSavedArticleIdsUseCase {}

void main() {
  late ArticleDetailCubit cubit;
  late MockGetArticleDetailUseCase mockGetArticleDetail;
  late MockGetRelatedArticlesUseCase mockGetRelatedArticles;
  late MockSaveArticleUseCase mockSaveArticle;
  late MockUnsaveArticleUseCase mockUnsaveArticle;
  late MockGetUserByIdUseCase mockGetUserById;
  late MockGetSavedArticleIdsUseCase mockGetSavedArticleIds;

  final article = ArticleEntity(
    id: 'art_1',
    authorId: 'user_1',
    categoryId: 'cat_1',
    title: 'Title',
    body: 'Body',
    coverVerticalUrl: '',
    coverHorizontalUrl: '',
    status: 'published',
    readTimeMinutes: 3,
    saveCount: 0,
    createdAt: DateTime(2024),
  );

  final author = UserEntity(
    id: 'user_1',
    name: 'Author',
    email: 'author@test.com',
    avatarUrl: '',
    bio: 'Bio',
    role: 'writer',
    gender: '',
    ageRange: '',
    createdAt: DateTime(2024),
  );

  final relatedArticles = <ArticleEntity>[];

  setUp(() {
    mockGetArticleDetail = MockGetArticleDetailUseCase();
    mockGetRelatedArticles = MockGetRelatedArticlesUseCase();
    mockSaveArticle = MockSaveArticleUseCase();
    mockUnsaveArticle = MockUnsaveArticleUseCase();
    mockGetUserById = MockGetUserByIdUseCase();
    mockGetSavedArticleIds = MockGetSavedArticleIdsUseCase();

    registerFallbackValue(
        const GetRelatedArticlesParams(categoryId: 'c', excludeArticleId: 'e'));
    registerFallbackValue(
        const GetSavedArticleIdsParams(userId: 'u'));
    registerFallbackValue(
        const GetUserByIdParams(userId: 'u'));
    registerFallbackValue(
        const SaveArticleParams(userId: 'u', articleId: 'a'));
    registerFallbackValue(
        const UnsaveArticleParams(userId: 'u', articleId: 'a'));

    cubit = ArticleDetailCubit(
      mockGetArticleDetail,
      mockGetRelatedArticles,
      mockSaveArticle,
      mockUnsaveArticle,
      mockGetUserById,
      mockGetSavedArticleIds,
    );
  });

  tearDown(() => cubit.close());

  void stubHappyPath({bool articleInSaved = false}) {
    when(() => mockGetArticleDetail('art_1'))
        .thenAnswer((_) async => DataSuccess(article));
    when(() => mockGetUserById(const GetUserByIdParams(userId: 'user_1')))
        .thenAnswer((_) async => DataSuccess(author));
    when(() => mockGetSavedArticleIds(any()))
        .thenAnswer((_) async => DataSuccess(
            articleInSaved ? ['art_1'] : <String>[]));
    when(() => mockGetRelatedArticles(any()))
        .thenAnswer((_) async => DataSuccess(relatedArticles));
  }

  group('ArticleDetailCubit.loadArticle', () {
    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'should_emit_Loading_then_Loaded_when_use_case_succeeds',
      build: () {
        stubHappyPath();
        return cubit;
      },
      act: (c) => c.loadArticle('art_1', 'current_user'),
      expect: () => [
        isA<ArticleDetailLoading>(),
        isA<ArticleDetailLoaded>(),
      ],
    );

    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'should_emit_Loading_then_Error_when_getArticleDetail_fails',
      build: () {
        when(() => mockGetArticleDetail('art_1'))
            .thenAnswer((_) async => DataFailed(Exception('not found')));
        return cubit;
      },
      act: (c) => c.loadArticle('art_1', 'current_user'),
      expect: () => [
        isA<ArticleDetailLoading>(),
        isA<ArticleDetailError>(),
      ],
    );

    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'should_emit_Loaded_with_isSaved_true_when_article_is_in_saved_ids',
      build: () {
        stubHappyPath(articleInSaved: true);
        return cubit;
      },
      act: (c) => c.loadArticle('art_1', 'current_user'),
      expect: () => [
        isA<ArticleDetailLoading>(),
        isA<ArticleDetailLoaded>().having((s) => s.isSaved, 'isSaved', isTrue),
      ],
    );

    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'should_emit_Loaded_with_isSaved_false_when_article_not_in_saved_ids',
      build: () {
        stubHappyPath(articleInSaved: false);
        return cubit;
      },
      act: (c) => c.loadArticle('art_1', 'current_user'),
      expect: () => [
        isA<ArticleDetailLoading>(),
        isA<ArticleDetailLoaded>().having((s) => s.isSaved, 'isSaved', isFalse),
      ],
    );

    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'should_emit_Loaded_with_relatedArticles_when_getRelatedArticles_succeeds',
      build: () {
        stubHappyPath();
        return cubit;
      },
      act: (c) => c.loadArticle('art_1', 'current_user'),
      expect: () => [
        isA<ArticleDetailLoading>(),
        isA<ArticleDetailLoaded>()
            .having((s) => s.relatedArticles, 'relatedArticles', isEmpty),
      ],
    );

    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'should_emit_Loaded_with_empty_relatedArticles_when_getRelatedArticles_fails',
      build: () {
        when(() => mockGetArticleDetail('art_1'))
            .thenAnswer((_) async => DataSuccess(article));
        when(() => mockGetUserById(const GetUserByIdParams(userId: 'user_1')))
            .thenAnswer((_) async => DataSuccess(author));
        when(() => mockGetSavedArticleIds(any()))
            .thenAnswer((_) async => DataSuccess(<String>[]));
        when(() => mockGetRelatedArticles(any()))
            .thenAnswer((_) async => DataFailed(Exception('error')));
        return cubit;
      },
      act: (c) => c.loadArticle('art_1', 'current_user'),
      expect: () => [
        isA<ArticleDetailLoading>(),
        isA<ArticleDetailLoaded>()
            .having((s) => s.relatedArticles, 'relatedArticles', isEmpty),
      ],
    );

    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'should_emit_Error_when_getUserById_fails',
      build: () {
        when(() => mockGetArticleDetail('art_1'))
            .thenAnswer((_) async => DataSuccess(article));
        when(() => mockGetUserById(const GetUserByIdParams(userId: 'user_1')))
            .thenAnswer((_) async => DataFailed(Exception('user not found')));
        when(() => mockGetSavedArticleIds(any()))
            .thenAnswer((_) async => DataSuccess(<String>[]));
        when(() => mockGetRelatedArticles(any()))
            .thenAnswer((_) async => DataSuccess(relatedArticles));
        return cubit;
      },
      act: (c) => c.loadArticle('art_1', 'current_user'),
      expect: () => [
        isA<ArticleDetailLoading>(),
        isA<ArticleDetailError>(),
      ],
    );
  });

  group('ArticleDetailCubit.toggleSave', () {
    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'should_optimistically_toggle_isSaved_to_true_when_toggleSave_called_and_was_false',
      build: () {
        stubHappyPath(articleInSaved: false);
        when(() => mockSaveArticle(any()))
            .thenAnswer((_) async => const DataSuccess(true));
        return cubit;
      },
      act: (c) async {
        await c.loadArticle('art_1', 'current_user');
        await c.toggleSave('current_user');
      },
      expect: () => [
        isA<ArticleDetailLoading>(),
        isA<ArticleDetailLoaded>().having((s) => s.isSaved, 'isSaved', isFalse),
        isA<ArticleDetailLoaded>().having((s) => s.isSaved, 'isSaved', isTrue),
      ],
    );

    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'should_optimistically_toggle_isSaved_to_false_when_toggleSave_called_and_was_true',
      build: () {
        stubHappyPath(articleInSaved: true);
        when(() => mockUnsaveArticle(any()))
            .thenAnswer((_) async => const DataSuccess(true));
        return cubit;
      },
      act: (c) async {
        await c.loadArticle('art_1', 'current_user');
        await c.toggleSave('current_user');
      },
      expect: () => [
        isA<ArticleDetailLoading>(),
        isA<ArticleDetailLoaded>().having((s) => s.isSaved, 'isSaved', isTrue),
        isA<ArticleDetailLoaded>().having((s) => s.isSaved, 'isSaved', isFalse),
      ],
    );

    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'should_revert_isSaved_when_saveArticle_fails',
      build: () {
        stubHappyPath(articleInSaved: false);
        when(() => mockSaveArticle(any()))
            .thenAnswer((_) async => DataFailed(Exception('save failed')));
        return cubit;
      },
      act: (c) async {
        await c.loadArticle('art_1', 'current_user');
        await c.toggleSave('current_user');
      },
      expect: () => [
        isA<ArticleDetailLoading>(),
        // After load: isSaved false
        isA<ArticleDetailLoaded>().having((s) => s.isSaved, 'isSaved', isFalse),
        // Optimistic update: isSaved true
        isA<ArticleDetailLoaded>().having((s) => s.isSaved, 'isSaved', isTrue),
        // Revert: isSaved false
        isA<ArticleDetailLoaded>().having((s) => s.isSaved, 'isSaved', isFalse),
      ],
    );

    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'should_revert_isSaved_when_unsaveArticle_fails',
      build: () {
        stubHappyPath(articleInSaved: true);
        when(() => mockUnsaveArticle(any()))
            .thenAnswer((_) async => DataFailed(Exception('unsave failed')));
        return cubit;
      },
      act: (c) async {
        await c.loadArticle('art_1', 'current_user');
        await c.toggleSave('current_user');
      },
      expect: () => [
        isA<ArticleDetailLoading>(),
        // After load: isSaved true
        isA<ArticleDetailLoaded>().having((s) => s.isSaved, 'isSaved', isTrue),
        // Optimistic update: isSaved false
        isA<ArticleDetailLoaded>().having((s) => s.isSaved, 'isSaved', isFalse),
        // Revert: isSaved true
        isA<ArticleDetailLoaded>().having((s) => s.isSaved, 'isSaved', isTrue),
      ],
    );
  });
}
