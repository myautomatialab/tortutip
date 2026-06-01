---
name: project-datasource-cross-layer-import
description: ExploreRemoteDataSource imports ArticleModel from articles/data — a recurring Rule 1/2 cross-feature data-layer import pattern to watch
metadata:
  type: project
---

`lib/features/explore/data/data_sources/explore_remote_data_source.dart` imports `ArticleModel` from `features/articles/data/models/article_model.dart`.

**Why:** The explore DataSource returns `List<ArticleEntity>` (using ArticleModel internally for deserialization), but importing a model from another feature's `data/` layer violates the principle that each feature's data layer is self-contained.

**How to apply:** When auditing Rule 2, check cross-feature imports inside `data/` directories — not just data→presentation imports. The fix is for ExploreRemoteDataSource to either use its own ArticleModel or depend only on the shared entity from `domain/`.
