import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/features/categories/domain/entities/category_entity.dart';
import 'package:tortutip/features/search/domain/params/search_articles_params.dart';
import 'package:tortutip/features/search/domain/use_cases/get_recent_searches_use_case.dart';
import 'package:tortutip/features/search/domain/use_cases/remove_recent_search_use_case.dart';
import 'package:tortutip/features/search/domain/use_cases/save_recent_search_use_case.dart';
import 'package:tortutip/features/search/domain/use_cases/search_articles_use_case.dart';
import 'package:tortutip/features/search/domain/use_cases/search_categories_use_case.dart';
import 'package:tortutip/features/search/domain/use_cases/search_creators_use_case.dart';
import 'package:tortutip/features/search/presentation/bloc/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchArticlesUseCase _searchArticles;
  final SearchCategoriesUseCase _searchCategories;
  final SearchCreatorsUseCase _searchCreators;
  final GetRecentSearchesUseCase _getRecentSearches;
  final SaveRecentSearchUseCase _saveRecentSearch;
  final RemoveRecentSearchUseCase _removeRecentSearch;

  Timer? _debounce;
  SearchInitial? _lastInitialState;

  SearchCubit(
    this._searchArticles,
    this._searchCategories,
    this._searchCreators,
    this._getRecentSearches,
    this._saveRecentSearch,
    this._removeRecentSearch,
  ) : super(const SearchInitial(recentSearches: [], categories: []));

  Future<void> loadInitial() async {
    final recentsResult = await _getRecentSearches(const NoParams());
    final categoriesResult = await _searchCategories('');

    final recentSearches =
        recentsResult.isSuccess ? recentsResult.data! : <String>[];
    final categories = categoriesResult.isSuccess
        ? categoriesResult.data!
        : <CategoryEntity>[];

    final initialState = SearchInitial(
      recentSearches: recentSearches,
      categories: categories,
    );
    _lastInitialState = initialState;
    emit(initialState);
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();

    if (query.isEmpty || query.length < 2) {
      emit(_lastInitialState ??
          const SearchInitial(recentSearches: [], categories: []));
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _fetchSuggestions(query);
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    final result = await _searchArticles(
        SearchArticlesParams(query: query, limit: 5));
    if (result.isSuccess) {
      final suggestions =
          result.data!.map((a) => a.title).take(5).toList();
      emit(SearchSuggesting(query: query, suggestions: suggestions));
    }
  }

  Future<void> search(String query) async {
    _debounce?.cancel();
    emit(SearchLoading(query: query));

    final articlesResult =
        await _searchArticles(SearchArticlesParams(query: query));
    final categoriesResult = await _searchCategories(query);
    final creatorsResult = await _searchCreators(query);

    final allFailed = articlesResult.isFailure &&
        categoriesResult.isFailure &&
        creatorsResult.isFailure;

    if (allFailed) {
      emit(SearchError(
          message: _mapErrorToMessage(articlesResult.error!)));
      return;
    }

    final articles =
        articlesResult.isSuccess ? articlesResult.data! : [];
    final categories =
        categoriesResult.isSuccess ? categoriesResult.data! : [];
    final creators =
        creatorsResult.isSuccess ? creatorsResult.data! : [];

    final hasResults =
        articles.isNotEmpty || categories.isNotEmpty || creators.isNotEmpty;

    if (!hasResults) {
      final suggested = _lastInitialState?.categories ?? [];
      emit(SearchEmpty(query: query, suggestedCategories: suggested));
    } else {
      emit(SearchLoaded(
        query: query,
        articles: List.from(articles),
        categories: List.from(categories),
        creators: List.from(creators),
        activeFilter: 'all',
        activeTab: 0,
      ));
    }

    // Fire-and-forget — save to recents
    _saveRecentSearch(query);
  }

  void setFilter(String categoryId) {
    final current = state;
    if (current is SearchLoaded) {
      emit(current.copyWith(activeFilter: categoryId));
    }
  }

  void setTab(int index) {
    final current = state;
    if (current is SearchLoaded) {
      emit(current.copyWith(activeTab: index));
    }
  }

  Future<void> removeRecent(String query) async {
    await _removeRecentSearch(query);

    final current = state;
    if (current is SearchInitial) {
      final updated = List<String>.from(current.recentSearches)
        ..remove(query);
      final newState = SearchInitial(
        recentSearches: updated,
        categories: current.categories,
      );
      _lastInitialState = newState;
      emit(newState);
    }
  }

  String _mapErrorToMessage(Exception error) {
    if (error is FirebaseException) {
      return switch (error.code) {
        'permission-denied' => 'No tienes permiso para realizar esta acción',
        'not-found' => 'El contenido no existe',
        'unavailable' => 'Sin conexión. Inténtalo de nuevo',
        _ => 'Algo salió mal. Inténtalo de nuevo',
      };
    }
    return 'Algo salió mal. Inténtalo de nuevo';
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
