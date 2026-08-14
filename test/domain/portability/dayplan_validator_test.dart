import 'dart:convert';

import 'package:anydoes/domain/portability/canonical_json.dart';
import 'package:anydoes/domain/portability/dayplan_codec.dart';
import 'package:anydoes/domain/portability/dayplan_document.dart';
import 'package:anydoes/domain/portability/dayplan_validator.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dayplan_codec_test.dart' show fixtureSnapshot;

void main() {
  const codec = DayplanCodec();
  const validator = DayplanValidator(destinationTimeZone: 'UTC');
  late String valid;

  setUp(() {
    valid = codec.encode(
      kind: DayplanKind.fullBackup,
      snapshot: fixtureSnapshot(),
      metadata: DayplanMetadata(
        exportedAt: DateTime.utc(2026, 8, 15),
        sourceTimeZone: 'Asia/Manila',
        appVersion: '1.0.0',
        platform: 'windows',
      ),
    );
  });

  test(
    'valid backup previews counts, collisions, modes, and timezone warning',
    () {
      final result = validator.validate(codec.decode(valid), fixtureSnapshot());

      expect(result.isValid, isTrue);
      expect(result.preview!.counts.tasks, 2);
      expect(result.preview!.collisions, isNotEmpty);
      expect(result.preview!.allowedModes, containsAll(['merge', 'replace']));
      expect(result.preview!.warnings.single, contains('Asia/Manila'));
    },
  );

  test(
    'shared list preview remaps every identifier and preserves references',
    () {
      final shared = codec.encode(
        kind: DayplanKind.sharedList,
        snapshot: fixtureSnapshot(),
        metadata: DayplanMetadata(
          exportedAt: DateTime.utc(2026, 8, 15),
          sourceTimeZone: 'UTC',
          appVersion: '1.0.0',
          platform: 'android',
          sharedListId: 'work',
        ),
      );

      final result = validator.validate(
        codec.decode(shared),
        fixtureSnapshot(),
      );
      final preview = result.preview!;
      final importedTask = preview.snapshot.tasks.single;

      expect(result.isValid, isTrue);
      expect(preview.allowedModes, ['import']);
      expect(preview.idMaps['lists']!['work'], isNot('work'));
      expect(preview.idMaps['tasks']!['task-work'], isNot('task-work'));
      expect(importedTask.listId, preview.snapshot.lists.single.id);
      expect(importedTask.tagIds.single, preview.snapshot.tags.single.id);
      expect(
        importedTask.assigneeProfileId,
        preview.snapshot.profiles.single.id,
      );
      expect(preview.snapshot.blocks, isEmpty);
    },
  );

  test('rejects bad checksum and unsupported schema', () {
    final checksum = jsonDecode(valid) as Map<String, Object?>;
    checksum['checksum'] = '0' * 64;
    expect(
      validator
          .validate(codec.decode(jsonEncode(checksum)), fixtureSnapshot())
          .errors
          .single
          .code,
      DayplanValidationCode.checksum,
    );

    final schema = jsonDecode(valid) as Map<String, Object?>;
    schema['schemaVersion'] = 99;
    expect(
      validator
          .validate(codec.decode(jsonEncode(schema)), fixtureSnapshot())
          .errors
          .any((error) => error.code == DayplanValidationCode.schema),
      isTrue,
    );
  });

  test('rejects duplicate ids, missing references, and task cycles', () {
    final duplicate = _mutate(valid, (payload) {
      final tasks = payload['tasks'] as List<Object?>;
      tasks.add(Map<String, Object?>.from(tasks.first! as Map));
    });
    expect(
      validator
          .validate(codec.decode(duplicate), fixtureSnapshot())
          .errors
          .any((error) => error.code == DayplanValidationCode.duplicateId),
      isTrue,
    );

    final missing = _mutate(valid, (payload) {
      final task = (payload['tasks'] as List).first as Map<String, Object?>;
      task['listId'] = 'missing-list';
    });
    expect(
      validator
          .validate(codec.decode(missing), fixtureSnapshot())
          .errors
          .any((error) => error.code == DayplanValidationCode.reference),
      isTrue,
    );

    final cycle = _mutate(valid, (payload) {
      final tasks = payload['tasks'] as List;
      (tasks[0] as Map<String, Object?>)['parentTaskId'] =
          (tasks[1] as Map<String, Object?>)['id'];
      (tasks[1] as Map<String, Object?>)['parentTaskId'] =
          (tasks[0] as Map<String, Object?>)['id'];
    });
    expect(
      validator
          .validate(codec.decode(cycle), fixtureSnapshot())
          .errors
          .any((error) => error.code == DayplanValidationCode.taskCycle),
      isTrue,
    );
  });

  test(
    'rejects malformed timestamps, durations, recurrence, and omissions',
    () {
      final timestamp = _mutate(valid, (payload) {
        final task = (payload['tasks'] as List).first as Map<String, Object?>;
        task['createdAt'] = 'tomorrow';
      });
      expect(
        validator
            .validate(codec.decode(timestamp), fixtureSnapshot())
            .errors
            .any((error) => error.code == DayplanValidationCode.timestamp),
        isTrue,
      );

      final duration = _mutate(valid, (payload) {
        final task = (payload['tasks'] as List).first as Map<String, Object?>;
        task['estimatedMinutes'] = -5;
      });
      expect(
        validator
            .validate(codec.decode(duration), fixtureSnapshot())
            .errors
            .any((error) => error.code == DayplanValidationCode.value),
        isTrue,
      );

      final recurrence = _mutate(valid, (payload) {
        payload['recurrenceRules'] = [
          {
            'id': 'bad-rule',
            'frequency': 'weekly',
            'interval': 0,
            'weekdays': [9],
            'until': null,
            'occurrenceCount': null,
          },
        ];
      });
      expect(
        validator
            .validate(codec.decode(recurrence), fixtureSnapshot())
            .errors
            .any((error) => error.code == DayplanValidationCode.recurrence),
        isTrue,
      );

      final incomplete = _mutate(valid, (payload) => payload.remove('lists'));
      expect(
        validator
            .validate(codec.decode(incomplete), fixtureSnapshot())
            .errors
            .any((error) => error.code == DayplanValidationCode.incomplete),
        isTrue,
      );
    },
  );
}

String _mutate(
  String source,
  void Function(Map<String, Object?> payload) mutation,
) {
  final map = Map<String, Object?>.from(jsonDecode(source) as Map);
  final payload = Map<String, Object?>.from(map['payload']! as Map);
  map['payload'] = payload;
  mutation(payload);
  map['checksum'] = sha256
      .convert(utf8.encode(CanonicalJson.encode(payload)))
      .toString();
  return jsonEncode(map);
}
