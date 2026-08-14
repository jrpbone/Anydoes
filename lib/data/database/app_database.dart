import 'package:anydoes/data/database/database_connection.dart';
import 'package:drift/drift.dart';

part 'app_database.g.dart';

@DataClassName('TaskEntry')
class TaskEntries extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get listId => text().references(TaskListEntries, #id)();
  TextColumn get parentTaskId => text().nullable()();
  TextColumn get status => text()();
  TextColumn get priority => text()();
  IntColumn get earliestStartMicros => integer().nullable()();
  IntColumn get deadlineMicros => integer().nullable()();
  IntColumn get estimatedMinutes => integer().nullable()();
  IntColumn get remainingMinutes => integer().nullable()();
  BoolColumn get allowSplit => boolean()();
  IntColumn get minimumSessionMinutes => integer()();
  IntColumn get maximumSessionMinutes => integer()();
  TextColumn get recurrenceRuleId =>
      text().nullable().references(RecurrenceRuleEntries, #id)();
  TextColumn get recurrenceSeriesId => text().nullable()();
  IntColumn get occurrenceDateMicros => integer().nullable()();
  TextColumn get assigneeProfileId =>
      text().nullable().references(ProfileEntries, #id)();
  BoolColumn get includeInMyPlan => boolean()();
  IntColumn get createdAtMicros => integer()();
  IntColumn get updatedAtMicros => integer()();
  IntColumn get completedAtMicros => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ScheduleBlockEntry')
class ScheduleBlockEntries extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().nullable().references(TaskEntries, #id)();
  IntColumn get startMicros => integer()();
  IntColumn get endMicros => integer()();
  TextColumn get state => text()();
  BoolColumn get isLocked => boolean()();
  TextColumn get completionState => text()();
  TextColumn get note => text().nullable()();
  BoolColumn get isGenerated => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TaskListEntry')
class TaskListEntries extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get colorValue => integer()();
  IntColumn get iconCodePoint => integer()();
  BoolColumn get isInbox => boolean()();
  IntColumn get createdAtMicros => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TagEntry')
class TagEntries extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();
  IntColumn get colorValue => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TaskTagEntry')
class TaskTagEntries extends Table {
  TextColumn get taskId => text().references(TaskEntries, #id)();
  TextColumn get tagId => text().references(TagEntries, #id)();

  @override
  Set<Column<Object>> get primaryKey => {taskId, tagId};
}

@DataClassName('ProfileEntry')
class ProfileEntries extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get colorValue => integer()();
  BoolColumn get isMe => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('RecurrenceRuleEntry')
class RecurrenceRuleEntries extends Table {
  TextColumn get id => text()();
  TextColumn get frequency => text()();
  IntColumn get interval => integer()();
  TextColumn get weekdays => text()();
  IntColumn get untilDateMicros => integer().nullable()();
  IntColumn get occurrenceCount => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('WeeklyAvailabilityEntry')
class WeeklyAvailabilityEntries extends Table {
  IntColumn get weekday => integer()();
  IntColumn get startMinute => integer()();
  IntColumn get endMinute => integer()();

  @override
  Set<Column<Object>> get primaryKey => {weekday, startMinute, endMinute};
}

@DataClassName('AvailabilityExceptionEntry')
class AvailabilityExceptionEntries extends Table {
  TextColumn get date => text()();
  IntColumn get startMinute => integer().nullable()();
  IntColumn get endMinute => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {date, startMinute, endMinute};
}

@DataClassName('SettingEntry')
class SettingEntries extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    TaskEntries,
    ScheduleBlockEntries,
    TaskListEntries,
    TagEntries,
    TaskTagEntries,
    ProfileEntries,
    RecurrenceRuleEntries,
    WeeklyAvailabilityEntries,
    AvailabilityExceptionEntries,
    SettingEntries,
  ],
)
final class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openAppDatabase());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await migrator.createAll();
    },
    beforeOpen: (_) => customStatement('PRAGMA foreign_keys = ON'),
  );
}
