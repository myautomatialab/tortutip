---
name: token-mappings
description: Resolved hardcoded value → design token mappings for TortuTip, including new tokens added during fix sessions
metadata:
  type: project
---

## Color Mappings Resolved

- `Colors.transparent` → `AppColors.transparent` (already existed: `Color(0x00000000)`)
- `Colors.black.withValues(alpha: 0.08)` → `AppColors.shadowLight` (added: `Color(0x14000000)`)

## New Tokens Added

### AppColors (lib/config/theme/app_colors.dart)
- `static const shadowLight = Color(0x14000000);` — 8% black overlay, used for card shadows

### AppSpacing (lib/config/theme/app_spacing.dart)
- `static const double thumbnailSm = 60.0;` — 60x60 thumbnail size for article rows
- `static const double dragHandleWidth = 40.0;` — modal drag handle bar width
- `static const double floatingTabBarClearance = 100.0;` — bottom clearance for floating tab bar (tabBarHeight 76 + padding 24)

### AppTypography (lib/config/theme/app_typography.dart)
- `static const TextStyle brand` — fontSize 20, w800, AppColors.primary, height 1.3 — replaces `AppTypography.h2.copyWith(fontWeight: FontWeight.w800)` in TortuAppBar.main()

## Architecture Fix Patterns

- `ProfileRemoteDataSource` abstract class should NOT expose `ArticleModel` in method signatures — use `Map<String, dynamic>` in abstract, call `ArticleModel.fromRawData()` in `ProfileRepositoryImpl`
- Cubits must use `registerFactory()` in injection, never `registerLazySingleton()`
- Presentation Blocs/Cubits must NOT import `cloud_firestore` — `_mapErrorToMessage` should return a generic message without `FirebaseException` type checks

## Test Fix Patterns

- When adding a new UseCase arg to a Cubit, the test needs: mock class, `setUp` initialization, `when()` stub, and updated constructor call
- `registerFallbackValue` for `NoParams` must go in `setUpAll()`, not `setUp()` — the `when()` stub for `GetAllCategoriesUseCase(any())` requires the fallback to already be registered
- All `registerFallbackValue` calls should be in `setUpAll()` to avoid ordering issues with `when()` stubs
