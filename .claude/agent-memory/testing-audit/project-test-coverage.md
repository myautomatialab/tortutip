---
name: project-test-coverage
description: Current test coverage state for TortuTip — all 23 mandatory files present, 178 passing / 0 failed as of 2026-06-01 (branch feature/tortu-feed)
metadata:
  type: project
---

As of 2026-06-01 (branch: feature/tortu-feed), all 23 mandatory test files are present. 193 tests pass, 1 errored (compilation failure in a non-mandatory extra test file).

`flutter analyze lib/` — No issues found
`flutter test` — 193 passed, 0 failed, 1 errored (compilation failure)

**Active failures:**
- `test/features/search/domain/use_cases/search_articles_use_case_test.dart` — Compilation error: Too many positional arguments: 1 allowed, but 2 found (at lines 27, 38, 48, 53). The test calls `mockRepository.searchArticles(params.query, params.limit)` but the repository interface only accepts 1 argument. This is a test/interface mismatch — the `SearchArticleRepository` signature changed to a single `SearchArticleParams` object but the test still passes two positional args. NOT a mandatory file per checklist.

**Pattern to watch:** Every time a Cubit gains a new UseCase dependency, its test constructor call must be updated in sync. This has been the most common source of test breakage in this project.

**update_article_use_case added on feature/tortu-feed:** Covered by `test/features/articles/domain/use_cases/update_article_use_case_test.dart`. CreateArticleCubit now has edit-mode tests (`should_emit_publishing_then_published_when_update_succeeds`, `should_emit_error_when_update_fails`).

**CategoryListEmpty — new state added on feature/tortu-feed:** Immediately covered in `category_list_cubit_test.dart` under `should_emit_loading_then_empty_when_articles_list_is_empty`.

**Extra test files present beyond mandatory 23 (all passing):**
- `test/features/profile/domain/use_cases/get_saved_articles_use_case_test.dart`
- `test/features/profile/domain/use_cases/get_published_articles_use_case_test.dart`
- `test/features/profile/domain/use_cases/delete_article_use_case_test.dart`
- `test/features/auth/domain/use_cases/enter_hardcore_mode_use_case_test.dart`
- `test/features/auth/data/repository/hardcore_auth_repository_impl_test.dart`
- `test/features/explore/domain/use_cases/get_articles_by_category_use_case_test.dart`
- `test/features/explore/presentation/bloc/explore_cubit_test.dart`
- `test/features/explore/presentation/bloc/category_list_cubit_test.dart`
- `test/features/bookmarks/presentation/bloc/bookmarks_cubit_test.dart`
- `test/features/profile/presentation/bloc/edit_profile_cubit_test.dart`
- `test/features/tortu_feed/domain/use_cases/` — multiple use case tests
- `test/shared/user/domain/use_cases/get_user_category_ids_use_case_test.dart`
- `test/shared/user/domain/use_cases/get_user_by_id_use_case_test.dart`
- `test/shared/user/domain/use_cases/record_feed_swipe_use_case_test.dart`
- `test/features/articles/domain/use_cases/get_feed_articles_paged_use_case_test.dart`
- `test/features/articles/domain/use_cases/unsave_article_use_case_test.dart`
- `test/features/articles/domain/use_cases/update_article_use_case_test.dart`

**Coverage (mandatory 23):**
- Use Cases: 12/12
- Blocs/Cubits: 7/7
- Repository Implementations: 4/4
