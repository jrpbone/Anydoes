
# Offline Flutter Personal Planner — Design Specification

Date: 2026-08-15

## 1. Product summary

Build a polished, offline-first personal planning app in Flutter. The product is inspired by the breadth of Any.do but is differentiated by duration-aware scheduling: tasks can require real amounts of time, and the app proposes calendar blocks that fit within the user's availability.

The app is intended for one primary user and their own devices. It must work without accounts, a backend, or a network connection. Phone, tablet, and desktop layouts are first-class. Data remains local to each installation, with a single portable file format for backup, restore, and sharing a selected list.

The visual direction is **Calm Sky**: airy light surfaces, blue accents, rounded cards, generous spacing, clear typography, and restrained motion.

## 2. Goals

- Make task capture fast enough for everyday use.
- Turn tasks with estimated durations into an adjustable daily or weekly plan.
- Preserve user control by previewing schedule suggestions before saving them.
- Support recurring tasks, subtasks, reminders, and organized lists.
- Demonstrate responsive Flutter design across phones, tablets, and desktop windows.
- Keep all primary features functional without a network connection.
- Provide safe data portability through one versioned `.dayplan` file format.

## 3. Non-goals

Version 1 will not include:

- User accounts or authentication
- Cloud storage or cross-device synchronization
- True multi-user or real-time collaboration
- External calendar integration
- AI or remote scheduling services
- An exact copy of Any.do branding, assets, or interface

## 4. Primary navigation and screens

The app has four primary destinations.

### 4.1 Plan

Plan is the default destination. It contains:

- A day or week calendar
- Accepted and manually created schedule blocks
- A queue of unscheduled tasks
- A **Plan my tasks** action
- A schedule-proposal state with Accept All, per-block adjustment, per-block removal, and Discard actions
- Visible warnings for tasks that cannot fit before their deadlines

### 4.2 Tasks

Tasks contains an inbox and user-created lists. It supports search, filters, tags, priorities, subtasks, recurrence, deadlines, estimated durations, assignees, and splitting controls.

Quick capture initially asks only for a title. The full editor progressively reveals optional planning fields so routine entry remains fast.

### 4.3 Profiles

Profiles represents local household members without accounts. Tasks can be assigned to a profile for organization. Only tasks assigned to **Me** or left unassigned enter the personal schedule by default. A task assigned to another profile may be added to the personal plan explicitly with an **Include in my plan** toggle.

### 4.4 Settings

Settings contains:

- Weekly availability windows
- Date-specific availability exceptions
- Default planning horizon and session length
- Local notification preferences
- Appearance and accessibility settings
- Backup, restore, list export, and list import

## 5. Responsive behavior

- **Phone:** bottom navigation; day timeline by default; unscheduled tasks appear in a drawer or sheet.
- **Tablet:** navigation rail; task queue and day/week calendar appear side by side when space permits.
- **Desktop:** persistent sidebar; full week calendar; persistent task queue; mouse drag-and-drop and resize controls.

The same domain and application behavior is used on every platform. Layout changes must not create platform-specific feature gaps.

## 6. Core domain model

### 6.1 Task

A task contains:

- Stable local identifier
- Title and optional notes
- Parent list and tags
- Optional parent task for subtasks
- Status: open, completed, or archived
- Priority: low, normal, high, or urgent
- Optional earliest start
- Optional deadline
- Estimated duration in minutes
- Remaining duration in minutes
- Whether the task may be split
- Minimum session length, defaulting to 25 minutes
- Maximum session length, defaulting to 90 minutes
- Optional recurrence rule
- Optional assignee profile
- Whether a non-primary assignee's task should enter the personal plan
- Creation, update, and completion timestamps

A task without an estimated duration remains valid but is not automatically time-blocked until the user supplies a duration.

### 6.2 Schedule block

A schedule block contains:

- Stable local identifier
- Related task identifier when task-backed
- Start and end timestamps
- State: proposed or accepted
- Lock state
- Completion state
- Optional note

Schedule blocks are stored separately from tasks. Moving or resizing a block changes the scheduled session without changing the task's original estimated duration. Completing a block reduces the task's remaining duration by that block's duration. Completing the task removes any unnecessary future blocks after confirmation.

### 6.3 Availability

Availability consists of one or more allowed windows for each weekday plus date-specific overrides. Accepted blocks, manually created fixed events, and locked blocks occupy time and cannot be displaced by automatic planning.

### 6.4 Lists, tags, profiles, and recurrence

Lists organize tasks and may have a color and icon. Tags provide cross-list filtering. Profiles are local records with a name, color, and avatar initials. Recurrence rules generate the next task occurrence only when required, maintaining a rolling 90-day display horizon without creating an unbounded number of records.

## 7. Scheduling engine

The scheduling engine is a pure, deterministic domain service. It receives tasks, accepted/fixed blocks, availability, and planning preferences, and returns a proposal plus structured conflicts. It does not write to storage.

### 7.1 Planning horizon

The default horizon is 14 days, configurable from 7 to 30 days. Planning begins at the next available five-minute boundary and never schedules outside the horizon.

### 7.2 Ranking

Eligible tasks are ordered by a balanced score made from:

- Deadline urgency: up to 50 points
- User priority: up to 30 points
- Duration pressure relative to remaining free time: up to 20 points

Higher scores schedule first. Ties resolve by earliest deadline and then oldest creation time. The proposal UI explains the dominant reason for a task's position, such as **urgent deadline** or **high priority**.

### 7.3 Placement rules

- Non-splittable tasks require one contiguous free slot equal to their remaining duration.
- Splittable tasks may use multiple sessions between their configured minimum and maximum session lengths.
- The final session may be shorter than the minimum when it completes the task.
- The engine respects earliest starts, deadlines, availability, fixed events, and locked blocks.
- Existing accepted but unlocked generated blocks may be reconsidered only when the user explicitly requests replanning.
- Manually positioned or resized blocks become locked automatically.
- The engine never silently drops work. Anything that cannot fit is returned as a conflict with the missing amount of time and a suggested recovery action.

### 7.4 Proposal workflow

1. The user selects **Plan my tasks**.
2. The engine computes a proposal without changing saved calendar data.
3. Proposed blocks appear visually distinct from accepted blocks.
4. The user may drag, resize, remove, or accept individual suggestions.
5. **Accept All** saves the remaining proposal in one transaction.
6. **Discard** removes the proposal without changing persisted data.

## 8. Reminders and task lifecycle

Accepted schedule blocks may create local notifications at their start time or a configurable offset. Deadline-only reminders remain available for unscheduled tasks.

When notification permission is unavailable, scheduling still works. The app shows a non-blocking explanation and a shortcut to the relevant system settings where supported.

Recurring tasks produce independent occurrences so completing one does not mutate historical records. Skipped blocks may be marked skipped, returned to the unscheduled queue, or moved manually. Overdue tasks stay visible and receive recovery actions: extend deadline, lower duration, make splittable, or find the next available slot.

## 9. Local data architecture

The Flutter application is organized into independently testable feature modules:

- Task management
- Calendar and planning UI
- Scheduling engine
- Lists and profiles
- Notifications
- Import/export
- Settings

Presentation code communicates with application controllers. Controllers depend on domain interfaces for repositories, scheduling, notifications, and file operations. Infrastructure adapters implement those interfaces using an embedded local database and platform services. The pure scheduling engine depends only on domain values and is isolated from Flutter widgets, storage, clocks, and notification APIs.

All multi-record mutations, including accepting proposals and restoring backups, use database transactions.

## 10. Portable `.dayplan` file

One UTF-8, versioned JSON document with the `.dayplan` extension is used for all exports. A top-level `kind` field distinguishes:

- `full_backup`
- `shared_list`

The document includes a schema version, export timestamp, originating time-zone identifier, app metadata, and payload checksum. The checksum is calculated over the canonicalized payload object, excluding the checksum field itself. Full backups contain all user data and settings. Shared-list files contain one list and its tasks, subtasks, tags, and referenced local profiles, but no unrelated calendar or settings data.

Calendar instants are serialized in UTC and rendered in the destination device's local time. Weekly availability remains a local wall-clock rule. If the exported and destination time zones differ, import shows a warning and previews the resulting calendar times before confirmation.

Import follows this sequence:

1. Read without changing local data.
2. Validate file type, checksum, schema, identifiers, dates, and references.
3. Show a summary and any name or identifier conflicts.
4. For a shared list, import as a new list with safe identifier remapping.
5. For a full backup, require the user to choose Merge or Replace. Merge retains local-only records and lets imported records win when stable identifiers match; Replace removes current app data and restores only the backup payload.
6. Apply the entire import in one transaction or make no changes.

Replace requires an additional confirmation. A corrupt, unsupported, or incomplete file produces a specific error and never partially modifies the database.

## 11. Visual and interaction design

Calm Sky uses a light neutral background, blue primary actions, soft borders and shadows, rounded cards, and high-contrast typography. Motion is brief and functional: proposal blocks settle into the calendar, completion acknowledges progress, and conflicts draw attention without disruptive animation.

All interactive controls must remain usable with touch, mouse, and keyboard. Text scaling, semantic labels, focus order, contrast, and reduced-motion preferences are part of the responsive design rather than deferred polish.

## 12. Error and recovery behavior

- Impossible schedules identify affected tasks and the amount of time that does not fit.
- Failed imports leave existing data unchanged and explain the validation failure.
- Failed exports preserve local data and allow retrying with another destination.
- Notification failures do not prevent tasks or blocks from being saved.
- Database mutations report recoverable errors and do not leave partial proposal or restore state.
- Destructive actions, including replace restore and deleting a list with tasks, require confirmation.

## 13. Verification strategy

### 13.1 Unit tests

- Ranking across deadline, priority, and duration pressure
- Contiguous placement for non-splittable tasks
- Multi-session placement for splittable tasks
- Minimum and maximum session rules
- Availability, fixed-event, and lock constraints
- Conflict reporting when work cannot fit
- Deterministic output for identical input
- Recurrence generation and task-remaining-duration calculations

### 13.2 Data and integration tests

- Repository create, update, archive, and transactional operations
- Accepting and discarding schedule proposals
- Backup export followed by full restore
- Shared-list export followed by import with identifier remapping
- Merge and replace behavior
- Corrupt checksum, invalid schema, and interrupted import handling
- Notification scheduling and permission-denied adapters

### 13.3 Interface tests

- Quick capture and expanded task editing
- Proposal preview, adjustment, acceptance, and discard
- Block drag, resize, lock, completion, skip, and reschedule
- Phone, tablet, and desktop navigation/layout breakpoints
- Keyboard and screen-reader semantics for primary workflows
- Representative Calm Sky screenshot tests

## 14. Acceptance criteria

The design is successfully implemented when:

1. A user can create a three-hour splittable task and receive multiple valid sessions within defined availability.
2. Suggested sessions never overlap fixed or locked blocks and never occur outside availability.
3. Schedule changes remain proposals until explicitly accepted.
4. Manually adjusted blocks stay fixed during later replanning.
5. Tasks that cannot fit are clearly reported with recovery options.
6. Tasks, lists, recurrence, reminders, profiles, and scheduling work without network access.
7. The primary workflows are usable on phone, tablet, and desktop layouts.
8. A full `.dayplan` backup round-trips without data loss.
9. A shared-list `.dayplan` import does not expose or alter unrelated data.
10. Invalid imports and failed scheduling operations leave saved data unchanged.
