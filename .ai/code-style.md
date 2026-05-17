# Code Style

## Guiding Principle

Match the code around the file you are editing. This repo has real production features plus older inconsistencies, so consistency with the local feature is more important than applying a brand-new global style.

## Dart and Flutter Style

- Use normal Dart formatting with `dart format`.
- Prefer `const` constructors and values where practical.
- Prefer `final` for values that are not reassigned.
- Keep imports tidy and avoid unused imports.
- Keep widgets small enough to scan.
- Use null safety carefully and avoid force unwraps unless the surrounding flow has already validated the value.

## Naming

General Dart naming:

- Files/folders: `snake_case`.
- Classes/enums/typedefs: `PascalCase`.
- Variables/methods/parameters: `camelCase`.
- Route constants: `static const routeName = ...` where the screen already follows that pattern.

Common suffixes:

- Screens: `...Screen`
- Widgets: `...Widget`, `...Card`, `...Tile`, `...Dialog`
- Sections: `...Section`
- Cubits: `...Cubit`
- States: `...State` or concrete state names like `HomeLoading`
- Repositories: `...Repo`
- Repository implementations: match local spelling, often `...RepoIplm` or `...RepositoryIplm`
- Models: `...Model`, `...Request`, `...Response`, or a feature-specific noun

Do not rename existing misspellings unless the user explicitly requests a cleanup/refactor.

## Folder Style

Use the target feature's existing pattern.

Existing variants include:

- `data/repo`
- `data/repos`
- `presentation/view`
- `presentation/views`
- `presentation/view-model`
- `presentation/view_model`
- `presentation/view_models`
- `widgets`
- `sections`

If a feature uses `view-model`, do not add `view_model` beside it.

## Widgets and Screens

Views should:

- Compose layout.
- Read localized strings.
- Dispatch actions to Cubits.
- React to Cubit state.
- Own only widget-local state such as controllers, focus nodes, animation controllers, page controllers, tabs, and temporary visual selections.

Views should not:

- Call new API methods directly.
- Import `Dio` or `ApiServices`.
- Parse response maps.
- Contain endpoint strings.
- Contain major business decisions that should be testable in a Cubit.

Use `StatelessWidget` unless local mutable widget state is needed.

Use `StatefulWidget` for:

- controllers
- lifecycle hooks
- form key ownership
- local animations
- temporary UI-only choices

Split large UI into `sections` or `widgets` when the feature already uses that structure.

## Cubit Style

Cubits should:

- Expose clear action methods.
- Validate user actions that affect flow behavior.
- Emit explicit loading, success, failure, and reset/idle states.
- Call repository contracts.
- Keep dependencies in constructor parameters.
- Stay scoped to one feature/flow.

Cubits should not:

- Import widget/screen files.
- Build UI.
- Use `BuildContext` unless an existing legacy method already does and there is no clean alternative.
- Contain raw endpoint strings.
- Parse large response maps that should be models.

Use Cubit, not event-based Bloc, for new work.

## State Style

Match the local pattern:

- If the feature has subclass states, add another subclass.
- If the feature uses one Equatable state and `copyWith`, extend that object carefully.
- If the feature uses enum status fields, add a status only when the flow genuinely needs distinct async state.

When adding `copyWith` fields that need to clear nullable values, follow existing clear flags such as `clearPlan`, `clearCurrentRequest`, or `clearExportPdfBytes`.

## Repository and Model Style

Repositories should:

- Depend on `ApiServices`, not raw `Dio`, unless the existing repo needs direct Dio for uploads/downloads.
- Use endpoint constants from `Urls`.
- Convert errors with `ErrorHandler.handle(error)`.
- Return `Either<Failure, T>` when the surrounding repo does.
- Parse defensively:
  - check status codes
  - check `resp.data['status']`
  - verify list/map types before casting
  - provide default values where models already do

Models should:

- Keep JSON mapping close to the API shape.
- Avoid UI dependencies.
- Handle missing or nullable API fields defensively.

## Async and Error Handling

For async flows, account for:

- idle/initial
- loading
- success
- error/failure
- empty state when relevant
- submission in progress when forms are involved

Do not swallow errors silently. Surface user-safe messages through state.

Preserve stale async protection when present, such as `DietCubit`'s `_sessionVersion`.

## Localization

New user-facing text should be localized.

Steps:

1. Add a readable `snake_case` key to `assets/lang/en.json`.
2. Add the same key to `assets/lang/ar.json`.
3. Use `'key'.tr(context)`.

Use existing keys before adding new ones.

Do not use `easy_localization`; this app has its own localization helper.

## Navigation

Use existing navigation style for the flow:

- Named route with `routeName` and `Routes.routes` for global screens.
- `MaterialPageRoute` for local step/detail flows that pass constructor arguments.

Do not introduce a new routing package.

When a route needs arguments, inspect current usage carefully. Some route table entries instantiate screens with placeholder IDs and may not be suitable for new argument-heavy flows.

## Dependency Injection

- Register shared repositories/services in `lib/core/utils/services_locater.dart`.
- Use `getit.get<T>()` where the feature already resolves dependencies that way.
- Keep feature Cubits local with `BlocProvider` unless the state is intentionally app-wide.
- Avoid service locator calls inside deeply reusable widgets.

## Assets and Fonts

Assets are declared in `pubspec.yaml`:

- `assets/lang/`
- `assets/images/`
- `assets/icons/`
- `assets/fonts/`

Custom fonts:

- `cocon-next-arabic`
- `Hacen Beirut`

When adding an asset, update `pubspec.yaml` only if the asset is outside the existing declared directories.

## Formatting and Quality Commands

Use:

```bash
dart format lib test
dart analyze
flutter test
```

Run `flutter pub get` after dependency or asset config changes.

## Avoid

- Hardcoded user-facing strings in new UI.
- New API calls in widgets.
- New direct `Dio` usage in presentation.
- New state management libraries.
- New route/navigation libraries.
- Broad file/folder renames as drive-by cleanup.
- Huge new screen files.
- Copying legacy IO patterns from large screens into fresh code.
- Reimplementing shared buttons, colors, styles, loaders, or error widgets that already exist.
