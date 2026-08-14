import 'package:anydoes/domain/models/availability.dart';
import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/planning_preferences.dart';
import 'package:anydoes/domain/models/profile.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/tag.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/models/task_list.dart';
import 'package:anydoes/domain/portability/canonical_json.dart';
import 'package:anydoes/domain/portability/dayplan_codec.dart';
import 'package:anydoes/domain/portability/dayplan_document.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const codec = DayplanCodec();
  final exportedAt = DateTime.utc(2026, 8, 15, 12, 30);

  test('canonical JSON recursively sorts keys and preserves array order', () {
    expect(
      CanonicalJson.encode({
        'z': 1,
        'a': {'b': 2, 'a': 1},
        'items': [
          {'z': 2, 'a': 1},
          3,
        ],
      }),
      '{"a":{"a":1,"b":2},"items":[{"a":1,"z":2},3],"z":1}',
    );
    expect(() => CanonicalJson.encode(DateTime.now()), throwsArgumentError);
  });

  test('full backup is stable, checksummed, UTC, and lossless', () {
    final snapshot = fixtureSnapshot();
    final metadata = DayplanMetadata(
      exportedAt: exportedAt,
      sourceTimeZone: 'Asia/Manila',
      appVersion: '1.0.0',
      platform: 'windows',
    );

    final first = codec.encode(
      kind: DayplanKind.fullBackup,
      snapshot: snapshot,
      metadata: metadata,
    );
    final second = codec.encode(
      kind: DayplanKind.fullBackup,
      snapshot: snapshot,
      metadata: metadata,
    );
    final document = codec.decode(first);

    expect(second, first);
    expect(document.schemaVersion, 1);
    expect(document.kind, DayplanKind.fullBackup);
    expect(document.sourceTimeZone, 'Asia/Manila');
    expect(document.checksum, matches(RegExp(r'^[a-f0-9]{64}$')));
    expect(document.hasValidChecksum, isTrue);
    expect(
      document.payload.keys,
      containsAll([
        'tasks',
        'blocks',
        'lists',
        'tags',
        'profiles',
        'recurrenceRules',
        'weeklyAvailability',
        'availabilityExceptions',
        'preferences',
      ]),
    );
    expect(first, contains('2026-08-16T02:00:00.000Z'));
  });

  test('shared list contains only its dependency closure', () {
    final source = fixtureSnapshot();
    final encoded = codec.encode(
      kind: DayplanKind.sharedList,
      snapshot: source,
      metadata: DayplanMetadata(
        exportedAt: exportedAt,
        sourceTimeZone: 'Asia/Manila',
        appVersion: '1.0.0',
        platform: 'android',
        sharedListId: 'work',
      ),
    );
    final payload = codec.decode(encoded).payload;

    expect((payload['lists'] as List), hasLength(1));
    expect((payload['tasks'] as List), hasLength(1));
    expect((payload['profiles'] as List), hasLength(1));
    expect((payload['tags'] as List), hasLength(1));
    expect(payload, isNot(contains('blocks')));
    expect(payload, isNot(contains('preferences')));
    expect(payload, isNot(contains('weeklyAvailability')));
    expect(encoded, isNot(contains('Private errand')));
  });
}

PlannerSnapshot fixtureSnapshot() {
  final created = DateTime.utc(2026, 8, 15, 8);
  final workTask = PlannerTask.create(
    id: 'task-work',
    title: 'Write report',
    listId: 'work',
    createdAt: created,
    deadline: DateTime.utc(2026, 8, 16, 2),
    estimatedMinutes: 90,
    assigneeProfileId: 'alex',
    tagIds: const {'focus'},
  );
  return PlannerSnapshot(
    lists: [
      TaskList(id: 'inbox', name: 'Inbox', createdAt: created, isInbox: true),
      TaskList(id: 'work', name: 'Work', createdAt: created),
      TaskList(id: 'private', name: 'Private', createdAt: created),
    ],
    tasks: [
      workTask,
      PlannerTask.create(
        id: 'task-private',
        title: 'Private errand',
        listId: 'private',
        createdAt: created,
      ),
    ],
    blocks: [
      ScheduleBlock(
        id: 'block-work',
        taskId: workTask.id,
        start: DateTime.utc(2026, 8, 15, 23),
        end: DateTime.utc(2026, 8, 16),
      ),
    ],
    tags: [TaskTag(id: 'focus', name: 'Focus')],
    profiles: [
      LocalProfile(id: 'me', name: 'Me', isMe: true),
      LocalProfile(id: 'alex', name: 'Alex'),
    ],
    weeklyAvailability: [
      AvailabilityWindow(
        weekday: DateTime.monday,
        startMinute: 540,
        endMinute: 1020,
      ),
    ],
    preferences: PlanningPreferences(
      horizonDays: 21,
      themeMode: AppThemeMode.dark,
      reduceMotion: true,
    ),
  );
}
