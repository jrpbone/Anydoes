# Anydoes

Anydoes is an offline-first personal planner built with Flutter. It combines fast task capture with duration-aware scheduling: tasks can carry real time estimates, availability rules, deadlines, priorities, recurrence, assignees, and split-session limits, then become an editable schedule proposal that is saved only after acceptance.

The v1 interface uses the responsive Calm Sky design across phone, tablet, and desktop layouts. All user data stays on the current installation unless the user explicitly exports a `.dayplan` file.

## V1 features

- Inbox, custom lists, tags, profiles, subtasks, search, combined filters, priorities, dates, recurrence, duration estimates, and title-only quick capture
- Deterministic 50/30/20 deadline/priority/duration scheduling within weekly availability and date exceptions
- Day and week planning views, fixed events, conflicts with recovery actions, ephemeral proposals, per-block acceptance/removal, pointer move/resize, locking, completion, skipping, and transactional replanning
- Rolling, bounded 90-day recurring occurrences
- Local reminders for accepted blocks and deadline-only tasks
- Light/dark themes, high contrast, reduced motion, keyboard navigation, screen-reader semantics, and 200% text support
- Versioned, checksummed `.dayplan` backup/restore and isolated shared-list import/export

## Supported targets

This repository contains Flutter runners for Android, web, Windows, Linux, and macOS. iOS is not configured in this checkout. The shared domain, storage, and interface test suite is platform-independent; native packaging still requires each platform's Flutter toolchain.

Local notifications are best-effort and depend on platform support and user permission. Permission denial or an unavailable plugin never prevents tasks or schedule blocks from being saved. Web builds retain planner functionality, but system notification availability depends on the browser/plugin implementation.

## Setup and run

Install a Flutter SDK compatible with Dart 3.12, then run:

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Choose a target with `flutter devices`, then use `flutter run -d <device-id>` when more than one device is available.

Common builds:

```powershell
flutter build apk
flutter build web
flutter build windows
```

Windows builds require the Visual Studio Desktop development with C++ workload. Linux and macOS builds require their standard Flutter desktop toolchains.

## Quality checks

```powershell
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter test test/goldens/calm_sky_golden_test.dart
```

Drift generated code is committed. After changing a table or generated query, rerun:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

## Local data and reminders

The Drift database is named `anydoes` and is stored in the platform-managed application data location. On web it uses browser-managed local storage. Exact native paths vary by operating system and install packaging. Clearing browser/app data or uninstalling the app may delete the database, so export a full backup first when the data matters.

Reminder times are calculated from stored UTC instants and converted through the device's current named time zone. Enable reminders in Settings and grant the platform permission when prompted. If permission is denied, Anydoes shows a non-blocking explanation and, where supported, can open system settings.

## `.dayplan` portability

Settings → Data portability provides these workflows:

- **Export full backup** writes all planner records and settings.
- **Restore backup** validates first, shows a preview, and offers Merge or Replace. Replace requires an additional confirmation.
- **Export selected list** is available from Tasks when a list is selected.
- **Import list** creates a new list with safely remapped identifiers and excludes unrelated calendar/settings data.

Every `.dayplan` file is UTF-8 JSON with a schema version, kind (`full_backup` or `shared_list`), source time zone, metadata, and SHA-256 checksum over the canonical payload. Imports reject corrupt, unsupported, incomplete, or referentially invalid documents before any database write.

## Architecture

Riverpod controllers coordinate feature modules over domain repository interfaces. Drift implements transactional local persistence. Scheduling, recurrence, canonical JSON, and import validation are pure Dart services. Platform adapters handle files, time zones, and local notifications without introducing a backend or account dependency.

See [the v1 acceptance evidence](docs/verification/anydoes-v1-acceptance.md) for the criterion-by-criterion verification matrix and current platform build status.
