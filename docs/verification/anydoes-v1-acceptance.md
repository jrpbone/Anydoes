# Anydoes v1 acceptance verification

Date: 2026-08-15

This document maps the ten acceptance criteria in `Design Specification.md` to reproducible automated evidence. The tests use fixed clocks, deterministic in-memory databases, fake platform gateways, and no backend or account service.

## Repository quality gates

| Gate | Result | Evidence |
| --- | --- | --- |
| Dart formatting | Pass | `dart format --output=none --set-exit-if-changed lib test` exits 0. |
| Static analysis | Pass | `flutter analyze` reports `No issues found!`. |
| Complete automated suite | Pass | `flutter test` completes 93 tests with zero failures, including seven visual baselines. Drift emits expected debug-only multiple-instance warnings in tests that intentionally open separate in-memory source/destination databases. |
| Web debug compilation | Pass | `flutter build web --debug` exits 0 and produces `build/web`; its Wasm dry run also succeeds. |
| Windows debug compilation | Environment blocked | `flutter build windows --debug` reports: `Unable to find suitable Visual Studio toolchain. Please run flutter doctor for more details.` No Windows-build success is claimed. Install Visual Studio with Desktop development with C++ and rerun the command. |
| Drift generation | Pass | `dart run build_runner build --delete-conflicting-outputs` leaves generated sources current. |

## Acceptance matrix

| # | Criterion | Automated evidence |
| --- | --- | --- |
| 1 | A three-hour splittable task receives multiple valid sessions within availability. | `test/domain/scheduling/scheduling_engine_test.dart` — **splits three hours into legal sessions totaling the task duration** verifies 180 minutes across two sessions, each at most 90 minutes. |
| 2 | Suggestions never overlap fixed/locked blocks or leave availability. | `scheduling_engine_test.dart` — **respects earliest start, deadline, availability, and locked blocks**; `test/domain/scheduling/free_interval_finder_test.dart` — **subtracts occupied blocks from availability in chronological order** and **a date exception replaces the weekly rule**. |
| 3 | Schedule changes remain proposals until explicitly accepted. | `test/features/plan/plan_controller_test.dart` — **creating and discarding a proposal never writes schedule blocks**, **moving and resizing a proposal stays ephemeral and locks it**, and **accept all persists accepted blocks in one action and clears proposal**; `plan_screen_test.dart` — **proposal is visibly distinct and remains optional until accepted**. |
| 4 | Manually adjusted blocks remain fixed during replanning. | `plan_controller_test.dart` — **moving and resizing a proposal stays ephemeral and locks it** and **accepted replan atomically removes obsolete generated sessions**; `scheduling_engine_test.dart` — **explicit replan can reconsider unlocked generated accepted blocks** proves the unlocked/locked distinction. |
| 5 | Work that cannot fit is reported with recovery options. | `plan_screen_test.dart` — **impossible work displays missing time and recovery actions**; `scheduling_engine_test.dart` — **non-splittable work needs one contiguous interval** verifies exact missing minutes and a structured recovery action. |
| 6 | Tasks, lists, recurrence, reminders, profiles, and scheduling work offline. | Task/profile widget suites exercise local CRUD; `test/domain/recurrence/recurrence_engine_test.dart` and `tasks_screen_test.dart` verify bounded rolling occurrences; `test/data/notifications/notification_reconciler_test.dart` uses a local fake gateway and verifies permission-denied resilience. Source/dependency inspection confirms no HTTP client, account, backend, or remote scheduler. |
| 7 | Primary workflows work at phone, tablet, and desktop sizes. | `test/responsive/responsive_workflows_test.dart` runs create → plan → accept → complete at 390, 800, and 1440 px; `plan_screen_test.dart` verifies the compact queue sheet, medium split view, expanded seven-day week, manual event creation, and pointer move/resize. |
| 8 | A full `.dayplan` backup round-trips without data loss. | `test/features/settings/backup_controller_test.dart` — **full backup export and replace restore round-trip user data**; codec tests verify deterministic canonical payload/checksum coverage. |
| 9 | Shared-list import does not expose or alter unrelated data. | `backup_controller_test.dart` — **shared list import remaps ids and leaves unrelated data untouched**; codec/validator tests verify shared payload isolation and complete identifier remapping. |
| 10 | Invalid imports and failed scheduling operations leave saved data unchanged. | `backup_controller_test.dart` — **cancelled picker and corrupt source never mutate local data** and **failed transactional apply retains preview and reports recovery**; `plan_controller_test.dart` verifies discard and invalid overlap behavior without persistence. |

## Additional v1 checks

- Task UI: title-only quick capture; task editing; dates; subtasks; duration/split limits; assignees; tags; priority; full recurrence interval/weekday/end controls; combined filters; completion confirmation with future-block cleanup.
- Plan UI: day/week responsive views; manual fixed events; proposal labels/reasons; accept all/individual; discard/remove; pointer and dialog move/resize; lock state; skip/complete; exact conflicts and recovery actions.
- Recurrence: app startup and task create/edit invoke the rolling materializer, capped at 90 days and idempotent.
- Transactions: proposal replacement, full restore, merge, shared import, list deletion, block completion, and task completion are database transactions where multiple records change.
- Import safety: checksum, schema, kinds, timestamps, identifiers, duplicates, references, cycles, recurrence values, required Inbox, and exactly one required Me profile validate before writes.
- Accessibility/visuals: primary icon semantics, 48 px targets, keyboard focus, 200% text, reduced motion, high contrast, three adaptive navigation modes, and seven Calm Sky golden baselines are covered.

## Reproduction commands

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web --debug
flutter build windows --debug
```

Focused acceptance run:

```powershell
flutter test test/domain/scheduling test/features/plan test/features/tasks test/features/settings/backup_controller_test.dart test/data/notifications test/responsive
```
