# Tabiby

Tabiby is a Flutter medical application for patients and doctors. It brings together appointment booking, doctor and center discovery, medical file management, notifications, AI-assisted diagnosis flows, and nutrition plan generation in one bilingual mobile experience.

The application is built with a feature-first architecture, BLoC/Cubit state management, Dio-based API integration, Firebase Cloud Messaging, and local persistence through shared preferences.

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Run the App](#run-the-app)
- [Testing and Code Quality](#testing-and-code-quality)
- [Build](#build)
- [Localization](#localization)
- [Development Notes](#development-notes)
- [Repository Status](#repository-status)

## Features

### Patient App

- User registration, login, logout, OTP verification, and password reset.
- Browse medical specialties, doctors, and clinic centers.
- View doctor and center details.
- Book appointments with available centers, dates, times, and medical attachments.
- Track upcoming and previous appointments.
- Upload and manage patient medical records.
- View notification history and appointment updates.
- Rate completed appointments.
- Manage user profile and account settings.

### Doctor App

- View doctor appointment dashboard.
- Filter and inspect appointment requests.
- Open full appointment details.
- Cancel appointments when required.
- End appointments with diagnosis, notes, lab tests, and medication data.

### AI and Health Assistance

- Symptom-based diagnosis flow.
- Chest X-ray analysis flow.
- AI-generated diet and nutrition plans.
- AI usage limit tracking.

### Shared Experience

- Bilingual UI: English and Arabic.
- Firebase push notifications.
- Localized API requests through `Accept-Language`.
- Token-based API authentication.
- Privacy policy, terms and conditions, contact us, about us, and settings screens.

## Tech Stack

- **Flutter SDK:** `^3.8.1`
- **Language:** Dart
- **State management:** `flutter_bloc`
- **Dependency injection:** `get_it`
- **Networking:** `dio`
- **API logging:** `pretty_dio_logger`
- **Functional error handling:** `dartz`, `equatable`
- **Persistence:** `shared_preferences`
- **Push notifications:** `firebase_core`, `firebase_messaging`, `flutter_local_notifications`
- **Media and files:** `image_picker`, `file_picker`
- **PDF support:** `pdf`, `printing`
- **Localization:** Flutter localization delegates with JSON assets
- **UI utilities:** `cached_network_image`, `shimmer`, `lottie`, `awesome_dialog`, `font_awesome_flutter`

## Project Structure

```text
lib/
  main.dart                         # App bootstrap, Firebase init, providers, theme, routes
  firebase_options.dart             # Firebase platform options
  core/
    Api_services/                   # Dio client, API URLs, auth interceptor, AI proxy service
    ai_usage/                       # AI usage state management
    errors/                         # Failure and error models
    locale/                         # Language state management
    notification_services/          # Firebase notification setup
    repos/                          # Shared repositories
    utils/                          # Routing, constants, styles, colors, cache helper, DI
    widgets/                        # Reusable shared widgets
  features/
    auth/                           # Login, sign up, OTP, reset password
    doctor_app/                     # Doctor appointments and appointment details
    shared/                         # Splash, welcome, settings, legal and info screens
    user_app/                       # Patient home, doctors, centers, booking, diagnosis, diet, files

assets/
  fonts/                            # Custom app fonts
  icons/                            # App icons and medical category icons
  images/                           # Logos, doctors, centers, placeholders
  lang/                             # en.json and ar.json translation files
```

The project follows a feature-first layout. Most features are split into:

- `data/`: models, repository contracts, and repository implementations.
- `presentation/`: screens, sections, widgets, Cubits, and states.

Shared infrastructure lives under `lib/core`.

## Getting Started

### Prerequisites

Install the following tools before running the project:

- Flutter SDK compatible with Dart `^3.8.1`
- Android Studio or Xcode for mobile builds
- CocoaPods for iOS builds
- A running backend API compatible with the endpoints in `lib/core/Api_services/urls.dart`
- Firebase project configured for Android and iOS

Check your local Flutter setup:

```bash
flutter doctor
```

Install dependencies:

```bash
flutter pub get
```

## Configuration

### Backend API

The app reads API configuration from:

```text
lib/core/Api_services/urls.dart
```

By default, the backend IP is configured as:

```dart
static String ip = "192.168.1.3";
static String baseUrl = "http://$ip:";
static String basePort = "8000/api";
```

Before running the app, update `ip` to the machine or server hosting your backend API.

Examples:

- Android emulator connecting to a backend on the host machine: `10.0.2.2`
- iOS simulator connecting to a backend on the host machine: `127.0.0.1`
- Physical device on the same network: your local network IP, for example `192.168.1.10`
- Remote server: your server domain or public IP

The final API base path is built as:

```text
http://<ip>:8000/api
```

### Firebase

Firebase is initialized in `lib/main.dart` using:

```dart
DefaultFirebaseOptions.currentPlatform
```

The generated configuration file is:

```text
lib/firebase_options.dart
```

For a new Firebase project, regenerate this file with FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Make sure platform Firebase files are also present:

- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

### Launcher Icon

The app icon is configured in `pubspec.yaml` through `flutter_launcher_icons` and uses:

```text
assets/icons/appIcon.png
```

Regenerate launcher icons with:

```bash
dart run flutter_launcher_icons
```

## Run the App

List available devices:

```bash
flutter devices
```

Run on the selected device:

```bash
flutter run
```

Run on a specific device:

```bash
flutter run -d <device-id>
```

Example device IDs:

```bash
flutter run -d emulator-5554
flutter run -d "iPhone 15"
```

## Testing and Code Quality

Run static analysis:

```bash
dart analyze
```

Run tests:

```bash
flutter test
```

Format the codebase:

```bash
dart format lib test
```

## Build

Android APK:

```bash
flutter build apk --release
```

Android App Bundle:

```bash
flutter build appbundle --release
```

iOS release build:

```bash
flutter build ios --release
```

For iOS, open the project in Xcode when signing, provisioning profiles, or archive settings need to be adjusted:

```bash
open ios/Runner.xcworkspace
```

## Localization

Tabiby supports English and Arabic.

Translation files:

```text
assets/lang/en.json
assets/lang/ar.json
```

Supported locales are registered in `lib/main.dart`:

```dart
supportedLocales: const [Locale("en"), Locale("ar")]
```

The selected language is saved locally and used in API headers through:

```text
Accept-Language
```

When adding new UI text, update both language files and use the existing localization helper instead of hard-coded strings.

## Development Notes

- Dependency registration is centralized in `lib/core/utils/services_locater.dart`.
- App routes are centralized in `lib/core/utils/routs.dart`.
- API endpoints are centralized in `lib/core/Api_services/urls.dart`.
- Authenticated requests are handled by `ApiServices` and `AuthInterceptor`.
- Tokens and user preferences are stored through `CacheHelper`.
- Push notification setup is handled by `FirebaseApi` in `lib/core/notification_services/notification.dart`.
- The app uses a custom font family configured in `pubspec.yaml`.
- Keep new features aligned with the existing feature-first structure: `data`, `presentation`, Cubit/state, and reusable widgets.

## Repository Status

This repository is an active Flutter application. Before opening a pull request or delivering a build, run:

```bash
flutter pub get
dart analyze
flutter test
```

Then test the main user journeys manually on the target platforms:

- Authentication
- Home data loading
- Doctor and center browsing
- Appointment booking
- Medical file upload
- Notifications
- Doctor appointment management
- AI diagnosis and diet flows
