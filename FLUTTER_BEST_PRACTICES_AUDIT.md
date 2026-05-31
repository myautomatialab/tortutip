# Flutter Best Practices Audit — TortuTip

> Fuente de referencia: documentación oficial de Flutter, flutter_bloc, go_router y get_it consultada vía **Context7 MCP** (`/llmstxt/flutter_dev_llms_txt`, `/felangel/bloc`, `/websites/pub_dev_packages_go_router`, `/flutter-it/get_it`).
>
> Última actualización: **2026-05-31** — todos los problemas críticos corregidos.

---

## Resumen ejecutivo

| Área | Estado |
|---|---|
| Arquitectura de capas (domain / data / presentation) | ✅ Cumple |
| `DataState` — `isSuccess`, `isFailure`, `Equatable` | ✅ Corregido |
| `Equatable` en entidades | ✅ Corregido |
| `Equatable` en todos los estados de Blocs/Cubits | ✅ Corregido |
| `Equatable` en `NoParams` | ✅ Corregido |
| `Equatable` en Params de use cases | ✅ Corregido |
| Cubits usan `result.isSuccess` (no `data != null`) | ✅ Corregido |
| `_mapErrorToMessage` en cada Bloc/Cubit | ✅ Corregido |
| `const` en constructores de estados emitidos | ✅ Corregido |
| `StatelessWidget` preferido sobre `StatefulWidget` | ✅ Cumple |
| `super.key` / `super.param` en constructores | ✅ Cumple |
| get_it — `registerLazySingleton` / `registerFactory` correctos | ✅ Cumple |
| go_router — **ShellRoute único** | ✅ Corregido |
| Auth guard via `redirect` en `app_router.dart` | ✅ Cumple |
| Tokens de diseño (sin hardcoding de colores/tamaños) | ✅ Cumple |
| DataSources aislados (único punto de Firebase) | ✅ Cumple |
| Blocs solo importan use_cases | ✅ Cumple |
| `flutter analyze lib/` | ✅ Zero issues |

---

## Cambios aplicados

### Fase 1 — Infraestructura base

#### `lib/core/resources/data_state.dart`
Añadidos `extends Equatable`, getters `isSuccess` / `isFailure` y `props`.

```dart
// ANTES ❌
abstract class DataState<T> {
  final T? data;
  final Exception? error;
  const DataState({this.data, this.error});
}

// DESPUÉS ✅
abstract class DataState<T> extends Equatable {
  final T? data;
  final Exception? error;
  const DataState({this.data, this.error});

  bool get isSuccess => this is DataSuccess<T>;
  bool get isFailure => this is DataFailed<T>;

  @override
  List<Object?> get props => [data, error];
}
```

#### `lib/core/usecase/usecase.dart`
`NoParams` ahora extiende `Equatable`.

```dart
// ANTES ❌
class NoParams {}

// DESPUÉS ✅
class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}
```

#### Entidades
Todas extienden `Equatable` con `props` completos:
- `lib/features/articles/domain/entities/article_entity.dart`
- `lib/shared/user/domain/entities/user_entity.dart`
- `lib/features/categories/domain/entities/category_entity.dart`

---

### Fase 2 — Estados de Blocs/Cubits

Todos los estados corregidos con `extends Equatable`, constructores `const` y `props` en subclases con datos:

| Archivo | Estados |
|---|---|
| `auth_state.dart` | `AuthInitial`, `AuthLoading`, `AuthAuthenticated(user)`, `AuthError(message)` |
| `feed_state.dart` | `FeedInitial`, `FeedLoading`, `FeedLoaded(articles)`, `FeedError(message)` |
| `article_detail_state.dart` | `ArticleDetailInitial`, `ArticleDetailLoading`, `ArticleDetailLoaded(article)`, `ArticleDetailError(message)` |
| `create_article_state.dart` | `CreateArticleInitial`, `CreateArticleLoading`, `CreateArticleSuccess(article)`, `CreateArticleError(message)` |
| `category_state.dart` | `CategoryInitial`, `CategoryLoading`, `CategoryLoaded(categories)`, `CategoryError(message)` |
| `onboarding_state.dart` | `OnboardingInitial`, `OnboardingLoading`, `OnboardingRoleSelected(role)`, `OnboardingComplete`, `OnboardingError(message)` |
| `profile_state.dart` | `ProfileInitial`, `ProfileLoading`, `ProfileLoaded(user, articles)`, `ProfileError(message)` |

---

### Fase 3 — Params con Equatable

Todas las clases de parámetros de use cases extienden `Equatable`:

| Clase | Archivo |
|---|---|
| `PublishArticleParams` | `publish_article_params.dart` |
| `SaveArticleParams` | `save_article_use_case.dart` |
| `UpdateUserRoleParams` | `update_user_role_use_case.dart` |
| `SelectUserCategoriesParams` | `select_user_categories_use_case.dart` |

---

### Fase 4 — Lógica de Cubits

**Todos** los Cubits/Blocs ahora:
1. Usan `result.isSuccess` / `result.isFailure` en lugar de `result.data != null`
2. Tienen `_mapErrorToMessage(Exception)` propio con mensajes legibles para el usuario
3. Emiten estados con constructores `const`

```dart
// ANTES ❌
if (result.data != null) {
  emit(FeedLoaded(result.data!));
} else {
  emit(FeedError(result.error.toString())); // mensaje técnico
}

// DESPUÉS ✅
if (result.isSuccess) {
  emit(FeedLoaded(result.data!));
} else {
  emit(FeedError(_mapErrorToMessage(result.error!)));
}

String _mapErrorToMessage(Exception error) {
  if (error is FirebaseException) {
    return switch (error.code) {
      'permission-denied' => 'No tienes permiso para realizar esta acción',
      'not-found'         => 'El contenido no existe',
      'unavailable'       => 'Sin conexión. Inténtalo de nuevo',
      _                   => 'Algo salió mal. Inténtalo de nuevo',
    };
  }
  return 'Algo salió mal. Inténtalo de nuevo';
}
```

Archivos corregidos:
- `feed_cubit.dart`
- `article_detail_cubit.dart`
- `create_article_cubit.dart`
- `category_cubit.dart`
- `onboarding_cubit.dart`
- `profile_cubit.dart`
- `auth_bloc.dart`

---

### Fase 5 — ShellRoute único

**Problema:** `articles_routes.dart` y `profile_routes.dart` instanciaban cada uno su propio `ShellRoute(AppShell)`. Al navegar entre `/feed` y `/explore` con `context.go()`, `AppShell` se destruía y recreaba, perdiendo estado de scroll.

**Solución:** Un único `ShellRoute` en `app_router.dart`. Los feature routes exponen `shellRoutes` (dentro del shell) y `routes` (fuera del shell) por separado.

```dart
// app_router.dart ✅ — un único ShellRoute
ShellRoute(
  builder: (_, _, child) => AppShell(child: child),
  routes: [
    ...ArticlesRoutes.shellRoutes,   // /feed
    ...ProfileRoutes.shellRoutes,    // /explore
  ],
),
```

```dart
// articles_routes.dart ✅
class ArticlesRoutes {
  static final routes = <RouteBase>[
    GoRoute(path: AppRoutes.create, ...),  // fuera del shell
  ];
  static final shellRoutes = <RouteBase>[
    GoRoute(path: AppRoutes.feed, ...),    // dentro del shell
  ];
}
```

---

## Estado pendiente (fuera del alcance actual)

| Punto | Motivo |
|---|---|
| `BlocProvider` en screens | Las screens son stubs — se añadirá al implementar la UI real de cada pantalla |
| Tests unitarios | No existen aún — prerequisito: tener las clases con `Equatable` (ya cumplido) |

---

## Lo que el proyecto cumple correctamente

| Best practice | Fuente Context7 |
|---|---|
| `StatelessWidget` sobre `StatefulWidget` | Flutter perf guide |
| `super.key` y `super.param` en constructores | Flutter style guide |
| Un archivo = una clase pública principal | Flutter conventions |
| `registerLazySingleton` para DataSources/Repos/UseCases | get_it docs |
| `registerFactory` para Blocs/Cubits | get_it docs |
| DataSources son el único lugar con Firebase | Flutter arch guide |
| Blocs solo importan use_cases | flutter_bloc guide |
| Repository impl retorna `DataState<T>` | Clean arch |
| Repository interfaces son `abstract class` | Clean arch |
| `go_router` para navegación | Flutter arch guide |
| Auth guard en router via `redirect` | go_router docs |
| Tokens de diseño — `AppColors`, `AppSpacing`, `AppTypography` | Flutter style |
| Sistema de inyección con get_it | get_it docs |

---

*Generado el 2026-05-31 — Fuentes: Context7 MCP (`/llmstxt/flutter_dev_llms_txt`, `/felangel/bloc`, `/websites/pub_dev_packages_go_router`, `/flutter-it/get_it`)*
