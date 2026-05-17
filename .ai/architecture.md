# Architecture

## High-Level Shape

Tabiby uses a feature-first Flutter architecture with shared infrastructure under `lib/core`.

Practical MVVM mapping:

- View: `Screen`, `Widget`, and `Section` classes under `presentation`.
- ViewModel: Cubits and state classes.
- Model/data: request/response models, repository contracts, repository implementations, API helpers, and cache helpers.

The project is not fully uniform, so local feature conventions matter more than theoretical purity.

## Entry Point and Global App State

`lib/main.dart` creates the app after initializing cache, Firebase, dependency injection, screenshots, and notifications.

The root `MaterialApp` configures:

- `navigatorKey`
- `LocaleCubit`
- English and Arabic locales
- custom localization delegates
- app theme and custom font
- `SplashScreen.routeName` as the initial route
- route table from `Routes.routes`

Global Cubits are used for app-wide or long-lived flows:

- locale
- AI usage
- diagnosis
- diet
- notification history
- reset password
- user profile

Feature-specific Cubits are usually provided near their screens.

## Core Layer

`lib/core` contains shared infrastructure:

- `Api_services/`
  - `ApiServices`
  - `Urls`
  - `AuthInterceptor`
  - `AiProxyService`
- `ai_usage/`
  - Cubit/state for AI usage limits.
- `errors/`
  - Failure and error handling helpers.
- `locale/`
  - `LocaleCubit`.
- `models/`
  - shared models.
- `notification_services/`
  - `FirebaseApi` and notification setup.
- `repos/`
  - shared repositories such as AI usage.
- `utils/`
  - colors, constants, cache helper, localization helper, routes, service locator, styles, functions.
- `widgets/`
  - reusable app widgets.

Shared code should live here only when more than one feature genuinely needs it.

## Feature Groups

Main feature groups:

- `lib/features/auth`
  - login, sign up, logout, OTP, token handling, reset password.
- `lib/features/user_app`
  - patient-facing features: home, specialties, doctors, centers, booking, appointments, medical files, diagnosis, diet, notification history, profile.
- `lib/features/doctor_app`
  - doctor appointment dashboard and appointment details/end/cancel flows.
- `lib/features/shared`
  - splash, welcome, settings, about, contact, privacy, terms.

## Typical Feature Layout

Common feature folders:

```text
feature/
  data/
    models/
    repo/ or repos/
  presentation/
    view/ or views/
    widgets/
    sections/
    view-model/ or view_model/ or view_models/
```

Follow the target feature's current spelling and structure. Do not create a parallel naming style beside an existing one.

## Data Flow

Expected data flow:

1. User interacts with a View.
2. View calls a Cubit method.
3. Cubit emits loading/selection/submission state.
4. Cubit calls a repository contract.
5. Repository uses `ApiServices`, `Urls`, and models.
6. Repository returns `Either<Failure, T>` or another locally established typed result.
7. Cubit emits success/error state.
8. View renders or reacts.

## API Architecture

`ApiServices` wraps Dio and should be the main HTTP boundary.

Repository implementations are responsible for:

- choosing endpoint constants from `Urls`
- sending request models
- parsing response models
- converting failures through `ErrorHandler`
- returning typed results

`ApiServices` is also responsible for:

- auth headers from cached token
- language header from cached locale
- redirecting unauthorized users through `AuthInterceptor`
- handling `FormData` headers correctly

New API work should not bypass this stack.

## AI Proxy Flows

AI-related app features are routed through backend proxy endpoints, not direct OpenAI/client-side API calls.

Relevant features:

- `diagnose`
  - symptoms by body part
  - diagnosis submission
  - chest X-ray image selection and analysis
- `diet`
  - diet plan generation
  - plan history
  - latest plan
  - PDF export support
- `core/ai_usage`
  - remaining AI usage checks

Keep AI calls behind existing repositories/services such as `DiagnosisRepository`, `DietRepository`, `AiProxyService`, and `AiUsageRepo`.

## Routing

Routing is mixed:

- App-level named routes live in `lib/core/utils/routs.dart`.
- `MaterialApp.routes` is used in `main.dart`.
- Some flows use direct `MaterialPageRoute`, especially when constructor arguments or local step navigation are easier.

Rules:

- Use named routes when the surrounding feature already does and the screen can be globally addressed.
- Use direct `MaterialPageRoute` when the existing flow passes rich constructor arguments locally.
- Do not introduce a routing package.
- Be careful with route table entries that provide placeholder constructor arguments, such as IDs of `0`.

## Dependency Injection

`getit` is the central DI container.

`setupLocatorServices()` registers:

- `Dio`
- `ApiServices`
- `AiProxyService`
- auth repositories
- user repositories
- specialties, doctors, centers, home repositories
- booking and medical files repositories
- notification history repository
- appointment repositories
- doctor appointment repositories
- diagnosis and diet repositories
- rating repository

Rules:

- Register new shared repositories/services in `services_locater.dart`.
- Use repository contracts where the feature already has them.
- Keep screen-specific Cubits local unless the state is intentionally global.
- Do not create another dependency injection approach.

## Localization

Localization is custom:

- `assets/lang/en.json`
- `assets/lang/ar.json`
- `AppLocalizations`
- `TranslateX` extension: `'key'.tr(context)`

New UI strings must be added to both JSON files.

API requests include `Accept-Language` from cached locale. Be aware that changing language behavior can affect backend response language.

## Notifications

`FirebaseApi` handles:

- notification permission requests
- local notification channel setup
- foreground local notification display
- background/terminated notification click handling hooks
- FCM token caching
- backend FCM token sync through `Urls.fcmToken`

Notification navigation is currently a TODO in `handleMessageData`. If implementing it, use the existing `navigatorKey`/route patterns and keep payload parsing defensive.

## State Patterns

There are several accepted local patterns:

- Simple subclass states:
  - `HomeInitial`
  - `HomeLoading`
  - `HomeSuccess`
  - `HomeError`
- Single immutable Equatable state:
  - `DiagnosisState`
  - `DietState`
  - `MedicalFilesState`
- Flow-specific states:
  - `BookingInitial`
  - `BookingLoading`
  - `BookingSuccess`
  - `BookingFailure`
  - `AppointmentBookedSuccessfully`

Do not force one pattern across the repo. Match the file you are extending.

## Feature-Specific Notes

### Auth

- Uses `presentation/view-model`.
- Has separate Cubits for login, logout, register, reset password, and token.
- Uses repository contracts and implementations under nested repo folders.

### Booking

- Path: `lib/features/user_app/add_appointment`.
- Uses `BookingCubit` and `BookingState`.
- Handles center/date/time selection, lab tests, medical image type selection, medical attachments, diagnosis result attachment, and booking submission.
- Keep booking flow state in `BookingCubit`; do not add booking rules to widgets.

### Medical Files

- Uses `MedicalFilesCubit` with a single Equatable state.
- Repository handles upload/list behavior.
- `show_medical_files_screen.dart` is large and contains some legacy presentation-side behavior. Improve touched behavior incrementally.

### Diagnosis

- Uses global `DiagnosisCubit`.
- Handles body part selection, symptoms, questions, diagnosis results, X-ray image picking, X-ray medical file selection, and X-ray analysis.
- Uses both `DiagnosisRepository` and `MedicalFilesRepo`.

### Diet

- Uses global `DietCubit`.
- Loads history in constructor.
- Uses request/response/history models and PDF builder service.
- Has async status fields for submit/history/plan/export.
- Be careful with `_sessionVersion` checks that prevent stale async updates.

### Doctor Appointment Details

- Has existing misspellings in paths.
- Uses multiple Cubits for details, cancel, and end appointment.
- Do not rename folders while changing behavior.

## Testing Reality

The test suite is currently minimal. `test/widget_test.dart` is the default sample and does not represent app behavior.

When adding tests, prefer focused tests for:

- Cubit state transitions.
- model parsing.
- repository behavior with fakes/mocks.
- utility functions.

Avoid broad fragile widget tests unless the task specifically needs UI interaction coverage.

## Architecture Violations To Avoid

- New screen directly calling `Dio`, `ApiServices`, or backend endpoints.
- New Cubit parsing raw API maps when a model/repo should do it.
- Data files importing presentation files.
- Cross-feature imports of screen-specific widgets/Cubits.
- New state management or routing systems.
- Hardcoded user-facing strings in new UI.
- Large new screen files when the feature already has `widgets`/`sections`.
- Repo-wide renaming or cleanup during a focused task.
