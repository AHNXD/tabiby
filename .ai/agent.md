# AI Agent Instructions

## Project Overview
- `tabiby` is a Flutter mobile application.
- The codebase is organized around feature modules under `lib/features` plus shared app infrastructure under `lib/core`.
- State management is `flutter_bloc`, and the codebase currently uses Cubits as the ViewModel layer.
- Most data-backed features use repositories over `ApiServices` (`dio`) and return `Either<Failure, T>`, but not every feature is fully wired that way yet.

## Main Stack
- Flutter / Dart
- `flutter_bloc`
- `get_it`
- `dio`
- `shared_preferences`
- Custom localization via `AppLocalizations` and `assets/lang/*.json`
- Named-route navigation via `MaterialApp.routes`

## Architecture Philosophy
- Keep the app feature-first.
- Treat screens/widgets as View.
- Treat Cubits and their states as ViewModel.
- Treat repositories, models, API calls, and persistence as Model/data.
- Follow the current repo structure first; improve toward stricter MVVM only in the feature you are touching, and only as far as the task requires.

## Repository Organization
- `lib/core`
  - Shared infrastructure such as API services, errors, localization, cache helpers, constants, widgets, and service locator setup.
- `lib/features/auth`
  - Auth-related data, Cubits, and screens.
- `lib/features/user_app`
  - Main user-facing features such as home, doctors, centers, diagnose, diet, appointments, and user profile.
- `lib/features/doctor_app`
  - Doctor-facing appointment flows.
- `lib/features/shared`
  - Shared screens such as splash, welcome, settings, about, privacy, and terms.

## Before Doing Any Task
- Read `.ai/architecture.md`.
- Read `.ai/code-style.md`.
- Read `.ai/skills.md`.
- Inspect the target feature directory and identify which case you are in:
  - fully structured MVVM feature
  - partially structured feature
  - static/view-only feature
- Check how that feature currently names its folders:
  - `view`, `views`
  - `view-model`, `view_model`, `view_models`
  - `repo`, `repos`
- Search the feature for an existing Cubit/state pair before adding a new one.
- Search `lib/core/utils/routs.dart`, `lib/core/utils/services_locater.dart`, `lib/core/Api_services/urls.dart`, and `assets/lang/*.json` before making routing, DI, endpoint, or localization changes.
- Do not start coding until you know whether the task is:
  - UI-only
  - state-flow change
  - API/data change
  - refactor

## Key Rules
- UI must stay in `presentation/...` and nearby widget/section files.
- New business logic, async orchestration, and form flow logic must go into a Cubit, not into a screen.
- New network or persistence logic must go into a repository or data helper, not into a widget or Cubit.
- Use Cubit by default. Do not introduce event-based Bloc, Provider, Riverpod, Redux, or another state solution.
- Register new shared repositories/services in `lib/core/utils/services_locater.dart`.
- Add or update endpoints in `lib/core/Api_services/urls.dart` when an API integration changes.
- Add named routes in `lib/core/utils/routs.dart` only when the surrounding flow already uses route registration for that screen.
- Add localization keys to both `assets/lang/en.json` and `assets/lang/ar.json`.
- Reuse `lib/core/widgets` and existing feature widgets before creating another custom component.
- Preserve feature boundaries under `lib/features/...`; do not move code across features unless the task is explicitly a refactor.
- Keep edits incremental. Do not “clean up” unrelated naming issues, typos, or folder variants during a normal feature task.

## Rules for Working With Incomplete MVVM Features
- If a feature is currently view-only and the task is only static UI or copy changes, keep it view-only.
- If a feature is view-only and the task adds async state, validation flow, or data loading, add a Cubit in that feature instead of pushing more logic into the screen.
- If a feature already has a Cubit but still keeps some logic in the View, do not rewrite the whole feature. Move only the new or touched logic toward the Cubit when it is safe.
- If a feature already has a repository pattern, extend that repository instead of adding direct `Dio` calls in presentation.
- If a feature currently has a presentation-layer exception, treat it as legacy. Do not copy the exception into new files.
- Shared informational screens under `lib/features/shared` are often just Views today. Do not force repository/Cubit layers into them unless the task introduces real state or data work.
- `medical_files` and parts of `user_appointments` already show legacy direct download logic in presentation. Leave it alone unless the task touches that flow; if you extend that behavior, prefer moving the new IO logic behind a repo/helper instead of adding more `Dio` to the View.

## Do Not
- Do not call `ApiServices`, `Dio`, or repository methods directly from a new widget or screen.
- Do not put response parsing, endpoint selection, or persistence code in a new View or Cubit.
- Do not add business rules directly to `build()`, widget callbacks, or large screen classes when a Cubit already exists for that flow.
- Do not bypass an existing Cubit by talking to repositories from the View.
- Do not create a new state management pattern. This repo uses Cubit.
- Do not introduce Clean Architecture layers such as `usecases`, `entities`, or `datasources` folders that do not exist in the current structure.
- Do not create cross-feature imports just to reuse a screen-specific widget or Cubit from another feature.
- Do not add new hardcoded user-facing strings in UI.
- Do not create huge god files when the feature already uses `widgets`, `sections`, or separate state files.
- Do not duplicate logic already present in `core` or in the same feature.
- Do not rename existing folders just to normalize spelling or style unless the task explicitly asks for that refactor.
- Do not assume any backend architecture or generate backend-oriented guidance for this repo.
