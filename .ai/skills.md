# AI Skills

## Skill: Read the Project Before Editing

### Use When

Any task asks for implementation, refactor, documentation, architecture cleanup, bug fixing, or feature work.

### Workflow

1. Identify the likely owning feature.
2. Read nearby screens, Cubits, states, repos, and models.
3. Read shared files if relevant:
   - `lib/core/utils/services_locater.dart`
   - `lib/core/utils/routs.dart`
   - `lib/core/Api_services/urls.dart`
   - `lib/core/Api_services/api_services.dart`
   - `assets/lang/en.json`
   - `assets/lang/ar.json`
4. Decide whether the task is UI-only, state-flow, API/data, routing, localization, notification, or refactor.
5. Make the smallest change that fits the current architecture.

### Done When

- The change matches local folder and state patterns.
- No unrelated cleanup or renaming was introduced.

## Skill: Add or Update a Feature

### Use When

Adding a new capability or extending an existing feature.

### Workflow

1. Inspect the nearest comparable feature.
2. Match its structure:
   - `data/models`
   - `data/repo` or `data/repos`
   - `presentation/view` or `presentation/views`
   - local `widgets` and `sections`
   - `view-model`, `view_model`, or `view_models`
3. If static UI only, keep it in presentation.
4. If the feature has user actions or async state, add or extend a Cubit.
5. If the feature calls backend/local persistence, add or extend a repository.
6. Register new repository/service dependencies in `services_locater.dart`.
7. Add route entries only when the feature uses named routes.
8. Add localization keys to both language files.
9. Add focused tests when meaningful.

### Validation

- Views do not call `ApiServices`.
- Cubits do not parse large backend responses.
- Repositories return typed results.
- Strings are localized.

## Skill: Add an API Integration

### Use When

A feature needs a new backend endpoint or changes how it calls an existing endpoint.

### Workflow

1. Add/update endpoint constants in `Urls`.
2. Add/update request and response models in the feature `data/models`.
3. Extend the repository contract.
4. Implement the repository method using `ApiServices`.
5. Convert failures through `ErrorHandler`.
6. Return `Either<Failure, T>` if the surrounding repo does.
7. Call the repository from the Cubit.
8. Render loading/success/error in the View.

### Validation

- No raw endpoint string is introduced in View.
- No new direct `Dio` call is introduced in View.
- API response shape is checked defensively.
- Auth and language headers continue to flow through `ApiServices`.

## Skill: Add or Update a Cubit Flow

### Use When

Adding validation, loading, selection, form submission, step navigation state, or async orchestration.

### Workflow

1. Search for an existing Cubit in the feature.
2. Extend the existing Cubit if the behavior belongs to the same flow.
3. Add a new Cubit only when the behavior is separate.
4. Match local state style:
   - subclass states
   - Equatable `copyWith`
   - enum status fields
5. Add clear action methods.
6. Emit loading, success, error, and reset/idle as needed.
7. Keep repository calls in the Cubit, not widgets.
8. Keep response parsing in the repository, not Cubit.

### Validation

- View only dispatches actions and renders/listens to state.
- Cubit has no widget imports.
- Async failure paths are visible to the UI.

## Skill: Add a Screen

### Use When

Adding a page, step, picker, result screen, details screen, or form screen.

### Workflow

1. Place the screen beside related screens in `view` or `views`.
2. Place reusable parts in local `widgets` or `sections`.
3. Use local Cubit state if the screen is interactive.
4. Use existing shared widgets/styles/colors.
5. Add `routeName` only if similar screens in the feature use named routing.
6. Register in `routs.dart` only if globally navigable.
7. Localize titles, labels, buttons, empty/error messages, and dialog text.

### Validation

- Screen has no API parsing or repository implementation details.
- Navigation style matches the feature.
- Layout is split when it becomes large.

## Skill: Update Booking Flow

### Use When

Changing appointment booking, centers, days, times, lab tests, medical image type selection, attachments, or booking submission.

### Workflow

1. Read `BookingCubit`, `BookingState`, `BookingScreen`, and `booking_form.dart`.
2. Read `AddAppoinmentRepo` and `AddAppoinmentRepoIplm`.
3. Keep selection and submission state in `BookingCubit`.
4. Keep request payload changes in `AppointmentBookingRequest`.
5. Keep endpoint changes in `Urls` and repository implementation.
6. Preserve `BookingSuccess` fallback behavior for recoverable failures.

### Validation

- Center/date/time reset behavior remains coherent.
- `isBooking`, loading days, and loading times states are handled.
- Department-specific rules remain in `BookingDepartmentType`/Cubit, not scattered in widgets.

## Skill: Update Diagnosis or Diet AI Flows

### Use When

Changing symptom diagnosis, X-ray diagnosis, diet generation, diet history, latest diet plan, AI usage, or exports.

### Workflow

1. Read the relevant Cubit/state first:
   - `DiagnosisCubit` and `DiagnosisState`
   - `DietCubit` and `DietState`
   - `AiUsageCubit` if limits are involved
2. Read the repository and models.
3. Keep AI requests behind backend proxy services/repositories.
4. Do not add direct client-side OpenAI/API-key calls.
5. Preserve Diet async session protection with `_sessionVersion`.
6. Update AI usage refresh behavior if the backend action consumes quota.

### Validation

- Loading/error/success states are explicit.
- Selected images/files are handled defensively.
- Existing result screens still get the state they expect.

## Skill: Update Medical Files

### Use When

Changing upload, list, filter, picker, preview, download, or file attachment behavior.

### Workflow

1. Read `MedicalFilesCubit`, `MedicalFilesState`, repository, and models.
2. Be aware `show_medical_files_screen.dart` is large and partly legacy.
3. Put new upload/list API logic in `MedicalFilesRepo`.
4. Put new screen state in `MedicalFilesCubit`.
5. For booking attachments, also read `MedicalAttachmentItem` and booking flow.

### Validation

- File type filters still work.
- Upload success merges or reloads files correctly.
- New IO is not added directly to presentation unless the task is explicitly a tiny legacy fix.

## Skill: Update Notifications

### Use When

Changing FCM setup, notification history, notification click behavior, token sync, or foreground local notifications.

### Workflow

1. Read `FirebaseApi` in `lib/core/notification_services/notification.dart`.
2. Read `NotificationHistoryCubit` and repository if history is involved.
3. Keep token sync through `Urls.fcmToken` and `ApiServices`.
4. If implementing click navigation, use `navigatorKey` and existing routes.
5. Parse notification payloads defensively.

### Validation

- Foreground local notifications still show.
- Token refresh still updates backend when authenticated.
- iOS APNS token behavior remains safe for simulators.

## Skill: Add Localization Keys

### Use When

Adding or changing user-facing text.

### Workflow

1. Search both locale files for an existing key.
2. Add the key to `assets/lang/en.json`.
3. Add the same key to `assets/lang/ar.json`.
4. Use `'key'.tr(context)`.
5. Keep keys readable and feature-specific.

### Validation

- Both locale files contain the same new keys.
- New UI has no hardcoded user-facing strings.

## Skill: Fix a Bug

### Use When

Existing behavior is wrong, crashing, inconsistent, or regressed.

### Workflow

1. Reproduce or trace the bug path.
2. Locate whether the bug is in View, Cubit, repo, model, route, DI, localization, or API config.
3. Fix the root cause in the correct layer.
4. Keep the patch narrow.
5. Add a focused test if the behavior is easy to isolate.

### Validation

- The fix does not widen legacy patterns.
- Failure states and null cases are handled.
- Existing navigation/DI/localization contracts remain intact.

## Skill: Refactor Safely

### Use When

The user explicitly asks for refactoring or cleanup.

### Workflow

1. Read the full feature slice.
2. Keep moves inside the feature unless extracting truly shared code.
3. Extract UI into `widgets`/`sections`.
4. Move flow logic into Cubit.
5. Move API/storage logic into repository/helper.
6. Preserve route names, localization keys, constructor contracts, and public Cubit methods unless the refactor requires changing them.
7. Avoid repo-wide naming normalization.

### Validation

- Behavior remains the same unless requested.
- Files become clearer without creating new architecture layers.
- No cross-feature dependency is introduced unnecessarily.

## Skill: Update Documentation

### Use When

Updating `README.md`, `.ai/*`, or developer guidance.

### Workflow

1. Inspect the current implementation first.
2. Separate actual repo reality from target guidance.
3. Mention known inconsistencies conservatively.
4. Prefer project-specific instructions over generic Flutter advice.
5. Update only affected docs unless the user asks for a full refresh.

### Validation

- Documentation matches actual files and tools.
- Guidance is actionable for future agents.
- No backend-only guidance is introduced for the Flutter app.
