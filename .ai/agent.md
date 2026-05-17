# AI Agent Instructions

## Project Identity

`tabiby` is a Flutter medical mobile application for patients and doctors.

Core product areas:

- Patient authentication and profile management.
- Doctor, specialty, and clinic center discovery.
- Appointment booking with dates, periods, medical image types, lab tests, notes, and optional medical attachments.
- Patient appointment tracking, details, cancellation/rating flows, and medical file management.
- Doctor appointment dashboard, appointment details, cancellation, and appointment completion.
- AI-assisted symptom diagnosis, chest X-ray analysis, and diet/nutrition plan generation.
- Firebase push notifications and notification history.
- English/Arabic localization.

## Main Stack

- Flutter with Dart SDK constraint `^3.8.1`.
- `flutter_bloc` Cubits for state management.
- `get_it` service locator in `lib/core/utils/services_locater.dart`.
- `dio` through `ApiServices` for HTTP.
- `dartz` `Either<Failure, T>` for most repository results.
- `equatable` for many state/model value types.
- `shared_preferences` through `CacheHelper`.
- Firebase Core, Firebase Messaging, and local notifications.
- Custom JSON localization through `AppLocalizations`, not `easy_localization`.
- Named routes through `MaterialApp.routes`, plus local `MaterialPageRoute` flows.

## Read These First

Before changing code, read:

- `.ai/architecture.md`
- `.ai/code-style.md`
- `.ai/skills.md`
- The target feature folder.
- `lib/main.dart` when app bootstrap/global state is relevant.
- `lib/core/utils/services_locater.dart` when dependencies or repositories are relevant.
- `lib/core/Api_services/urls.dart` when API endpoints are relevant.
- `lib/core/utils/routs.dart` when navigation is relevant.
- `assets/lang/en.json` and `assets/lang/ar.json` when UI copy is relevant.

## Important Repository Reality

This codebase is feature-first and mostly MVVM-like:

- View: screens, widgets, sections.
- ViewModel: Cubits and states.
- Model/data: models, repositories, `ApiServices`, local cache helpers.

It is not perfectly uniform. Preserve local conventions unless the task explicitly asks for a refactor.

Known naming/folder variants that already exist:

- `routs.dart`, not `routes.dart`.
- `services_locater.dart`, not `service_locator.dart`.
- `failuer.dart`, not `failure.dart`.
- `doctor_appointment_datails`, not `doctor_appointment_details`.
- `presentaion`, not `presentation`, in part of the doctor details feature.
- `appoinment`, not `appointment`, in some booking repo names.
- `repo` and `repos` both exist.
- `view-model`, `view_model`, and `view_models` all exist.

Do not rename these globally during normal feature work.

## App Bootstrap

`lib/main.dart` performs the app bootstrap:

1. Initializes Flutter bindings.
2. Initializes `CacheHelper`.
3. Initializes Firebase using `DefaultFirebaseOptions.currentPlatform`.
4. Registers services through `setupLocatorServices()`.
5. Calls `enableScreenshot()`.
6. Initializes notifications through `FirebaseApi().initNotifications()`.
7. Runs `Tabiby`.

Global providers in `Tabiby` currently include:

- `LocaleCubit`
- `AiUsageCubit`
- `DiagnosisCubit`
- `DietCubit`
- `NotificationHistoryCubit`
- `ResetPasswordCubit`
- `UserCubit`

Many other Cubits are scoped locally inside their screens.

## API Rules

All normal backend calls should go through:

- `ApiServices`
- repository contracts/implementations under the owning feature
- endpoint constants in `Urls`

`ApiServices`:

- Sets `Dio.options.baseUrl = Urls.baseUrl`.
- Adds `PrettyDioLogger`.
- Adds `AuthInterceptor`.
- Sends `Accept`, `Accept-Charset`, and `Accept-Language`.
- Adds `Authorization: Bearer <token>` when a token exists.
- Uses JSON content type unless the payload is `FormData`.

`Urls` currently builds paths from:

```dart
static String ip = "192.168.1.3";
static String baseUrl = "http://$ip:";
static String basePort = "8000/api";
```

Do not scatter endpoint strings through UI or Cubits.

## Localization Rules

Localization is custom:

- Files: `assets/lang/en.json`, `assets/lang/ar.json`.
- Helper: `AppLocalizations` and `TranslateX`.
- Usage: `'key'.tr(context)`.
- Supported locales: English and Arabic.

Add new user-facing strings to both JSON files. Do not add hardcoded screen text unless the surrounding file is legacy and the user explicitly asks for a tiny copy-only change.

## State Management Rules

Use Cubit by default.

Do not introduce:

- Event-based Bloc for new work.
- Provider.
- Riverpod.
- Redux.
- GetX navigation/state.
- Another DI system.

State styles vary by feature. Match the target feature:

- Subclass states: `HomeInitial`, `HomeLoading`, `HomeSuccess`, `HomeError`.
- Single Equatable state with enum/status fields: `DiagnosisState`, `DietState`, `MedicalFilesState`.
- Feature-specific success/failure states: `BookingSuccess`, `BookingFailure`.

## Layer Boundaries

Views may:

- Build UI.
- Own text controllers, focus nodes, tabs, local selection visuals, and lifecycle-only state.
- Call Cubit methods.
- Listen/react with `BlocBuilder`, `BlocListener`, or `BlocConsumer`.

Views must not:

- Call `Dio` or `ApiServices` directly in new code.
- Parse backend responses.
- Choose endpoint paths.
- Persist tokens/settings directly unless using an existing core helper pattern for simple local UI state.

Cubits may:

- Validate user actions.
- Coordinate async state.
- Call repositories.
- Transform state for the UI.

Cubits must not:

- Build widgets.
- Import screen/widget classes.
- Contain endpoint strings or response parsing that belongs in repositories.

Repositories may:

- Call `ApiServices`.
- Use `Urls`.
- Parse API responses.
- Return `Either<Failure, T>`.

Repositories must not import presentation files.

## Known Legacy Exceptions

There are older flows with presentation-layer IO or very large screens, especially:

- `lib/features/user_app/medical_files/presentation/view/show_medical_files_screen.dart`
- parts of `lib/features/user_app/user_appointments`
- some local `MaterialPageRoute` navigations with constructor arguments

Do not copy these exceptions into new code. If a task touches one, improve only the touched part when it is low-risk.

## Default Workflow

For every task:

1. Identify the owning feature.
2. Inspect nearby files before editing.
3. Classify the task:
   - UI-only
   - state-flow change
   - API/data change
   - navigation/localization change
   - refactor
4. Match the feature's existing folder/state/repo pattern.
5. Keep edits scoped to the task.
6. Update localization, DI, routes, and URL constants only when needed.
7. Run formatting/analysis/tests when practical.

## Validation Commands

Use these when relevant:

```bash
flutter pub get
dart format lib test
dart analyze
flutter test
```

For iOS build checks:

```bash
flutter build ios --simulator --debug
```

Do not run heavy builds unless the task requires them.

## What Not To Do

- Do not create backend-oriented files or guidance in this Flutter repo.
- Do not introduce Clean Architecture folders like `usecases`, `entities`, or `datasources` unless the user explicitly asks for that migration.
- Do not normalize spelling or folder naming across the repo as drive-by work.
- Do not move code across feature boundaries without a real reason.
- Do not add new hardcoded UI strings.
- Do not create duplicate shared widgets when `lib/core/widgets` or local feature widgets already cover the need.
- Do not rewrite a whole feature when a focused fix will solve the task.
