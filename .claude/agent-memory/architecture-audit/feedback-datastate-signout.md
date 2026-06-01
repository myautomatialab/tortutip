---
name: feedback-datastate-signout
description: AuthBloc._onSignOut discards DataState result without checking isSuccess/isFailure — recurring Rule 8 risk pattern in fire-and-forget use cases
metadata:
  type: feedback
---

In `auth_bloc.dart`, `_onSignOut` calls `await _signOut(const NoParams())` and discards the returned `DataState<bool>` without checking `result.isSuccess` or `result.isFailure`. This violates Rule 8.

**Why:** Fire-and-forget use cases that return `DataState` are easy to misuse this way. The pattern is subtle because sign-out "usually works" but a Firebase error would be silently swallowed.

**How to apply:** Any time a UseCase is awaited and its result is not assigned to a variable, flag it immediately as a Rule 8 violation. Even if the bloc emits a state unconditionally after, the result check is still required per CLAUDE.md.
