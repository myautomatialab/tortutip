---
name: project-feedcubit-singleton
description: FeedCubit was temporarily changed to registerLazySingleton but has since been corrected back to registerFactory — no longer an active violation as of 2026-06-01
metadata:
  type: project
---

FeedCubit is registered with `registerFactory` in `lib/injection/articles_injection.dart` (line 63) as of 2026-06-01 audit.

**Why this memory exists:** There was a prior period where FeedCubit used `registerLazySingleton` so AppShell could call `refresh()` after returning from CreateArticleScreen. This was a known Rule 5 violation.

**Current state:** The violation has been corrected. FeedCubit uses `registerFactory`. If a refresh-after-publish flow is needed, it must be implemented without re-introducing the singleton.

**How to apply:** When auditing Rule 5 in `articles_injection.dart`, FeedCubit is now compliant. Do not flag it as a violation unless it reverts to `registerLazySingleton`.

See also: [[feedback-datastate-signout]]
