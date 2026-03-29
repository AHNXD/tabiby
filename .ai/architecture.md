# Architecture

## Overall Style
- This repository follows a feature-first Flutter architecture with a shared `core` layer.
- In practice, it maps to MVVM like this:
  - View: screens, widgets, sections
  - ViewModel: Cubits and their states
  - Model/data: models, repositories, API/storage access
- It is not organized as a backend project and should be treated as a mobile UI codebase.

## Current State vs Target MVVM Architecture

### Current State
- The repo is feature-first and mostly Cubit-based.
- Many data-backed features already follow a practical MVVM flow:
  - View in `presentation/...`
  - Cubit as the ViewModel
  - repo/model code in `data/...`
- DI is centralized in `lib/core/utils/services_locater.dart`.
- Routing is centralized in `lib/core/utils/routs.dart`, but some flows also use `MaterialPageRoute`.
- Localization is centralized through `assets/lang/*.json` and `'key'.tr(context)`.
- Not every feature is fully layered:
  - several `lib/features/shared/*` screens are View-only
  - some features are partially structured
  - there are legacy presentation-layer IO exceptions, for example direct `Dio` downloads in:
    - `lib/features/user_app/medical_files/presentation/view/show_medical_files_screen.dart`
    - `lib/features/user_app/user_appointments/presentation/view/widgets/appointment_item.dart`
- The repo currently uses Cubit. There is no event-based Bloc architecture to copy.
- Testing is minimal; `test/widget_test.dart` is still the default sample.

### Target Going Forward
- New code should keep View, Cubit, and data responsibilities separate even if older files are less strict.
- New side effects, networking, and persistence should go into repositories/helpers, not into new widgets.
- When touching a partially structured feature, improve only the touched flow incrementally; do not rewrite the whole feature unless the task requires it.
- New features should use the existing feature-first + Cubit pattern, not Clean Architecture layers.

## Feature Structure
- Main app code lives under `lib/features`.
- Top-level feature groups currently include:
  - `auth`
  - `user_app`
  - `doctor_app`
  - `shared`
- Most features contain:
  - `data/models`
  - `data/repo` or `data/repos`
  - `presentation/...`
- Some features, especially under `lib/features/shared`, contain only presentation files because they are static or near-static pages.
- Presentation folder names are not fully uniform across the repo:
  - `view`
  - `views`
  - `view-model`
  - `view_models`
  - `view_model`
- When editing a feature, follow that feature's existing pattern instead of renaming everything.

## Layer Definitions

### View
- Lives in screen/widget folders such as:
  - `presentation/view`
  - `presentation/views`
  - `view/widgets`
  - `view/sections`
- Responsibilities:
  - Build UI
  - Dispatch user actions to Cubits
  - Listen to Cubit state through `BlocBuilder`, `BlocConsumer`, or `BlocListener`
  - Keep only widget-local visual state such as controllers, temporary toggles, or lifecycle hooks
  - Use localized strings
- View must not own:
  - endpoint selection
  - response parsing
  - repository orchestration
  - persistence logic
  - non-trivial business rules

### ViewModel
- Usually implemented with `Cubit` classes and matching state classes.
- Typical locations:
  - `presentation/view-model/...`
  - `presentation/view_models/...`
  - `presentation/view_model/...`
- Responsibilities:
  - Hold screen/flow state
  - Coordinate async work
  - Validate or transform user actions for the screen flow
  - Call repositories
  - Emit loading, success, error, and selection states
- Cubit is the default ViewModel pattern in this repo. Do not introduce event-based Bloc for new work.

### Model / Data Layer
- Lives in feature `data` folders and shared `lib/core`.
- Typical contents:
  - Request/response models
  - Repository contracts and implementations
  - API calls through `ApiServices`
  - Shared failure/error handling
  - Local cache access when needed
- Responsibilities:
  - Fetch and parse data
  - Return typed results, usually `Either<Failure, T>`
  - Stay free of widget/rendering concerns
- This layer is the correct place for new API integrations, data mapping, and storage-related logic.

## Dependency Direction Rules
- View may depend on:
  - Cubits/states
  - render models needed for display
  - shared widgets/helpers
- View must not depend on:
  - `ApiServices`
  - new direct `Dio` calls
  - repository implementations
- ViewModel may depend on:
  - repository contracts
  - models
  - core helpers already used in that flow
- ViewModel must not depend on:
  - widget classes
  - rendering concerns
  - endpoint constants scattered through UI code
- Repositories may depend on:
  - `ApiServices`
  - `Urls`
  - core error helpers
  - models
- Data layer must never import presentation files.

## How Bloc/Cubit Fits MVVM Here
- Cubits are the closest thing to ViewModels in this repo.
- The View triggers methods such as `getHome()`, `fetchSymptomsForSelectedPart()`, `generateDietPlan()`, or `bookAppointment(...)`.
- The Cubit talks to repositories and emits state.
- The View rebuilds or reacts based on that state.
- Current state patterns vary by feature:
  - subclass-based states such as `HomeInitial`, `HomeLoading`, `HomeSuccess`, `HomeError`
  - one Equatable state object plus enums/status fields such as `DiagnosisState`, `DietState`, and `MedicalFilesState`
- When extending a feature, keep the state pattern already used in that feature.

## Where Things Live
- Screens/pages/widgets:
  - Feature `presentation/view*` folders
  - Shared UI pieces often live in feature `widgets` or `sections`
  - App-wide shared widgets live in `lib/core/widgets`
- ViewModels:
  - Feature `presentation/view-model`, `view_models`, or `view_model`
- Repositories/services/models/datasources:
  - Feature `data/models`
  - Feature `data/repo` or `data/repos`
  - Shared network helpers in `lib/core/Api_services`

## Data Flow
1. User interacts with a screen/widget.
2. The View calls a Cubit method.
3. The Cubit emits a loading or intermediate state.
4. The Cubit calls a repository.
5. The repository uses `ApiServices` or local storage helpers.
6. The repository returns `Either<Failure, T>` or typed data.
7. The Cubit emits success/error state.
8. The View rebuilds and shows data, loading, or error UI.

## Shared/Core Conventions
- `lib/core/Api_services`
  - Shared `dio` wrapper, URLs, auth interceptor
- `lib/core/errors`
  - `Failure` types and error handling
- `lib/core/locale`
  - `LocaleCubit`
- `lib/core/utils`
  - Cache helper, constants, colors, styles, routes, service locator
- `lib/core/widgets`
  - Reusable widgets such as app bars, buttons, and error widgets

## Routing
- App routing is centralized in `lib/core/utils/routs.dart`.
- `MaterialApp.routes` is used in `main.dart`.
- Many screens expose a static `routeName`.
- Some flows also use `Navigator.push` with `MaterialPageRoute` for local transitions.
- When adding a screen, match the routing style already used by that feature flow.
- Do not introduce a new navigation system.
- Be careful with screens that require constructor arguments; the current route table is not fully uniform for argument-heavy screens.

## Dependency Injection
- DI is centralized in `lib/core/utils/services_locater.dart`.
- `getit` registers shared repositories and services.
- Some Cubits are provided globally in `main.dart`.
- Many feature-specific Cubits are created locally with `BlocProvider` inside the screen that needs them.
- Follow that split:
  - global only for app-wide state already treated that way
  - local `BlocProvider` for feature/screen-specific flows

## Localization
- Localization is custom, not `easy_localization`.
- Strings are stored in:
  - `assets/lang/en.json`
  - `assets/lang/ar.json`
- Views use `'key'.tr(context)` from `AppLocalizations`.
- New UI strings should be added to both JSON files.

## Testing
- The repo currently does not show a mature test suite.
- `test/widget_test.dart` is still the default Flutter counter sample and does not reflect the actual app.
- New tests should be added conservatively around Cubits, model parsing, and meaningful widget behavior.

## Rules for Adding New Code
- Start by classifying the target feature:
  - view-only
  - partial MVVM
  - established MVVM
- For a view-only feature:
  - keep static content in presentation
  - add a Cubit only if the task introduces real state or async behavior
- For a partial MVVM feature:
  - extend the existing structure
  - move only the touched logic toward the correct layer
- For an established MVVM feature:
  - keep View, Cubit, and repo responsibilities separated
- Put UI in the feature's `presentation` area.
- Put screen state and action coordination in a Cubit.
- Put API/storage logic in repositories or core services.
- Add new endpoints in `lib/core/Api_services/urls.dart` when needed.
- Register new repositories in `services_locater.dart` when needed.
- Add route entries in `routs.dart` when the screen should be reachable by name.
- Add localization keys in both language files.
- Reuse `core/widgets`, shared styles, colors, and helpers before creating duplicates.
- Keep new code inside the owning feature unless a shared extraction is already justified by the task.

## Architecture Violations to Avoid
- New widget or screen directly calling `Dio`, `ApiServices`, or repository methods
- New widget or screen parsing API responses or choosing endpoints
- Cubit directly building widgets, formatting UI layout, or owning rendering concerns
- Data/model layer importing presentation/view code
- One feature depending on another feature's screen-specific Cubit or widget instead of shared/core code
- Unstructured state handling spread across many widgets instead of the Cubit/state layer
- Bypassing `getit` registration patterns for shared repositories already managed centrally
- Large screens that ignore existing `widgets` and `sections` structure
- Introducing a new state management or navigation system
- Copying known legacy exceptions such as direct `Dio` downloads in presentation into new files
