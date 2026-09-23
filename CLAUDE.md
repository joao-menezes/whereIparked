# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

"Onde Estacionei" ("Where did I park") — a Flutter app to save where the car was parked and find it again. Local-only (no backend), UI text in Portuguese.

**The product spec lives in `docs/spec.md` (Portuguese) — read it before implementing features.** It defines the v1 scope, business rules, packages, and the `CarLocation` data model. Key rules:
- One vehicle per user: one current spot, plus a history of the last 3 previous spots (`ParkingController.historyLimit`, persisted under a separate prefs key). A photo is deleted only when its spot drops out of the history.
- Saving a new spot while the previous one isn't `visited` requires a confirmation before overwriting.
- `visited` is set automatically by foreground geofencing (proximity to saved coords → local notification). Background geofencing is explicitly out of scope for v1.
- Denied location permission → still allow saving with photo/note only; denied camera permission → save with GPS only.
- Photos are stored in the app's documents directory, never the user's gallery.

- Dart package name: `ondeestacionei`; Android application ID / namespace: `com.joao.ondeestacionei`
- Dart SDK `^3.13.4` — the code uses dot shorthands (`.fromSeed(...)`, `mainAxisAlignment: .center`) and private initializing formals (`required this._repository`); keep that style.

## Architecture

Layout under `lib/`: `main.dart` (bootstrap/DI only) → `app.dart` (`MaterialApp`, theme) → `screens/`. Each screen gets a folder (`screens/home/`) with its own `widgets/` and `dialogs/`; `lib/widgets/` is only for widgets shared across screens. Business logic lives in `controllers/`, never in widgets. Tests mirror this layout under `test/`.

- `ParkingController` (`lib/controllers/parking_controller.dart`) is the single `ChangeNotifier` holding app state and all business rules (save/overwrite, photo cleanup, geofence). `HomeScreen` listens via `ListenableBuilder` and owns only the dialog-driven save flow (dialogs are plain `Future`-returning functions in `screens/home/dialogs/`). No state-management package.
- Plugins are wrapped in thin concrete classes under `lib/services/` (+ `lib/data/car_location_repository.dart` for `shared_preferences`). They have no abstract interfaces — tests fake them with `implements` (see `test/helpers/fakes.dart`), so any public method added to a service must also be added to its fake.
- `CarLocation.photoFileName` is a file name relative to `<documents>/photos`, resolved through `PhotoService.fileFor` — never store absolute paths (the iOS container path changes across updates).
- Geofence (`ParkingController.handlePosition`): arms only after the user moves > `armDistanceMeters` (100 m) from the car, then marks visited within `arrivalRadiusMeters` (40 m). Without arming, saving next to the car would mark it visited immediately.
- Map is `flutter_map` + OpenStreetMap tiles (no API key; attribution widget required by OSM policy). Navigation opens Google Maps/Waze via `url_launcher` universal HTTPS links.

## Commands

The Flutter SDK is at `C:\flutter` and is not on `PATH` in the shell — use `C:\flutter\bin\flutter.bat` (PowerShell) if `flutter` isn't found.

```bash
flutter pub get                                   # install dependencies
flutter run                                       # run on connected device/emulator
flutter analyze                                   # lint (flutter_lints; build/, android/, ios/, web/ are excluded)
flutter test                                      # all tests
flutter test test/controllers/parking_controller_test.dart  # single file
flutter test --plain-name "geofence"              # tests whose name contains the string
flutter build apk --debug                         # Android build
dart run flutter_native_splash:create             # regenerate native splash after editing its pubspec.yaml section
```

The splash screen is native (`flutter_native_splash`, config at the bottom of `pubspec.yaml`, logo in `assets/splash/`). Its Android `res/` and iOS `LaunchScreen` files are generated — change the config and re-run the command instead of editing them. `main.dart` keeps the splash visible until `ParkingController.load()` completes.

## Notes

- In widget tests, don't `pumpAndSettle()` while the save flow is running — the save button shows a `CircularProgressIndicator` that never settles; pump fixed durations instead.
- Android: `flutter_local_notifications` requires core library desugaring (already enabled in `android/app/build.gradle.kts`). Permissions and `<queries>` for navigation apps are in `AndroidManifest.xml`; iOS usage strings are in `ios/Runner/Info.plist`. Release builds still use the debug signing config.
- Not currently a git repository.
