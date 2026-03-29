# AI Skills

## Create a New Feature
### Goal
- Add a new feature without introducing patterns the repo does not use.

### When to Use
- A brand-new capability does not fit inside an existing feature.

### Workflow
1. Inspect the closest existing feature under `lib/features/user_app`, `lib/features/doctor_app`, `lib/features/auth`, or `lib/features/shared`.
2. Decide which case applies:
   - Case A: the nearest comparable feature already has `data` + Cubit + presentation
   - Case B: the nearest comparable feature is mostly View-only
3. Create the new feature folder with the same internal pattern already used nearby:
   - `data/models`
   - `data/repo` or `data/repos`
   - `presentation/view`, `presentation/views`, `presentation/view-model`, or `presentation/view_models`
4. Case A: follow that feature's shape exactly.
5. Case B: add only the layers required by the task:
   - static feature: presentation only
   - interactive or async feature: presentation + Cubit/state
   - network/storage feature: presentation + Cubit/state + data/repo
6. If the feature consumes API or local persistence, add models first, then repository contract, then repository implementation.
7. Add or update endpoints in `lib/core/Api_services/urls.dart` only if the feature introduces a new API path.
8. Register the repository in `lib/core/utils/services_locater.dart` if it should be resolved via `getit`.
9. Add a Cubit and state classes for screen-level state and actions.
10. Add screens plus supporting widgets/sections.
11. Add route registration in `lib/core/utils/routs.dart` only if the feature should be reachable by named route.
12. Add localization keys in both language files.
13. Add or update tests only for the logic you added.

### Expected File Changes
- New files inside one feature directory
- `lib/core/utils/services_locater.dart`
- `lib/core/utils/routs.dart` if routed
- `assets/lang/en.json`
- `assets/lang/ar.json`
- Tests when practical

### Validation Checklist
- The new feature uses the same folder naming style as its nearest sibling.
- If the feature has async or business flow, that logic is in a Cubit.
- If the feature has API or persistence work, that logic is in a repo/data layer.
- DI, route, URL, and localization files were updated only when needed.
- No new state management pattern or architecture layer was introduced.

## Add a New Screen Inside an Existing Feature
### Goal
- Add a screen without breaking the feature's current structure.

### When to Use
- A feature needs another page, flow step, dialog-backed screen, or detail view.

### Workflow
1. Inspect the feature's existing `presentation` structure.
2. Decide which case applies:
   - Case A: the feature already has a Cubit/state flow
   - Case B: the feature is currently screen-only or partially structured
3. Place the new screen beside related screens in `view` or `views`.
4. Reuse existing `widgets` and `sections` folders for screen parts.
5. Case A: extend the existing Cubit/state when the new screen belongs to the same flow.
6. Case B: if the screen is static, keep it as View-only; if it needs async state or business flow, add a Cubit for that screen/feature.
7. Add a static `routeName` only when the feature already uses named routes for similar screens.
8. Register the route in `lib/core/utils/routs.dart` only when globally navigable.
9. Add localization keys for titles, labels, errors, and actions.

### Expected File Changes
- One or more screen/widget files in the feature's `presentation` folder
- Cubit/state files if new state is needed
- `lib/core/utils/routs.dart` if route-based
- Localization JSON files

### Validation Checklist
- The screen does not call repositories or `ApiServices` directly.
- Navigation matches the style already used in that flow: named route or `MaterialPageRoute`.
- Strings are localized.
- The screen-specific UI is split into smaller widgets/sections when it gets large.
- If new state was needed, it was added through a Cubit, not through a large stateful screen.

## Add a New API Integration
### Goal
- Connect a feature to a new endpoint while preserving data-layer boundaries.

### When to Use
- A screen needs data from a new backend endpoint or automation webhook.

### Workflow
1. Inspect the target feature and decide which case applies:
   - Case A: the feature already has a repo
   - Case B: the feature has UI/Cubit only and no repo yet
2. Add or update endpoint constants in `lib/core/Api_services/urls.dart`.
3. Add/update request and response models in `data/models`.
4. Case A: extend the existing repository interface and implementation.
5. Case B: add a small repository contract + implementation rather than putting `ApiServices` in the Cubit or View.
6. Implement the call using `ApiServices`.
7. Parse responses defensively and return `Either<Failure, T>`.
8. Register the repository only if a new repo/service type is introduced.
9. Call the new repo method from the Cubit.
10. Update the View to react to Cubit state only.

### Expected File Changes
- Feature `data/models/*`
- Feature repository contract and implementation
- Cubit/state files
- `lib/core/utils/services_locater.dart` if DI changes

### Validation Checklist
- Widgets do not import `dio` or `ApiServices`.
- Cubits do not contain endpoint strings or response parsing that belongs in the repo.
- Errors are converted to `Failure`.
- Response parsing matches the real API shape.
- Loading, success, and error states are surfaced through the Cubit.

## Add a New Bloc/Cubit Flow in MVVM Style
### Goal
- Introduce or extend a Cubit-driven state flow that cleanly separates View and data logic.

### When to Use
- A screen needs new async actions, validation flow, multi-step UI state, or user interaction coordination.

### Workflow
1. Check whether the target feature already has a Cubit.
2. If the new behavior belongs to the existing screen flow, extend that Cubit; otherwise add a separate Cubit close to the new screen.
3. Use Cubit, not event-based Bloc. The repo currently uses Cubit patterns.
4. Follow the feature's existing state style:
   - subclass-based states such as `Loading`, `Success`, `Error`
   - one Equatable state object plus enum/status fields
5. Define explicit loading, success, error, and reset/selection behavior.
6. Keep Cubit dependencies limited to repositories, models, and core helpers.
7. Put flow validation and coordination in the Cubit when it affects behavior beyond a single widget.
8. Use `BlocBuilder`, `BlocConsumer`, or `BlocListener` in the View to react to state.
9. Keep ephemeral widget-only concerns local only when they are purely visual.

### Expected File Changes
- Cubit file
- State file or `part` state
- Related screen/widget files

### Validation Checklist
- State shape is explicit and typed.
- View only dispatches actions and renders state.
- Cubit does not import widget/rendering code.
- Async paths cover loading, success, and failure states.
- The Cubit is scoped to one feature flow, not turned into a generic app service.

## Fix a Bug
### Goal
- Resolve a defect with the smallest architecture-safe change.

### When to Use
- Existing behavior is incorrect, crashing, inconsistent, or regressed.

### Workflow
1. Reproduce and locate the bug in View, Cubit, repo, model mapping, or shared core code.
2. Inspect adjacent files for the established pattern before editing.
3. Decide whether the buggy area is:
   - already structured correctly
   - partially structured
   - legacy exception
4. Fix the root cause, not just the symptom.
5. If the buggy code is already in the correct layer, keep it there.
6. If the buggy code is a legacy exception, do not rewrite the whole feature unless required; only move the touched logic toward the correct layer when that change is small and safe.
7. Add or update a test when there is logic worth locking down.
8. Check whether localization, navigation, DI, or endpoint constants were part of the issue.

### Expected File Changes
- Minimal targeted edits in the affected feature/core files
- Tests when feasible

### Validation Checklist
- The fix does not move logic into the wrong layer.
- The fix does not widen the legacy exception.
- Existing flows still compile conceptually with the change.
- User-visible strings remain localized.
- Related edge cases are considered.

## Refactor an Existing Feature
### Goal
- Improve maintainability without changing behavior unintentionally.

### When to Use
- A feature has grown too large, duplicated logic, or unclear responsibilities.

### Workflow
1. Inspect the full feature slice before moving code.
2. Label the feature as:
   - MVVM already established
   - partial MVVM
   - view-only
3. Keep file moves scoped to the feature unless the extraction is already reused or clearly shared.
4. Extract repeated UI into `widgets` or `sections`.
5. Extract orchestration or repeated state logic into the Cubit.
6. Extract repeated API/data logic into repositories or shared core helpers only when the task touches that logic and the move is low-risk.
7. Preserve route names, localization keys, DI contracts, and existing public method names unless the task explicitly includes changing them.
8. Do not use a refactor task as an excuse to normalize every folder/file naming inconsistency in the repo.

### Expected File Changes
- Existing feature files, possibly split into smaller presentation/data units

### Validation Checklist
- No new architecture violations are introduced.
- Behavior remains the same unless the task says otherwise.
- Files are smaller and responsibilities clearer after the refactor.
- The refactor improves the touched feature without forcing a repo-wide redesign.

## Add Localization Keys
### Goal
- Add translatable strings in the same style used across the app.

### When to Use
- New text is introduced in screens, dialogs, buttons, errors, or labels.

### Workflow
1. Add the key to `assets/lang/en.json`.
2. Add the matching key to `assets/lang/ar.json`.
3. Use `'key'.tr(context)` in widgets.
4. Reuse existing key naming patterns when possible; prefer feature-specific snake_case keys over vague names.

### Expected File Changes
- `assets/lang/en.json`
- `assets/lang/ar.json`
- The consuming widget/screen

### Validation Checklist
- Both language files contain the same key.
- No new hard-coded UI string remains.
- The key name is clear and feature-specific when needed.

## Add Tests
### Goal
- Add focused tests around real logic in this Flutter app.

### When to Use
- New business/state logic is added or a bug fix should be protected.

### Workflow
1. Assume there is no reliable existing test pattern; inspect `test/` before adding tests.
2. Prefer testing Cubit behavior, model mapping, or utility logic over broad UI snapshots.
3. Place tests under `test/` using a structure that mirrors the feature when possible.
4. Mock or fake repositories if needed.
5. Assert loading, success, and error transitions for Cubits.
6. Add widget tests only for meaningful interaction/rendering behavior in the touched feature.

### Expected File Changes
- New test files under `test/`
- Small production-code changes only if needed for testability

### Validation Checklist
- Tests cover the changed logic, not unrelated scaffolding.
- Test names describe behavior.
- New tests do not depend on the default counter sample.

## Update Documentation
### Goal
- Keep repo guidance aligned with the current Flutter architecture.

### When to Use
- Structure, workflow, conventions, or agent instructions changed.

### Workflow
1. Inspect the current implementation first.
2. Update only docs that are affected.
3. Separate current repo reality from future expectation.
4. Prefer repo-specific guidance over generic Flutter advice.
5. Mention ambiguities conservatively instead of inventing rules.

### Expected File Changes
- `.ai/*`
- `README.md` if the user requested broader project docs

### Validation Checklist
- Documentation matches actual folders, tools, and patterns in the repo.
- No backend-oriented or non-Flutter guidance is introduced.
- Guidance is actionable for future code generation and refactoring.
