# Code Style

## Naming Conventions
- Follow existing Dart/Flutter style:
  - Files and folders: `snake_case`
  - Classes, enums, typedefs: `PascalCase`
  - Variables, methods, parameters: `camelCase`
  - Constants: `camelCase` or `static const routeName` style already used in the repo
- Use the suffixes already present in the repo:
  - Screens: `...Screen`
  - Widgets: `...Section`, `...Card`, `...Dialog`, `...Tile`, `...Widget`
  - Cubits: `...Cubit`
  - States: `...State`, or concrete states like `HomeLoading`, `HomeSuccess`, `HomeError`
  - Repositories: `...Repo`
  - Repository implementations: existing repo style is usually `...RepoIplm` or `...RepositoryIplm`; match the local feature even if spelling is imperfect
  - Models: `...Model`, `...Request`, `...Response`, or feature-specific typed names
- Do not “fix” naming inconsistencies across the repo unless explicitly asked.
- For new files, prefer names that match nearby files exactly:
  - `home_screen.dart`
  - `home_cubit.dart`
  - `home_state.dart`
  - `home_repo.dart`
  - `home_repo_iplm.dart`

## Folder Naming
- Prefer the folder pattern already used by the target feature.
- Common patterns already present:
  - `data/models`
  - `data/repo`
  - `data/repos`
  - `presentation/view`
  - `presentation/views`
  - `presentation/view-model`
  - `presentation/view_models`
  - `presentation/view_model`
  - `widgets`
  - `sections`
- If the target feature uses `view-model`, keep using `view-model` in that feature.
- If the target feature uses `repo`, do not introduce `repos` beside it unless required by the existing local structure.

## File Splitting
- Keep screens focused on composition and state listening.
- Split repeated or visually distinct UI blocks into `widgets` or `sections`.
- Keep Cubit and state in separate files when that feature already does so.
- Use `part` state files only when the surrounding feature already follows that style.
- Avoid very large single files when the feature already supports decomposition.
- Do not split files into extra abstraction layers the repo does not use.

## Widget Rules
- Prefer `StatelessWidget` when local mutable UI state is unnecessary.
- Use `StatefulWidget` only for widget-local concerns such as controllers, temporary selection, or lifecycle hooks.
- Keep widgets reusable when the same UI pattern appears more than once.
- Reuse components from `lib/core/widgets` and shared feature widgets before creating new ones.
- Do not place API calls or repository access in widgets.
- Do not place `Dio` downloads, endpoint strings, or response mapping in new widgets.

## View Rules
- Views must focus on:
  - rendering
  - layout
  - dispatching user actions
  - reacting to Cubit state
- Views may keep small ephemeral UI state locally, but not business rules, network flow, or persistence orchestration.
- Use `BlocBuilder`, `BlocConsumer`, or `BlocListener` consistently with the existing flow.
- A View may create a local `BlocProvider` for its screen-specific Cubit, because that pattern already exists in the repo.
- A View must not talk directly to `ApiServices`, new direct `Dio` calls, or repo methods.

## ViewModel / Cubit Rules
- Use Cubit by default. The repo does not currently use event-based Bloc flows.
- Cubits should:
  - depend on repositories, models, and core helpers
  - expose explicit methods for user actions
  - emit clear loading/error/success/selection states
  - coordinate calls between View and repo
- Keep Cubits focused on one feature or one screen flow.
- Put flow validation in the Cubit when it affects behavior across widgets or network calls.
- Do not turn a Cubit into a grab-bag service container.
- Do not import widget classes into Cubit files.
- Do not put endpoint constants or response parsing in the Cubit when that logic belongs in the repo.

## Async State Handling
- Model async flows explicitly.
- Existing repo patterns include:
  - sealed-ish state classes like `Loading`, `Success`, `Error`
  - enum-driven view states inside a single Equatable state object
- Match the pattern already used in the target feature.
- For a new or changed async flow, account for:
  - loading
  - success
  - error
  - reset/idle or empty state when the flow needs it
- Do not leave error handling implicit.
- Do not hide loading state in ad-hoc widget booleans if the Cubit already owns that flow.

## Localization
- Do not hard-code user-facing strings in Views.
- Add keys to both:
  - `assets/lang/en.json`
  - `assets/lang/ar.json`
- Use `'key'.tr(context)` in widgets.
- Keep key names readable, `snake_case`, and feature-specific when needed.
- If you add a string to one locale file, add it to the other in the same change.

## Routing
- Use static `routeName` when the feature participates in named routing.
- Register named routes in `lib/core/utils/routs.dart`.
- For local step flows already using `MaterialPageRoute`, keep that pattern unless there is a clear reason to centralize the route.
- Do not introduce a new routing package.
- Do not force every new screen into `routs.dart` if the surrounding flow navigates locally and passes constructor arguments directly.

## Dependency Injection
- Shared repositories/services should be registered in `lib/core/utils/services_locater.dart`.
- Use `getit.get<T>()` consistently where the feature already resolves dependencies that way.
- Provide Cubits globally only when they are truly app-wide; otherwise create them close to the screen with `BlocProvider`.
- Do not invent a second DI mechanism.

## Null Safety and Defensive Coding
- Respect Dart null safety.
- Check nullable IDs, models, and selected values before using them.
- Parse API responses defensively.
- Return typed failures instead of throwing UI-facing exceptions through widgets.
- Preserve existing guard-clause style where it already exists in Cubits.
- When extending repo code, prefer returning `Either<Failure, T>` like the surrounding data layer.

## Readability and Maintainability
- Keep methods short and intention-revealing.
- Prefer explicit names over overly generic abstractions.
- Reuse current core helpers such as cache, localization, colors, styles, and error widgets.
- Follow the feature's local import and file organization pattern.
- Add comments only when a piece of logic is not obvious from the code.
- Prefer incremental improvement in the touched flow over broad rewrites.

## Anti-Patterns to Avoid
- Business logic inside widgets
- New widget directly importing `dio`, `ApiServices`, or repo methods for side effects
- Repository logic placed in a screen or section widget
- Presentation code imported into the data layer
- Adding a new state management library or event-based Bloc architecture
- Hardcoded user-facing strings in UI
- Huge files that should be split into sections/widgets/state classes
- Duplicating shared UI or utility logic that already exists in `core` or the same feature
- Broad architecture rewrites when the task only needs a focused feature change
- Copying legacy presentation-layer IO patterns from `medical_files` or `user_appointments` into new code
