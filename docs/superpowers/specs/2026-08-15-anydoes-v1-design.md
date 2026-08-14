# Anydoes V1 Implementation Design

Date: 2026-08-15
Status: Approved for planning
Source: `Design Specification.md`

## Objective

Build the complete offline-first Anydoes v1 Flutter application described in the product specification. The application must remain useful without a network connection, support phone, tablet, and desktop layouts, and keep all persistent data local to the installation.

The implementation will prioritize deterministic scheduling, explicit proposal acceptance, reliable transactional persistence, portable `.dayplan` files, and accessible responsive interfaces. Cloud synchronization, accounts, external calendars, remote AI, and multi-user collaboration remain out of scope.

## Technology and architecture

The project will use a feature-first Flutter architecture with four layers:

1. Presentation widgets render immutable view state and forward user intent.
2. Riverpod controllers coordinate workflows and expose view state.
3. Pure Dart domain services contain scheduling, recurrence, validation, and import/export rules.
4. Drift repositories and platform adapters provide local persistence, notifications, and file access.

Dependencies point inward. Widgets do not issue SQL, domain services do not import Flutter, and persistence code does not decide presentation behavior. Domain values and repository interfaces provide the boundaries between layers.

The app will use Material 3 and a centralized Calm Sky design system. Navigation is state-preserving and adaptive rather than implemented as separate platform applications.

## Project organization

The `lib` directory will be organized as follows:

- `app/`: bootstrap, theme, navigation shell, responsive breakpoints, and dependency providers.
- `core/`: shared identifiers, clocks, results/failures, serialization helpers, date utilities, and reusable UI primitives.
- `domain/`: entities, value objects, repository contracts, scheduling engine, recurrence engine, and portable-file schema.
- `data/`: Drift tables, database migrations, repository implementations, transactions, and platform adapters.
- `features/plan/`: calendar, queue, proposals, conflicts, block manipulation, and planning controller.
- `features/tasks/`: inbox, lists, search/filtering, quick capture, full editor, subtasks, and task controller.
- `features/profiles/`: local household profiles and assignment controls.
- `features/settings/`: availability, planning preferences, notifications, appearance, accessibility, backup, and restore.

Large features will be divided into focused controller, screen, widget, and model files. Shared domain rules will not be duplicated between layouts.

## Domain model

The persistent model follows the supplied product specification and includes tasks, schedule blocks, availability windows and exceptions, lists, tags, task-tag links, profiles, recurrence rules, settings, and migration metadata.

Identifiers are locally generated stable strings. Persisted timestamps that represent instants use UTC. Weekly availability stores weekday plus local wall-clock minutes. Date-specific exceptions store a local calendar date and replacement windows.

Task remaining duration is stored to preserve completion progress. It is initially equal to the estimated duration and is reduced by completed task-backed blocks. Updating an estimate never silently invalidates completed work. Tasks without an estimate remain valid but are excluded from automatic placement.

Recurrence rules support daily, weekly, monthly, and yearly frequencies with an interval, optional selected weekdays, optional end date, and optional occurrence count. Independent occurrences retain a reference to the recurrence series. The recurrence engine materializes only enough records to cover a rolling 90-day display horizon.

Schedule blocks are separate records. A block may be task-backed or a fixed manual event. Dragging or resizing a block locks it. Proposed blocks are ephemeral controller state until accepted; only accepted blocks are persisted.

## Persistence and transactions

Drift will provide the embedded database and migrations. Repository interfaces expose domain objects rather than database rows. Database initialization will create the default Inbox list, the `Me` profile, default availability, and default planning settings in one transaction.

The following operations are atomic:

- accepting one or all proposal blocks;
- completing a block and reducing task remaining duration;
- completing a task and removing confirmed unnecessary future blocks;
- importing a shared list;
- merging a full backup;
- replacing all data from a full backup;
- deleting a list and applying the user's selected task disposition.

The repository layer will surface typed failures. Controllers retain the last valid view state and show actionable messages when a mutation fails.

## Scheduling engine

The scheduling engine is a synchronous, pure Dart service. Its complete input contains:

- the planning instant and local time-zone context;
- eligible tasks and their remaining durations;
- accepted blocks, fixed events, and locks;
- weekly availability and date overrides;
- the 7-to-30-day horizon;
- default and per-task session constraints;
- whether an explicit replan permits reconsidering accepted, unlocked generated blocks.

Planning starts at the next five-minute boundary. Free intervals are calculated by intersecting availability with the horizon and subtracting occupied intervals. Tasks assigned to `Me`, unassigned tasks, and explicitly included non-primary tasks are eligible when open, estimated, inside their earliest-start constraint, and not already fully allocated.

Ranking uses the specified 50/30/20 weighted score. Deadline urgency increases as remaining time shrinks. Priority maps monotonically from low through urgent. Duration pressure compares remaining work with eligible free time before the task deadline. Ties use earliest deadline and then oldest creation time. Each result includes a dominant ranking reason for the interface.

Non-splittable tasks require one interval large enough for all remaining work. Splittable tasks are placed in sessions no longer than their maximum. Sessions meet the minimum except for the final session that completes the task. The output contains proposed blocks and structured conflicts with the unscheduled minutes and recovery actions. Identical ordered input produces identical output.

Proposal edits remain in controller memory. Accepting writes the current proposal in one transaction. Discarding clears it. Manual movement or resizing validates availability and overlap before updating the proposal or persisted block.

## Responsive interface

The application uses these layout classes:

- Compact, below 600 logical pixels: bottom navigation, day plan, and task queue sheet.
- Medium, 600 through 1023 logical pixels: navigation rail with side-by-side content when space permits.
- Expanded, 1024 logical pixels and above: persistent sidebar, week calendar, and persistent task queue.

All four destinations preserve their controller state while navigating. Phone, tablet, and desktop use the same commands and repository behavior.

The Plan screen provides day/week switching where space allows, previous/today/next controls, accepted and proposed block styling, an unscheduled queue, conflict cards, and proposal actions. Pointer devices gain drag and resize affordances; touch and keyboard users receive equivalent move and duration controls in a block editor.

The Tasks screen provides immediate title-only capture followed by optional full editing. Search and filters apply to status, list, tags, priority, assignee, and scheduling state. Subtasks use the same task model and prevent cyclic parent relationships.

Profiles manages local names, colors, and initials. The primary `Me` profile cannot be deleted. Settings manages availability, date exceptions, planning defaults, notifications, appearance, accessibility, and data portability.

## Calm Sky design system

Calm Sky uses a pale neutral-blue background, white and lightly tinted surfaces, a clear blue primary action, restrained semantic colors, rounded cards, soft borders, and minimal shadows. Typography uses the platform's readable sans-serif family with a strong hierarchy and generous line height.

Spacing, radii, colors, durations, and breakpoints are centralized tokens. Animations are brief and functional and are disabled or reduced when requested by platform accessibility settings. Proposed blocks use tint, border treatment, and labeling rather than color alone.

All actions have semantic labels and visible focus indicators. Tap targets meet Material accessibility guidance. Keyboard traversal follows visual order. The layouts tolerate large text without hiding primary actions.

## Notifications

Accepted blocks and deadline-only tasks may request local notifications through a notification gateway. Permission checks and platform support are adapter concerns. A denied or unavailable permission returns a non-blocking typed result; it never rolls back the task or schedule block.

Notification records are reconciled after relevant database transactions. Changing or deleting a block cancels its prior notification identifier. Tests use an in-memory notification adapter.

## `.dayplan` import and export

Both full backups and shared lists use one UTF-8 JSON envelope with `.dayplan` extension. The envelope contains schema version, kind, export timestamp, source time-zone identifier, app metadata, a canonical payload, and a SHA-256 checksum of that payload.

Canonical JSON recursively sorts object keys while preserving list order and uses deterministic primitive encoding. Export reads a consistent database snapshot. File destination failures do not alter database state.

Import has separate parse, validate, preview, and apply phases. Validation rejects unsupported versions, invalid checksums, duplicate identifiers, malformed dates, invalid durations, missing references, cyclic subtasks, and recurrence errors. No write occurs before confirmation.

Shared-list import always creates a new list and remaps every imported identifier. Referenced profiles are reused only when the user explicitly maps them during preview; otherwise they are imported with safe identifiers. Full-backup merge retains local-only records and lets imported records win on matching stable identifiers. Replace requires a second confirmation and swaps all app records in a single transaction. Time-zone differences always produce a preview warning for instant-based schedule data.

## Error and recovery behavior

Expected failures are typed by domain: validation, scheduling conflict, persistence, notification, permission, file access, checksum, schema version, and reference integrity. User-facing messages state what failed, what remained unchanged, and the next available action.

The application never converts an impossible scheduling result into a generic exception. Conflicts remain part of the successful proposal result. Imports, restores, and proposal acceptance are all-or-nothing. Destructive actions require confirmation and name the affected records.

Unexpected errors are caught at controller boundaries, logged locally without private task contents, and presented as recoverable interface state.

## Verification strategy

Development will follow test-driven vertical slices.

Pure unit tests cover identifiers, duration accounting, ranking, free-interval calculation, split and contiguous placement, locks, deadlines, recurrence, canonical JSON, checksums, and import validation. Repository tests use a temporary database and verify migrations and transaction rollback. Controller tests use repository and platform fakes. Widget tests cover the primary compact, medium, and expanded workflows, keyboard traversal, semantics, text scaling, and proposal styling.

Golden tests cover representative Calm Sky screens at the three layout classes. Platform adapters receive smoke tests where the host supports them. The final verification gate runs formatting, static analysis, unit and widget tests, and a debug Windows build in this workspace. Other platform source configurations will be validated statically when their native toolchains are unavailable.

## Delivery sequence

Implementation will proceed in runnable vertical slices:

1. Foundation: dependencies, design system, adaptive shell, database, and core domain values.
2. Tasks: lists, tags, profiles, quick capture, editing, filtering, subtasks, and recurrence.
3. Scheduling: availability, engine, proposal workflow, conflicts, and duration accounting.
4. Plan interaction: calendar layouts, queue, block editing, locking, completion, skip, and reschedule.
5. Settings and platform services: notifications, appearance, accessibility, and date exceptions.
6. Portability: full backup, shared list, preview, merge, replace, and failure handling.
7. Quality pass: responsive refinement, semantics, keyboard behavior, motion, golden coverage, and build verification.

Each slice must leave the application analyzable and testable. Later slices may extend schemas only through explicit migrations.

## Acceptance

The implementation is complete only when all ten acceptance criteria in `Design Specification.md` are demonstrably satisfied and the verification gate passes. A polished mock interface without persistence, transactionality, scheduling correctness, or import/export safety does not qualify as v1 completion.
