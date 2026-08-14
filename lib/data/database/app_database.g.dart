// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TaskListEntriesTable extends TaskListEntries
    with TableInfo<$TaskListEntriesTable, TaskListEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskListEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconCodePointMeta = const VerificationMeta(
    'iconCodePoint',
  );
  @override
  late final GeneratedColumn<int> iconCodePoint = GeneratedColumn<int>(
    'icon_code_point',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isInboxMeta = const VerificationMeta(
    'isInbox',
  );
  @override
  late final GeneratedColumn<bool> isInbox = GeneratedColumn<bool>(
    'is_inbox',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_inbox" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMicrosMeta = const VerificationMeta(
    'createdAtMicros',
  );
  @override
  late final GeneratedColumn<int> createdAtMicros = GeneratedColumn<int>(
    'created_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    colorValue,
    iconCodePoint,
    isInbox,
    createdAtMicros,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_list_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskListEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('icon_code_point')) {
      context.handle(
        _iconCodePointMeta,
        iconCodePoint.isAcceptableOrUnknown(
          data['icon_code_point']!,
          _iconCodePointMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_iconCodePointMeta);
    }
    if (data.containsKey('is_inbox')) {
      context.handle(
        _isInboxMeta,
        isInbox.isAcceptableOrUnknown(data['is_inbox']!, _isInboxMeta),
      );
    } else if (isInserting) {
      context.missing(_isInboxMeta);
    }
    if (data.containsKey('created_at_micros')) {
      context.handle(
        _createdAtMicrosMeta,
        createdAtMicros.isAcceptableOrUnknown(
          data['created_at_micros']!,
          _createdAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMicrosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskListEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskListEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      iconCodePoint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon_code_point'],
      )!,
      isInbox: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_inbox'],
      )!,
      createdAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_micros'],
      )!,
    );
  }

  @override
  $TaskListEntriesTable createAlias(String alias) {
    return $TaskListEntriesTable(attachedDatabase, alias);
  }
}

class TaskListEntry extends DataClass implements Insertable<TaskListEntry> {
  final String id;
  final String name;
  final int colorValue;
  final int iconCodePoint;
  final bool isInbox;
  final int createdAtMicros;
  const TaskListEntry({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.iconCodePoint,
    required this.isInbox,
    required this.createdAtMicros,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color_value'] = Variable<int>(colorValue);
    map['icon_code_point'] = Variable<int>(iconCodePoint);
    map['is_inbox'] = Variable<bool>(isInbox);
    map['created_at_micros'] = Variable<int>(createdAtMicros);
    return map;
  }

  TaskListEntriesCompanion toCompanion(bool nullToAbsent) {
    return TaskListEntriesCompanion(
      id: Value(id),
      name: Value(name),
      colorValue: Value(colorValue),
      iconCodePoint: Value(iconCodePoint),
      isInbox: Value(isInbox),
      createdAtMicros: Value(createdAtMicros),
    );
  }

  factory TaskListEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskListEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      iconCodePoint: serializer.fromJson<int>(json['iconCodePoint']),
      isInbox: serializer.fromJson<bool>(json['isInbox']),
      createdAtMicros: serializer.fromJson<int>(json['createdAtMicros']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'colorValue': serializer.toJson<int>(colorValue),
      'iconCodePoint': serializer.toJson<int>(iconCodePoint),
      'isInbox': serializer.toJson<bool>(isInbox),
      'createdAtMicros': serializer.toJson<int>(createdAtMicros),
    };
  }

  TaskListEntry copyWith({
    String? id,
    String? name,
    int? colorValue,
    int? iconCodePoint,
    bool? isInbox,
    int? createdAtMicros,
  }) => TaskListEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    colorValue: colorValue ?? this.colorValue,
    iconCodePoint: iconCodePoint ?? this.iconCodePoint,
    isInbox: isInbox ?? this.isInbox,
    createdAtMicros: createdAtMicros ?? this.createdAtMicros,
  );
  TaskListEntry copyWithCompanion(TaskListEntriesCompanion data) {
    return TaskListEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      iconCodePoint: data.iconCodePoint.present
          ? data.iconCodePoint.value
          : this.iconCodePoint,
      isInbox: data.isInbox.present ? data.isInbox.value : this.isInbox,
      createdAtMicros: data.createdAtMicros.present
          ? data.createdAtMicros.value
          : this.createdAtMicros,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskListEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('isInbox: $isInbox, ')
          ..write('createdAtMicros: $createdAtMicros')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    colorValue,
    iconCodePoint,
    isInbox,
    createdAtMicros,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskListEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorValue == this.colorValue &&
          other.iconCodePoint == this.iconCodePoint &&
          other.isInbox == this.isInbox &&
          other.createdAtMicros == this.createdAtMicros);
}

class TaskListEntriesCompanion extends UpdateCompanion<TaskListEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> colorValue;
  final Value<int> iconCodePoint;
  final Value<bool> isInbox;
  final Value<int> createdAtMicros;
  final Value<int> rowid;
  const TaskListEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.isInbox = const Value.absent(),
    this.createdAtMicros = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskListEntriesCompanion.insert({
    required String id,
    required String name,
    required int colorValue,
    required int iconCodePoint,
    required bool isInbox,
    required int createdAtMicros,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       colorValue = Value(colorValue),
       iconCodePoint = Value(iconCodePoint),
       isInbox = Value(isInbox),
       createdAtMicros = Value(createdAtMicros);
  static Insertable<TaskListEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? colorValue,
    Expression<int>? iconCodePoint,
    Expression<bool>? isInbox,
    Expression<int>? createdAtMicros,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorValue != null) 'color_value': colorValue,
      if (iconCodePoint != null) 'icon_code_point': iconCodePoint,
      if (isInbox != null) 'is_inbox': isInbox,
      if (createdAtMicros != null) 'created_at_micros': createdAtMicros,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskListEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? colorValue,
    Value<int>? iconCodePoint,
    Value<bool>? isInbox,
    Value<int>? createdAtMicros,
    Value<int>? rowid,
  }) {
    return TaskListEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      isInbox: isInbox ?? this.isInbox,
      createdAtMicros: createdAtMicros ?? this.createdAtMicros,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (iconCodePoint.present) {
      map['icon_code_point'] = Variable<int>(iconCodePoint.value);
    }
    if (isInbox.present) {
      map['is_inbox'] = Variable<bool>(isInbox.value);
    }
    if (createdAtMicros.present) {
      map['created_at_micros'] = Variable<int>(createdAtMicros.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskListEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('isInbox: $isInbox, ')
          ..write('createdAtMicros: $createdAtMicros, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurrenceRuleEntriesTable extends RecurrenceRuleEntries
    with TableInfo<$RecurrenceRuleEntriesTable, RecurrenceRuleEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurrenceRuleEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalMeta = const VerificationMeta(
    'interval',
  );
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
    'interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdaysMeta = const VerificationMeta(
    'weekdays',
  );
  @override
  late final GeneratedColumn<String> weekdays = GeneratedColumn<String>(
    'weekdays',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _untilDateMicrosMeta = const VerificationMeta(
    'untilDateMicros',
  );
  @override
  late final GeneratedColumn<int> untilDateMicros = GeneratedColumn<int>(
    'until_date_micros',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurrenceCountMeta = const VerificationMeta(
    'occurrenceCount',
  );
  @override
  late final GeneratedColumn<int> occurrenceCount = GeneratedColumn<int>(
    'occurrence_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    frequency,
    interval,
    weekdays,
    untilDateMicros,
    occurrenceCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurrence_rule_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurrenceRuleEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('interval')) {
      context.handle(
        _intervalMeta,
        interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta),
      );
    } else if (isInserting) {
      context.missing(_intervalMeta);
    }
    if (data.containsKey('weekdays')) {
      context.handle(
        _weekdaysMeta,
        weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdaysMeta);
    }
    if (data.containsKey('until_date_micros')) {
      context.handle(
        _untilDateMicrosMeta,
        untilDateMicros.isAcceptableOrUnknown(
          data['until_date_micros']!,
          _untilDateMicrosMeta,
        ),
      );
    }
    if (data.containsKey('occurrence_count')) {
      context.handle(
        _occurrenceCountMeta,
        occurrenceCount.isAcceptableOrUnknown(
          data['occurrence_count']!,
          _occurrenceCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurrenceRuleEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurrenceRuleEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      interval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval'],
      )!,
      weekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekdays'],
      )!,
      untilDateMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}until_date_micros'],
      ),
      occurrenceCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurrence_count'],
      ),
    );
  }

  @override
  $RecurrenceRuleEntriesTable createAlias(String alias) {
    return $RecurrenceRuleEntriesTable(attachedDatabase, alias);
  }
}

class RecurrenceRuleEntry extends DataClass
    implements Insertable<RecurrenceRuleEntry> {
  final String id;
  final String frequency;
  final int interval;
  final String weekdays;
  final int? untilDateMicros;
  final int? occurrenceCount;
  const RecurrenceRuleEntry({
    required this.id,
    required this.frequency,
    required this.interval,
    required this.weekdays,
    this.untilDateMicros,
    this.occurrenceCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['frequency'] = Variable<String>(frequency);
    map['interval'] = Variable<int>(interval);
    map['weekdays'] = Variable<String>(weekdays);
    if (!nullToAbsent || untilDateMicros != null) {
      map['until_date_micros'] = Variable<int>(untilDateMicros);
    }
    if (!nullToAbsent || occurrenceCount != null) {
      map['occurrence_count'] = Variable<int>(occurrenceCount);
    }
    return map;
  }

  RecurrenceRuleEntriesCompanion toCompanion(bool nullToAbsent) {
    return RecurrenceRuleEntriesCompanion(
      id: Value(id),
      frequency: Value(frequency),
      interval: Value(interval),
      weekdays: Value(weekdays),
      untilDateMicros: untilDateMicros == null && nullToAbsent
          ? const Value.absent()
          : Value(untilDateMicros),
      occurrenceCount: occurrenceCount == null && nullToAbsent
          ? const Value.absent()
          : Value(occurrenceCount),
    );
  }

  factory RecurrenceRuleEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurrenceRuleEntry(
      id: serializer.fromJson<String>(json['id']),
      frequency: serializer.fromJson<String>(json['frequency']),
      interval: serializer.fromJson<int>(json['interval']),
      weekdays: serializer.fromJson<String>(json['weekdays']),
      untilDateMicros: serializer.fromJson<int?>(json['untilDateMicros']),
      occurrenceCount: serializer.fromJson<int?>(json['occurrenceCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'frequency': serializer.toJson<String>(frequency),
      'interval': serializer.toJson<int>(interval),
      'weekdays': serializer.toJson<String>(weekdays),
      'untilDateMicros': serializer.toJson<int?>(untilDateMicros),
      'occurrenceCount': serializer.toJson<int?>(occurrenceCount),
    };
  }

  RecurrenceRuleEntry copyWith({
    String? id,
    String? frequency,
    int? interval,
    String? weekdays,
    Value<int?> untilDateMicros = const Value.absent(),
    Value<int?> occurrenceCount = const Value.absent(),
  }) => RecurrenceRuleEntry(
    id: id ?? this.id,
    frequency: frequency ?? this.frequency,
    interval: interval ?? this.interval,
    weekdays: weekdays ?? this.weekdays,
    untilDateMicros: untilDateMicros.present
        ? untilDateMicros.value
        : this.untilDateMicros,
    occurrenceCount: occurrenceCount.present
        ? occurrenceCount.value
        : this.occurrenceCount,
  );
  RecurrenceRuleEntry copyWithCompanion(RecurrenceRuleEntriesCompanion data) {
    return RecurrenceRuleEntry(
      id: data.id.present ? data.id.value : this.id,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      interval: data.interval.present ? data.interval.value : this.interval,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      untilDateMicros: data.untilDateMicros.present
          ? data.untilDateMicros.value
          : this.untilDateMicros,
      occurrenceCount: data.occurrenceCount.present
          ? data.occurrenceCount.value
          : this.occurrenceCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceRuleEntry(')
          ..write('id: $id, ')
          ..write('frequency: $frequency, ')
          ..write('interval: $interval, ')
          ..write('weekdays: $weekdays, ')
          ..write('untilDateMicros: $untilDateMicros, ')
          ..write('occurrenceCount: $occurrenceCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    frequency,
    interval,
    weekdays,
    untilDateMicros,
    occurrenceCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurrenceRuleEntry &&
          other.id == this.id &&
          other.frequency == this.frequency &&
          other.interval == this.interval &&
          other.weekdays == this.weekdays &&
          other.untilDateMicros == this.untilDateMicros &&
          other.occurrenceCount == this.occurrenceCount);
}

class RecurrenceRuleEntriesCompanion
    extends UpdateCompanion<RecurrenceRuleEntry> {
  final Value<String> id;
  final Value<String> frequency;
  final Value<int> interval;
  final Value<String> weekdays;
  final Value<int?> untilDateMicros;
  final Value<int?> occurrenceCount;
  final Value<int> rowid;
  const RecurrenceRuleEntriesCompanion({
    this.id = const Value.absent(),
    this.frequency = const Value.absent(),
    this.interval = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.untilDateMicros = const Value.absent(),
    this.occurrenceCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurrenceRuleEntriesCompanion.insert({
    required String id,
    required String frequency,
    required int interval,
    required String weekdays,
    this.untilDateMicros = const Value.absent(),
    this.occurrenceCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       frequency = Value(frequency),
       interval = Value(interval),
       weekdays = Value(weekdays);
  static Insertable<RecurrenceRuleEntry> custom({
    Expression<String>? id,
    Expression<String>? frequency,
    Expression<int>? interval,
    Expression<String>? weekdays,
    Expression<int>? untilDateMicros,
    Expression<int>? occurrenceCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (frequency != null) 'frequency': frequency,
      if (interval != null) 'interval': interval,
      if (weekdays != null) 'weekdays': weekdays,
      if (untilDateMicros != null) 'until_date_micros': untilDateMicros,
      if (occurrenceCount != null) 'occurrence_count': occurrenceCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurrenceRuleEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? frequency,
    Value<int>? interval,
    Value<String>? weekdays,
    Value<int?>? untilDateMicros,
    Value<int?>? occurrenceCount,
    Value<int>? rowid,
  }) {
    return RecurrenceRuleEntriesCompanion(
      id: id ?? this.id,
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      weekdays: weekdays ?? this.weekdays,
      untilDateMicros: untilDateMicros ?? this.untilDateMicros,
      occurrenceCount: occurrenceCount ?? this.occurrenceCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<String>(weekdays.value);
    }
    if (untilDateMicros.present) {
      map['until_date_micros'] = Variable<int>(untilDateMicros.value);
    }
    if (occurrenceCount.present) {
      map['occurrence_count'] = Variable<int>(occurrenceCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceRuleEntriesCompanion(')
          ..write('id: $id, ')
          ..write('frequency: $frequency, ')
          ..write('interval: $interval, ')
          ..write('weekdays: $weekdays, ')
          ..write('untilDateMicros: $untilDateMicros, ')
          ..write('occurrenceCount: $occurrenceCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfileEntriesTable extends ProfileEntries
    with TableInfo<$ProfileEntriesTable, ProfileEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfileEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isMeMeta = const VerificationMeta('isMe');
  @override
  late final GeneratedColumn<bool> isMe = GeneratedColumn<bool>(
    'is_me',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_me" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, colorValue, isMe];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('is_me')) {
      context.handle(
        _isMeMeta,
        isMe.isAcceptableOrUnknown(data['is_me']!, _isMeMeta),
      );
    } else if (isInserting) {
      context.missing(_isMeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      isMe: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_me'],
      )!,
    );
  }

  @override
  $ProfileEntriesTable createAlias(String alias) {
    return $ProfileEntriesTable(attachedDatabase, alias);
  }
}

class ProfileEntry extends DataClass implements Insertable<ProfileEntry> {
  final String id;
  final String name;
  final int colorValue;
  final bool isMe;
  const ProfileEntry({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.isMe,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color_value'] = Variable<int>(colorValue);
    map['is_me'] = Variable<bool>(isMe);
    return map;
  }

  ProfileEntriesCompanion toCompanion(bool nullToAbsent) {
    return ProfileEntriesCompanion(
      id: Value(id),
      name: Value(name),
      colorValue: Value(colorValue),
      isMe: Value(isMe),
    );
  }

  factory ProfileEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      isMe: serializer.fromJson<bool>(json['isMe']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'colorValue': serializer.toJson<int>(colorValue),
      'isMe': serializer.toJson<bool>(isMe),
    };
  }

  ProfileEntry copyWith({
    String? id,
    String? name,
    int? colorValue,
    bool? isMe,
  }) => ProfileEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    colorValue: colorValue ?? this.colorValue,
    isMe: isMe ?? this.isMe,
  );
  ProfileEntry copyWithCompanion(ProfileEntriesCompanion data) {
    return ProfileEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      isMe: data.isMe.present ? data.isMe.value : this.isMe,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('isMe: $isMe')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorValue, isMe);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorValue == this.colorValue &&
          other.isMe == this.isMe);
}

class ProfileEntriesCompanion extends UpdateCompanion<ProfileEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> colorValue;
  final Value<bool> isMe;
  final Value<int> rowid;
  const ProfileEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isMe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfileEntriesCompanion.insert({
    required String id,
    required String name,
    required int colorValue,
    required bool isMe,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       colorValue = Value(colorValue),
       isMe = Value(isMe);
  static Insertable<ProfileEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? colorValue,
    Expression<bool>? isMe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorValue != null) 'color_value': colorValue,
      if (isMe != null) 'is_me': isMe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfileEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? colorValue,
    Value<bool>? isMe,
    Value<int>? rowid,
  }) {
    return ProfileEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      isMe: isMe ?? this.isMe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (isMe.present) {
      map['is_me'] = Variable<bool>(isMe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfileEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('isMe: $isMe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskEntriesTable extends TaskEntries
    with TableInfo<$TaskEntriesTable, TaskEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<String> listId = GeneratedColumn<String>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_list_entries (id)',
    ),
  );
  static const VerificationMeta _parentTaskIdMeta = const VerificationMeta(
    'parentTaskId',
  );
  @override
  late final GeneratedColumn<String> parentTaskId = GeneratedColumn<String>(
    'parent_task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earliestStartMicrosMeta =
      const VerificationMeta('earliestStartMicros');
  @override
  late final GeneratedColumn<int> earliestStartMicros = GeneratedColumn<int>(
    'earliest_start_micros',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deadlineMicrosMeta = const VerificationMeta(
    'deadlineMicros',
  );
  @override
  late final GeneratedColumn<int> deadlineMicros = GeneratedColumn<int>(
    'deadline_micros',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimatedMinutesMeta = const VerificationMeta(
    'estimatedMinutes',
  );
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
    'estimated_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remainingMinutesMeta = const VerificationMeta(
    'remainingMinutes',
  );
  @override
  late final GeneratedColumn<int> remainingMinutes = GeneratedColumn<int>(
    'remaining_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allowSplitMeta = const VerificationMeta(
    'allowSplit',
  );
  @override
  late final GeneratedColumn<bool> allowSplit = GeneratedColumn<bool>(
    'allow_split',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("allow_split" IN (0, 1))',
    ),
  );
  static const VerificationMeta _minimumSessionMinutesMeta =
      const VerificationMeta('minimumSessionMinutes');
  @override
  late final GeneratedColumn<int> minimumSessionMinutes = GeneratedColumn<int>(
    'minimum_session_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maximumSessionMinutesMeta =
      const VerificationMeta('maximumSessionMinutes');
  @override
  late final GeneratedColumn<int> maximumSessionMinutes = GeneratedColumn<int>(
    'maximum_session_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recurrenceRuleIdMeta = const VerificationMeta(
    'recurrenceRuleId',
  );
  @override
  late final GeneratedColumn<String> recurrenceRuleId = GeneratedColumn<String>(
    'recurrence_rule_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recurrence_rule_entries (id)',
    ),
  );
  static const VerificationMeta _recurrenceSeriesIdMeta =
      const VerificationMeta('recurrenceSeriesId');
  @override
  late final GeneratedColumn<String> recurrenceSeriesId =
      GeneratedColumn<String>(
        'recurrence_series_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _occurrenceDateMicrosMeta =
      const VerificationMeta('occurrenceDateMicros');
  @override
  late final GeneratedColumn<int> occurrenceDateMicros = GeneratedColumn<int>(
    'occurrence_date_micros',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assigneeProfileIdMeta = const VerificationMeta(
    'assigneeProfileId',
  );
  @override
  late final GeneratedColumn<String> assigneeProfileId =
      GeneratedColumn<String>(
        'assignee_profile_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES profile_entries (id)',
        ),
      );
  static const VerificationMeta _includeInMyPlanMeta = const VerificationMeta(
    'includeInMyPlan',
  );
  @override
  late final GeneratedColumn<bool> includeInMyPlan = GeneratedColumn<bool>(
    'include_in_my_plan',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("include_in_my_plan" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMicrosMeta = const VerificationMeta(
    'createdAtMicros',
  );
  @override
  late final GeneratedColumn<int> createdAtMicros = GeneratedColumn<int>(
    'created_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMicrosMeta = const VerificationMeta(
    'updatedAtMicros',
  );
  @override
  late final GeneratedColumn<int> updatedAtMicros = GeneratedColumn<int>(
    'updated_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMicrosMeta = const VerificationMeta(
    'completedAtMicros',
  );
  @override
  late final GeneratedColumn<int> completedAtMicros = GeneratedColumn<int>(
    'completed_at_micros',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    notes,
    listId,
    parentTaskId,
    status,
    priority,
    earliestStartMicros,
    deadlineMicros,
    estimatedMinutes,
    remainingMinutes,
    allowSplit,
    minimumSessionMinutes,
    maximumSessionMinutes,
    recurrenceRuleId,
    recurrenceSeriesId,
    occurrenceDateMicros,
    assigneeProfileId,
    includeInMyPlan,
    createdAtMicros,
    updatedAtMicros,
    completedAtMicros,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('parent_task_id')) {
      context.handle(
        _parentTaskIdMeta,
        parentTaskId.isAcceptableOrUnknown(
          data['parent_task_id']!,
          _parentTaskIdMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('earliest_start_micros')) {
      context.handle(
        _earliestStartMicrosMeta,
        earliestStartMicros.isAcceptableOrUnknown(
          data['earliest_start_micros']!,
          _earliestStartMicrosMeta,
        ),
      );
    }
    if (data.containsKey('deadline_micros')) {
      context.handle(
        _deadlineMicrosMeta,
        deadlineMicros.isAcceptableOrUnknown(
          data['deadline_micros']!,
          _deadlineMicrosMeta,
        ),
      );
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
        _estimatedMinutesMeta,
        estimatedMinutes.isAcceptableOrUnknown(
          data['estimated_minutes']!,
          _estimatedMinutesMeta,
        ),
      );
    }
    if (data.containsKey('remaining_minutes')) {
      context.handle(
        _remainingMinutesMeta,
        remainingMinutes.isAcceptableOrUnknown(
          data['remaining_minutes']!,
          _remainingMinutesMeta,
        ),
      );
    }
    if (data.containsKey('allow_split')) {
      context.handle(
        _allowSplitMeta,
        allowSplit.isAcceptableOrUnknown(data['allow_split']!, _allowSplitMeta),
      );
    } else if (isInserting) {
      context.missing(_allowSplitMeta);
    }
    if (data.containsKey('minimum_session_minutes')) {
      context.handle(
        _minimumSessionMinutesMeta,
        minimumSessionMinutes.isAcceptableOrUnknown(
          data['minimum_session_minutes']!,
          _minimumSessionMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minimumSessionMinutesMeta);
    }
    if (data.containsKey('maximum_session_minutes')) {
      context.handle(
        _maximumSessionMinutesMeta,
        maximumSessionMinutes.isAcceptableOrUnknown(
          data['maximum_session_minutes']!,
          _maximumSessionMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maximumSessionMinutesMeta);
    }
    if (data.containsKey('recurrence_rule_id')) {
      context.handle(
        _recurrenceRuleIdMeta,
        recurrenceRuleId.isAcceptableOrUnknown(
          data['recurrence_rule_id']!,
          _recurrenceRuleIdMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_series_id')) {
      context.handle(
        _recurrenceSeriesIdMeta,
        recurrenceSeriesId.isAcceptableOrUnknown(
          data['recurrence_series_id']!,
          _recurrenceSeriesIdMeta,
        ),
      );
    }
    if (data.containsKey('occurrence_date_micros')) {
      context.handle(
        _occurrenceDateMicrosMeta,
        occurrenceDateMicros.isAcceptableOrUnknown(
          data['occurrence_date_micros']!,
          _occurrenceDateMicrosMeta,
        ),
      );
    }
    if (data.containsKey('assignee_profile_id')) {
      context.handle(
        _assigneeProfileIdMeta,
        assigneeProfileId.isAcceptableOrUnknown(
          data['assignee_profile_id']!,
          _assigneeProfileIdMeta,
        ),
      );
    }
    if (data.containsKey('include_in_my_plan')) {
      context.handle(
        _includeInMyPlanMeta,
        includeInMyPlan.isAcceptableOrUnknown(
          data['include_in_my_plan']!,
          _includeInMyPlanMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_includeInMyPlanMeta);
    }
    if (data.containsKey('created_at_micros')) {
      context.handle(
        _createdAtMicrosMeta,
        createdAtMicros.isAcceptableOrUnknown(
          data['created_at_micros']!,
          _createdAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMicrosMeta);
    }
    if (data.containsKey('updated_at_micros')) {
      context.handle(
        _updatedAtMicrosMeta,
        updatedAtMicros.isAcceptableOrUnknown(
          data['updated_at_micros']!,
          _updatedAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMicrosMeta);
    }
    if (data.containsKey('completed_at_micros')) {
      context.handle(
        _completedAtMicrosMeta,
        completedAtMicros.isAcceptableOrUnknown(
          data['completed_at_micros']!,
          _completedAtMicrosMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_id'],
      )!,
      parentTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_task_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      earliestStartMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}earliest_start_micros'],
      ),
      deadlineMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deadline_micros'],
      ),
      estimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_minutes'],
      ),
      remainingMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining_minutes'],
      ),
      allowSplit: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}allow_split'],
      )!,
      minimumSessionMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minimum_session_minutes'],
      )!,
      maximumSessionMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maximum_session_minutes'],
      )!,
      recurrenceRuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_rule_id'],
      ),
      recurrenceSeriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_series_id'],
      ),
      occurrenceDateMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurrence_date_micros'],
      ),
      assigneeProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assignee_profile_id'],
      ),
      includeInMyPlan: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}include_in_my_plan'],
      )!,
      createdAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_micros'],
      )!,
      updatedAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_micros'],
      )!,
      completedAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at_micros'],
      ),
    );
  }

  @override
  $TaskEntriesTable createAlias(String alias) {
    return $TaskEntriesTable(attachedDatabase, alias);
  }
}

class TaskEntry extends DataClass implements Insertable<TaskEntry> {
  final String id;
  final String title;
  final String? notes;
  final String listId;
  final String? parentTaskId;
  final String status;
  final String priority;
  final int? earliestStartMicros;
  final int? deadlineMicros;
  final int? estimatedMinutes;
  final int? remainingMinutes;
  final bool allowSplit;
  final int minimumSessionMinutes;
  final int maximumSessionMinutes;
  final String? recurrenceRuleId;
  final String? recurrenceSeriesId;
  final int? occurrenceDateMicros;
  final String? assigneeProfileId;
  final bool includeInMyPlan;
  final int createdAtMicros;
  final int updatedAtMicros;
  final int? completedAtMicros;
  const TaskEntry({
    required this.id,
    required this.title,
    this.notes,
    required this.listId,
    this.parentTaskId,
    required this.status,
    required this.priority,
    this.earliestStartMicros,
    this.deadlineMicros,
    this.estimatedMinutes,
    this.remainingMinutes,
    required this.allowSplit,
    required this.minimumSessionMinutes,
    required this.maximumSessionMinutes,
    this.recurrenceRuleId,
    this.recurrenceSeriesId,
    this.occurrenceDateMicros,
    this.assigneeProfileId,
    required this.includeInMyPlan,
    required this.createdAtMicros,
    required this.updatedAtMicros,
    this.completedAtMicros,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['list_id'] = Variable<String>(listId);
    if (!nullToAbsent || parentTaskId != null) {
      map['parent_task_id'] = Variable<String>(parentTaskId);
    }
    map['status'] = Variable<String>(status);
    map['priority'] = Variable<String>(priority);
    if (!nullToAbsent || earliestStartMicros != null) {
      map['earliest_start_micros'] = Variable<int>(earliestStartMicros);
    }
    if (!nullToAbsent || deadlineMicros != null) {
      map['deadline_micros'] = Variable<int>(deadlineMicros);
    }
    if (!nullToAbsent || estimatedMinutes != null) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    }
    if (!nullToAbsent || remainingMinutes != null) {
      map['remaining_minutes'] = Variable<int>(remainingMinutes);
    }
    map['allow_split'] = Variable<bool>(allowSplit);
    map['minimum_session_minutes'] = Variable<int>(minimumSessionMinutes);
    map['maximum_session_minutes'] = Variable<int>(maximumSessionMinutes);
    if (!nullToAbsent || recurrenceRuleId != null) {
      map['recurrence_rule_id'] = Variable<String>(recurrenceRuleId);
    }
    if (!nullToAbsent || recurrenceSeriesId != null) {
      map['recurrence_series_id'] = Variable<String>(recurrenceSeriesId);
    }
    if (!nullToAbsent || occurrenceDateMicros != null) {
      map['occurrence_date_micros'] = Variable<int>(occurrenceDateMicros);
    }
    if (!nullToAbsent || assigneeProfileId != null) {
      map['assignee_profile_id'] = Variable<String>(assigneeProfileId);
    }
    map['include_in_my_plan'] = Variable<bool>(includeInMyPlan);
    map['created_at_micros'] = Variable<int>(createdAtMicros);
    map['updated_at_micros'] = Variable<int>(updatedAtMicros);
    if (!nullToAbsent || completedAtMicros != null) {
      map['completed_at_micros'] = Variable<int>(completedAtMicros);
    }
    return map;
  }

  TaskEntriesCompanion toCompanion(bool nullToAbsent) {
    return TaskEntriesCompanion(
      id: Value(id),
      title: Value(title),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      listId: Value(listId),
      parentTaskId: parentTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentTaskId),
      status: Value(status),
      priority: Value(priority),
      earliestStartMicros: earliestStartMicros == null && nullToAbsent
          ? const Value.absent()
          : Value(earliestStartMicros),
      deadlineMicros: deadlineMicros == null && nullToAbsent
          ? const Value.absent()
          : Value(deadlineMicros),
      estimatedMinutes: estimatedMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedMinutes),
      remainingMinutes: remainingMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(remainingMinutes),
      allowSplit: Value(allowSplit),
      minimumSessionMinutes: Value(minimumSessionMinutes),
      maximumSessionMinutes: Value(maximumSessionMinutes),
      recurrenceRuleId: recurrenceRuleId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRuleId),
      recurrenceSeriesId: recurrenceSeriesId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceSeriesId),
      occurrenceDateMicros: occurrenceDateMicros == null && nullToAbsent
          ? const Value.absent()
          : Value(occurrenceDateMicros),
      assigneeProfileId: assigneeProfileId == null && nullToAbsent
          ? const Value.absent()
          : Value(assigneeProfileId),
      includeInMyPlan: Value(includeInMyPlan),
      createdAtMicros: Value(createdAtMicros),
      updatedAtMicros: Value(updatedAtMicros),
      completedAtMicros: completedAtMicros == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAtMicros),
    );
  }

  factory TaskEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      listId: serializer.fromJson<String>(json['listId']),
      parentTaskId: serializer.fromJson<String?>(json['parentTaskId']),
      status: serializer.fromJson<String>(json['status']),
      priority: serializer.fromJson<String>(json['priority']),
      earliestStartMicros: serializer.fromJson<int?>(
        json['earliestStartMicros'],
      ),
      deadlineMicros: serializer.fromJson<int?>(json['deadlineMicros']),
      estimatedMinutes: serializer.fromJson<int?>(json['estimatedMinutes']),
      remainingMinutes: serializer.fromJson<int?>(json['remainingMinutes']),
      allowSplit: serializer.fromJson<bool>(json['allowSplit']),
      minimumSessionMinutes: serializer.fromJson<int>(
        json['minimumSessionMinutes'],
      ),
      maximumSessionMinutes: serializer.fromJson<int>(
        json['maximumSessionMinutes'],
      ),
      recurrenceRuleId: serializer.fromJson<String?>(json['recurrenceRuleId']),
      recurrenceSeriesId: serializer.fromJson<String?>(
        json['recurrenceSeriesId'],
      ),
      occurrenceDateMicros: serializer.fromJson<int?>(
        json['occurrenceDateMicros'],
      ),
      assigneeProfileId: serializer.fromJson<String?>(
        json['assigneeProfileId'],
      ),
      includeInMyPlan: serializer.fromJson<bool>(json['includeInMyPlan']),
      createdAtMicros: serializer.fromJson<int>(json['createdAtMicros']),
      updatedAtMicros: serializer.fromJson<int>(json['updatedAtMicros']),
      completedAtMicros: serializer.fromJson<int?>(json['completedAtMicros']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'listId': serializer.toJson<String>(listId),
      'parentTaskId': serializer.toJson<String?>(parentTaskId),
      'status': serializer.toJson<String>(status),
      'priority': serializer.toJson<String>(priority),
      'earliestStartMicros': serializer.toJson<int?>(earliestStartMicros),
      'deadlineMicros': serializer.toJson<int?>(deadlineMicros),
      'estimatedMinutes': serializer.toJson<int?>(estimatedMinutes),
      'remainingMinutes': serializer.toJson<int?>(remainingMinutes),
      'allowSplit': serializer.toJson<bool>(allowSplit),
      'minimumSessionMinutes': serializer.toJson<int>(minimumSessionMinutes),
      'maximumSessionMinutes': serializer.toJson<int>(maximumSessionMinutes),
      'recurrenceRuleId': serializer.toJson<String?>(recurrenceRuleId),
      'recurrenceSeriesId': serializer.toJson<String?>(recurrenceSeriesId),
      'occurrenceDateMicros': serializer.toJson<int?>(occurrenceDateMicros),
      'assigneeProfileId': serializer.toJson<String?>(assigneeProfileId),
      'includeInMyPlan': serializer.toJson<bool>(includeInMyPlan),
      'createdAtMicros': serializer.toJson<int>(createdAtMicros),
      'updatedAtMicros': serializer.toJson<int>(updatedAtMicros),
      'completedAtMicros': serializer.toJson<int?>(completedAtMicros),
    };
  }

  TaskEntry copyWith({
    String? id,
    String? title,
    Value<String?> notes = const Value.absent(),
    String? listId,
    Value<String?> parentTaskId = const Value.absent(),
    String? status,
    String? priority,
    Value<int?> earliestStartMicros = const Value.absent(),
    Value<int?> deadlineMicros = const Value.absent(),
    Value<int?> estimatedMinutes = const Value.absent(),
    Value<int?> remainingMinutes = const Value.absent(),
    bool? allowSplit,
    int? minimumSessionMinutes,
    int? maximumSessionMinutes,
    Value<String?> recurrenceRuleId = const Value.absent(),
    Value<String?> recurrenceSeriesId = const Value.absent(),
    Value<int?> occurrenceDateMicros = const Value.absent(),
    Value<String?> assigneeProfileId = const Value.absent(),
    bool? includeInMyPlan,
    int? createdAtMicros,
    int? updatedAtMicros,
    Value<int?> completedAtMicros = const Value.absent(),
  }) => TaskEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    notes: notes.present ? notes.value : this.notes,
    listId: listId ?? this.listId,
    parentTaskId: parentTaskId.present ? parentTaskId.value : this.parentTaskId,
    status: status ?? this.status,
    priority: priority ?? this.priority,
    earliestStartMicros: earliestStartMicros.present
        ? earliestStartMicros.value
        : this.earliestStartMicros,
    deadlineMicros: deadlineMicros.present
        ? deadlineMicros.value
        : this.deadlineMicros,
    estimatedMinutes: estimatedMinutes.present
        ? estimatedMinutes.value
        : this.estimatedMinutes,
    remainingMinutes: remainingMinutes.present
        ? remainingMinutes.value
        : this.remainingMinutes,
    allowSplit: allowSplit ?? this.allowSplit,
    minimumSessionMinutes: minimumSessionMinutes ?? this.minimumSessionMinutes,
    maximumSessionMinutes: maximumSessionMinutes ?? this.maximumSessionMinutes,
    recurrenceRuleId: recurrenceRuleId.present
        ? recurrenceRuleId.value
        : this.recurrenceRuleId,
    recurrenceSeriesId: recurrenceSeriesId.present
        ? recurrenceSeriesId.value
        : this.recurrenceSeriesId,
    occurrenceDateMicros: occurrenceDateMicros.present
        ? occurrenceDateMicros.value
        : this.occurrenceDateMicros,
    assigneeProfileId: assigneeProfileId.present
        ? assigneeProfileId.value
        : this.assigneeProfileId,
    includeInMyPlan: includeInMyPlan ?? this.includeInMyPlan,
    createdAtMicros: createdAtMicros ?? this.createdAtMicros,
    updatedAtMicros: updatedAtMicros ?? this.updatedAtMicros,
    completedAtMicros: completedAtMicros.present
        ? completedAtMicros.value
        : this.completedAtMicros,
  );
  TaskEntry copyWithCompanion(TaskEntriesCompanion data) {
    return TaskEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      listId: data.listId.present ? data.listId.value : this.listId,
      parentTaskId: data.parentTaskId.present
          ? data.parentTaskId.value
          : this.parentTaskId,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      earliestStartMicros: data.earliestStartMicros.present
          ? data.earliestStartMicros.value
          : this.earliestStartMicros,
      deadlineMicros: data.deadlineMicros.present
          ? data.deadlineMicros.value
          : this.deadlineMicros,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      remainingMinutes: data.remainingMinutes.present
          ? data.remainingMinutes.value
          : this.remainingMinutes,
      allowSplit: data.allowSplit.present
          ? data.allowSplit.value
          : this.allowSplit,
      minimumSessionMinutes: data.minimumSessionMinutes.present
          ? data.minimumSessionMinutes.value
          : this.minimumSessionMinutes,
      maximumSessionMinutes: data.maximumSessionMinutes.present
          ? data.maximumSessionMinutes.value
          : this.maximumSessionMinutes,
      recurrenceRuleId: data.recurrenceRuleId.present
          ? data.recurrenceRuleId.value
          : this.recurrenceRuleId,
      recurrenceSeriesId: data.recurrenceSeriesId.present
          ? data.recurrenceSeriesId.value
          : this.recurrenceSeriesId,
      occurrenceDateMicros: data.occurrenceDateMicros.present
          ? data.occurrenceDateMicros.value
          : this.occurrenceDateMicros,
      assigneeProfileId: data.assigneeProfileId.present
          ? data.assigneeProfileId.value
          : this.assigneeProfileId,
      includeInMyPlan: data.includeInMyPlan.present
          ? data.includeInMyPlan.value
          : this.includeInMyPlan,
      createdAtMicros: data.createdAtMicros.present
          ? data.createdAtMicros.value
          : this.createdAtMicros,
      updatedAtMicros: data.updatedAtMicros.present
          ? data.updatedAtMicros.value
          : this.updatedAtMicros,
      completedAtMicros: data.completedAtMicros.present
          ? data.completedAtMicros.value
          : this.completedAtMicros,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('listId: $listId, ')
          ..write('parentTaskId: $parentTaskId, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('earliestStartMicros: $earliestStartMicros, ')
          ..write('deadlineMicros: $deadlineMicros, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('remainingMinutes: $remainingMinutes, ')
          ..write('allowSplit: $allowSplit, ')
          ..write('minimumSessionMinutes: $minimumSessionMinutes, ')
          ..write('maximumSessionMinutes: $maximumSessionMinutes, ')
          ..write('recurrenceRuleId: $recurrenceRuleId, ')
          ..write('recurrenceSeriesId: $recurrenceSeriesId, ')
          ..write('occurrenceDateMicros: $occurrenceDateMicros, ')
          ..write('assigneeProfileId: $assigneeProfileId, ')
          ..write('includeInMyPlan: $includeInMyPlan, ')
          ..write('createdAtMicros: $createdAtMicros, ')
          ..write('updatedAtMicros: $updatedAtMicros, ')
          ..write('completedAtMicros: $completedAtMicros')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    title,
    notes,
    listId,
    parentTaskId,
    status,
    priority,
    earliestStartMicros,
    deadlineMicros,
    estimatedMinutes,
    remainingMinutes,
    allowSplit,
    minimumSessionMinutes,
    maximumSessionMinutes,
    recurrenceRuleId,
    recurrenceSeriesId,
    occurrenceDateMicros,
    assigneeProfileId,
    includeInMyPlan,
    createdAtMicros,
    updatedAtMicros,
    completedAtMicros,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.listId == this.listId &&
          other.parentTaskId == this.parentTaskId &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.earliestStartMicros == this.earliestStartMicros &&
          other.deadlineMicros == this.deadlineMicros &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.remainingMinutes == this.remainingMinutes &&
          other.allowSplit == this.allowSplit &&
          other.minimumSessionMinutes == this.minimumSessionMinutes &&
          other.maximumSessionMinutes == this.maximumSessionMinutes &&
          other.recurrenceRuleId == this.recurrenceRuleId &&
          other.recurrenceSeriesId == this.recurrenceSeriesId &&
          other.occurrenceDateMicros == this.occurrenceDateMicros &&
          other.assigneeProfileId == this.assigneeProfileId &&
          other.includeInMyPlan == this.includeInMyPlan &&
          other.createdAtMicros == this.createdAtMicros &&
          other.updatedAtMicros == this.updatedAtMicros &&
          other.completedAtMicros == this.completedAtMicros);
}

class TaskEntriesCompanion extends UpdateCompanion<TaskEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> notes;
  final Value<String> listId;
  final Value<String?> parentTaskId;
  final Value<String> status;
  final Value<String> priority;
  final Value<int?> earliestStartMicros;
  final Value<int?> deadlineMicros;
  final Value<int?> estimatedMinutes;
  final Value<int?> remainingMinutes;
  final Value<bool> allowSplit;
  final Value<int> minimumSessionMinutes;
  final Value<int> maximumSessionMinutes;
  final Value<String?> recurrenceRuleId;
  final Value<String?> recurrenceSeriesId;
  final Value<int?> occurrenceDateMicros;
  final Value<String?> assigneeProfileId;
  final Value<bool> includeInMyPlan;
  final Value<int> createdAtMicros;
  final Value<int> updatedAtMicros;
  final Value<int?> completedAtMicros;
  final Value<int> rowid;
  const TaskEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.listId = const Value.absent(),
    this.parentTaskId = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.earliestStartMicros = const Value.absent(),
    this.deadlineMicros = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.remainingMinutes = const Value.absent(),
    this.allowSplit = const Value.absent(),
    this.minimumSessionMinutes = const Value.absent(),
    this.maximumSessionMinutes = const Value.absent(),
    this.recurrenceRuleId = const Value.absent(),
    this.recurrenceSeriesId = const Value.absent(),
    this.occurrenceDateMicros = const Value.absent(),
    this.assigneeProfileId = const Value.absent(),
    this.includeInMyPlan = const Value.absent(),
    this.createdAtMicros = const Value.absent(),
    this.updatedAtMicros = const Value.absent(),
    this.completedAtMicros = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskEntriesCompanion.insert({
    required String id,
    required String title,
    this.notes = const Value.absent(),
    required String listId,
    this.parentTaskId = const Value.absent(),
    required String status,
    required String priority,
    this.earliestStartMicros = const Value.absent(),
    this.deadlineMicros = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.remainingMinutes = const Value.absent(),
    required bool allowSplit,
    required int minimumSessionMinutes,
    required int maximumSessionMinutes,
    this.recurrenceRuleId = const Value.absent(),
    this.recurrenceSeriesId = const Value.absent(),
    this.occurrenceDateMicros = const Value.absent(),
    this.assigneeProfileId = const Value.absent(),
    required bool includeInMyPlan,
    required int createdAtMicros,
    required int updatedAtMicros,
    this.completedAtMicros = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       listId = Value(listId),
       status = Value(status),
       priority = Value(priority),
       allowSplit = Value(allowSplit),
       minimumSessionMinutes = Value(minimumSessionMinutes),
       maximumSessionMinutes = Value(maximumSessionMinutes),
       includeInMyPlan = Value(includeInMyPlan),
       createdAtMicros = Value(createdAtMicros),
       updatedAtMicros = Value(updatedAtMicros);
  static Insertable<TaskEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<String>? listId,
    Expression<String>? parentTaskId,
    Expression<String>? status,
    Expression<String>? priority,
    Expression<int>? earliestStartMicros,
    Expression<int>? deadlineMicros,
    Expression<int>? estimatedMinutes,
    Expression<int>? remainingMinutes,
    Expression<bool>? allowSplit,
    Expression<int>? minimumSessionMinutes,
    Expression<int>? maximumSessionMinutes,
    Expression<String>? recurrenceRuleId,
    Expression<String>? recurrenceSeriesId,
    Expression<int>? occurrenceDateMicros,
    Expression<String>? assigneeProfileId,
    Expression<bool>? includeInMyPlan,
    Expression<int>? createdAtMicros,
    Expression<int>? updatedAtMicros,
    Expression<int>? completedAtMicros,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (listId != null) 'list_id': listId,
      if (parentTaskId != null) 'parent_task_id': parentTaskId,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (earliestStartMicros != null)
        'earliest_start_micros': earliestStartMicros,
      if (deadlineMicros != null) 'deadline_micros': deadlineMicros,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (remainingMinutes != null) 'remaining_minutes': remainingMinutes,
      if (allowSplit != null) 'allow_split': allowSplit,
      if (minimumSessionMinutes != null)
        'minimum_session_minutes': minimumSessionMinutes,
      if (maximumSessionMinutes != null)
        'maximum_session_minutes': maximumSessionMinutes,
      if (recurrenceRuleId != null) 'recurrence_rule_id': recurrenceRuleId,
      if (recurrenceSeriesId != null)
        'recurrence_series_id': recurrenceSeriesId,
      if (occurrenceDateMicros != null)
        'occurrence_date_micros': occurrenceDateMicros,
      if (assigneeProfileId != null) 'assignee_profile_id': assigneeProfileId,
      if (includeInMyPlan != null) 'include_in_my_plan': includeInMyPlan,
      if (createdAtMicros != null) 'created_at_micros': createdAtMicros,
      if (updatedAtMicros != null) 'updated_at_micros': updatedAtMicros,
      if (completedAtMicros != null) 'completed_at_micros': completedAtMicros,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? notes,
    Value<String>? listId,
    Value<String?>? parentTaskId,
    Value<String>? status,
    Value<String>? priority,
    Value<int?>? earliestStartMicros,
    Value<int?>? deadlineMicros,
    Value<int?>? estimatedMinutes,
    Value<int?>? remainingMinutes,
    Value<bool>? allowSplit,
    Value<int>? minimumSessionMinutes,
    Value<int>? maximumSessionMinutes,
    Value<String?>? recurrenceRuleId,
    Value<String?>? recurrenceSeriesId,
    Value<int?>? occurrenceDateMicros,
    Value<String?>? assigneeProfileId,
    Value<bool>? includeInMyPlan,
    Value<int>? createdAtMicros,
    Value<int>? updatedAtMicros,
    Value<int?>? completedAtMicros,
    Value<int>? rowid,
  }) {
    return TaskEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      listId: listId ?? this.listId,
      parentTaskId: parentTaskId ?? this.parentTaskId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      earliestStartMicros: earliestStartMicros ?? this.earliestStartMicros,
      deadlineMicros: deadlineMicros ?? this.deadlineMicros,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      remainingMinutes: remainingMinutes ?? this.remainingMinutes,
      allowSplit: allowSplit ?? this.allowSplit,
      minimumSessionMinutes:
          minimumSessionMinutes ?? this.minimumSessionMinutes,
      maximumSessionMinutes:
          maximumSessionMinutes ?? this.maximumSessionMinutes,
      recurrenceRuleId: recurrenceRuleId ?? this.recurrenceRuleId,
      recurrenceSeriesId: recurrenceSeriesId ?? this.recurrenceSeriesId,
      occurrenceDateMicros: occurrenceDateMicros ?? this.occurrenceDateMicros,
      assigneeProfileId: assigneeProfileId ?? this.assigneeProfileId,
      includeInMyPlan: includeInMyPlan ?? this.includeInMyPlan,
      createdAtMicros: createdAtMicros ?? this.createdAtMicros,
      updatedAtMicros: updatedAtMicros ?? this.updatedAtMicros,
      completedAtMicros: completedAtMicros ?? this.completedAtMicros,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<String>(listId.value);
    }
    if (parentTaskId.present) {
      map['parent_task_id'] = Variable<String>(parentTaskId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (earliestStartMicros.present) {
      map['earliest_start_micros'] = Variable<int>(earliestStartMicros.value);
    }
    if (deadlineMicros.present) {
      map['deadline_micros'] = Variable<int>(deadlineMicros.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (remainingMinutes.present) {
      map['remaining_minutes'] = Variable<int>(remainingMinutes.value);
    }
    if (allowSplit.present) {
      map['allow_split'] = Variable<bool>(allowSplit.value);
    }
    if (minimumSessionMinutes.present) {
      map['minimum_session_minutes'] = Variable<int>(
        minimumSessionMinutes.value,
      );
    }
    if (maximumSessionMinutes.present) {
      map['maximum_session_minutes'] = Variable<int>(
        maximumSessionMinutes.value,
      );
    }
    if (recurrenceRuleId.present) {
      map['recurrence_rule_id'] = Variable<String>(recurrenceRuleId.value);
    }
    if (recurrenceSeriesId.present) {
      map['recurrence_series_id'] = Variable<String>(recurrenceSeriesId.value);
    }
    if (occurrenceDateMicros.present) {
      map['occurrence_date_micros'] = Variable<int>(occurrenceDateMicros.value);
    }
    if (assigneeProfileId.present) {
      map['assignee_profile_id'] = Variable<String>(assigneeProfileId.value);
    }
    if (includeInMyPlan.present) {
      map['include_in_my_plan'] = Variable<bool>(includeInMyPlan.value);
    }
    if (createdAtMicros.present) {
      map['created_at_micros'] = Variable<int>(createdAtMicros.value);
    }
    if (updatedAtMicros.present) {
      map['updated_at_micros'] = Variable<int>(updatedAtMicros.value);
    }
    if (completedAtMicros.present) {
      map['completed_at_micros'] = Variable<int>(completedAtMicros.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('listId: $listId, ')
          ..write('parentTaskId: $parentTaskId, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('earliestStartMicros: $earliestStartMicros, ')
          ..write('deadlineMicros: $deadlineMicros, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('remainingMinutes: $remainingMinutes, ')
          ..write('allowSplit: $allowSplit, ')
          ..write('minimumSessionMinutes: $minimumSessionMinutes, ')
          ..write('maximumSessionMinutes: $maximumSessionMinutes, ')
          ..write('recurrenceRuleId: $recurrenceRuleId, ')
          ..write('recurrenceSeriesId: $recurrenceSeriesId, ')
          ..write('occurrenceDateMicros: $occurrenceDateMicros, ')
          ..write('assigneeProfileId: $assigneeProfileId, ')
          ..write('includeInMyPlan: $includeInMyPlan, ')
          ..write('createdAtMicros: $createdAtMicros, ')
          ..write('updatedAtMicros: $updatedAtMicros, ')
          ..write('completedAtMicros: $completedAtMicros, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduleBlockEntriesTable extends ScheduleBlockEntries
    with TableInfo<$ScheduleBlockEntriesTable, ScheduleBlockEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleBlockEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_entries (id)',
    ),
  );
  static const VerificationMeta _startMicrosMeta = const VerificationMeta(
    'startMicros',
  );
  @override
  late final GeneratedColumn<int> startMicros = GeneratedColumn<int>(
    'start_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMicrosMeta = const VerificationMeta(
    'endMicros',
  );
  @override
  late final GeneratedColumn<int> endMicros = GeneratedColumn<int>(
    'end_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isLockedMeta = const VerificationMeta(
    'isLocked',
  );
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
    'is_locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_locked" IN (0, 1))',
    ),
  );
  static const VerificationMeta _completionStateMeta = const VerificationMeta(
    'completionState',
  );
  @override
  late final GeneratedColumn<String> completionState = GeneratedColumn<String>(
    'completion_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isGeneratedMeta = const VerificationMeta(
    'isGenerated',
  );
  @override
  late final GeneratedColumn<bool> isGenerated = GeneratedColumn<bool>(
    'is_generated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_generated" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    startMicros,
    endMicros,
    state,
    isLocked,
    completionState,
    note,
    isGenerated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_block_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleBlockEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('start_micros')) {
      context.handle(
        _startMicrosMeta,
        startMicros.isAcceptableOrUnknown(
          data['start_micros']!,
          _startMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMicrosMeta);
    }
    if (data.containsKey('end_micros')) {
      context.handle(
        _endMicrosMeta,
        endMicros.isAcceptableOrUnknown(data['end_micros']!, _endMicrosMeta),
      );
    } else if (isInserting) {
      context.missing(_endMicrosMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('is_locked')) {
      context.handle(
        _isLockedMeta,
        isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta),
      );
    } else if (isInserting) {
      context.missing(_isLockedMeta);
    }
    if (data.containsKey('completion_state')) {
      context.handle(
        _completionStateMeta,
        completionState.isAcceptableOrUnknown(
          data['completion_state']!,
          _completionStateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completionStateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_generated')) {
      context.handle(
        _isGeneratedMeta,
        isGenerated.isAcceptableOrUnknown(
          data['is_generated']!,
          _isGeneratedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isGeneratedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleBlockEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleBlockEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      startMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_micros'],
      )!,
      endMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_micros'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      isLocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_locked'],
      )!,
      completionState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completion_state'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      isGenerated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_generated'],
      )!,
    );
  }

  @override
  $ScheduleBlockEntriesTable createAlias(String alias) {
    return $ScheduleBlockEntriesTable(attachedDatabase, alias);
  }
}

class ScheduleBlockEntry extends DataClass
    implements Insertable<ScheduleBlockEntry> {
  final String id;
  final String? taskId;
  final int startMicros;
  final int endMicros;
  final String state;
  final bool isLocked;
  final String completionState;
  final String? note;
  final bool isGenerated;
  const ScheduleBlockEntry({
    required this.id,
    this.taskId,
    required this.startMicros,
    required this.endMicros,
    required this.state,
    required this.isLocked,
    required this.completionState,
    this.note,
    required this.isGenerated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    map['start_micros'] = Variable<int>(startMicros);
    map['end_micros'] = Variable<int>(endMicros);
    map['state'] = Variable<String>(state);
    map['is_locked'] = Variable<bool>(isLocked);
    map['completion_state'] = Variable<String>(completionState);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_generated'] = Variable<bool>(isGenerated);
    return map;
  }

  ScheduleBlockEntriesCompanion toCompanion(bool nullToAbsent) {
    return ScheduleBlockEntriesCompanion(
      id: Value(id),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      startMicros: Value(startMicros),
      endMicros: Value(endMicros),
      state: Value(state),
      isLocked: Value(isLocked),
      completionState: Value(completionState),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isGenerated: Value(isGenerated),
    );
  }

  factory ScheduleBlockEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleBlockEntry(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      startMicros: serializer.fromJson<int>(json['startMicros']),
      endMicros: serializer.fromJson<int>(json['endMicros']),
      state: serializer.fromJson<String>(json['state']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
      completionState: serializer.fromJson<String>(json['completionState']),
      note: serializer.fromJson<String?>(json['note']),
      isGenerated: serializer.fromJson<bool>(json['isGenerated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String?>(taskId),
      'startMicros': serializer.toJson<int>(startMicros),
      'endMicros': serializer.toJson<int>(endMicros),
      'state': serializer.toJson<String>(state),
      'isLocked': serializer.toJson<bool>(isLocked),
      'completionState': serializer.toJson<String>(completionState),
      'note': serializer.toJson<String?>(note),
      'isGenerated': serializer.toJson<bool>(isGenerated),
    };
  }

  ScheduleBlockEntry copyWith({
    String? id,
    Value<String?> taskId = const Value.absent(),
    int? startMicros,
    int? endMicros,
    String? state,
    bool? isLocked,
    String? completionState,
    Value<String?> note = const Value.absent(),
    bool? isGenerated,
  }) => ScheduleBlockEntry(
    id: id ?? this.id,
    taskId: taskId.present ? taskId.value : this.taskId,
    startMicros: startMicros ?? this.startMicros,
    endMicros: endMicros ?? this.endMicros,
    state: state ?? this.state,
    isLocked: isLocked ?? this.isLocked,
    completionState: completionState ?? this.completionState,
    note: note.present ? note.value : this.note,
    isGenerated: isGenerated ?? this.isGenerated,
  );
  ScheduleBlockEntry copyWithCompanion(ScheduleBlockEntriesCompanion data) {
    return ScheduleBlockEntry(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      startMicros: data.startMicros.present
          ? data.startMicros.value
          : this.startMicros,
      endMicros: data.endMicros.present ? data.endMicros.value : this.endMicros,
      state: data.state.present ? data.state.value : this.state,
      isLocked: data.isLocked.present ? data.isLocked.value : this.isLocked,
      completionState: data.completionState.present
          ? data.completionState.value
          : this.completionState,
      note: data.note.present ? data.note.value : this.note,
      isGenerated: data.isGenerated.present
          ? data.isGenerated.value
          : this.isGenerated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleBlockEntry(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('startMicros: $startMicros, ')
          ..write('endMicros: $endMicros, ')
          ..write('state: $state, ')
          ..write('isLocked: $isLocked, ')
          ..write('completionState: $completionState, ')
          ..write('note: $note, ')
          ..write('isGenerated: $isGenerated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    startMicros,
    endMicros,
    state,
    isLocked,
    completionState,
    note,
    isGenerated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleBlockEntry &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.startMicros == this.startMicros &&
          other.endMicros == this.endMicros &&
          other.state == this.state &&
          other.isLocked == this.isLocked &&
          other.completionState == this.completionState &&
          other.note == this.note &&
          other.isGenerated == this.isGenerated);
}

class ScheduleBlockEntriesCompanion
    extends UpdateCompanion<ScheduleBlockEntry> {
  final Value<String> id;
  final Value<String?> taskId;
  final Value<int> startMicros;
  final Value<int> endMicros;
  final Value<String> state;
  final Value<bool> isLocked;
  final Value<String> completionState;
  final Value<String?> note;
  final Value<bool> isGenerated;
  final Value<int> rowid;
  const ScheduleBlockEntriesCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.startMicros = const Value.absent(),
    this.endMicros = const Value.absent(),
    this.state = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.completionState = const Value.absent(),
    this.note = const Value.absent(),
    this.isGenerated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduleBlockEntriesCompanion.insert({
    required String id,
    this.taskId = const Value.absent(),
    required int startMicros,
    required int endMicros,
    required String state,
    required bool isLocked,
    required String completionState,
    this.note = const Value.absent(),
    required bool isGenerated,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startMicros = Value(startMicros),
       endMicros = Value(endMicros),
       state = Value(state),
       isLocked = Value(isLocked),
       completionState = Value(completionState),
       isGenerated = Value(isGenerated);
  static Insertable<ScheduleBlockEntry> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<int>? startMicros,
    Expression<int>? endMicros,
    Expression<String>? state,
    Expression<bool>? isLocked,
    Expression<String>? completionState,
    Expression<String>? note,
    Expression<bool>? isGenerated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (startMicros != null) 'start_micros': startMicros,
      if (endMicros != null) 'end_micros': endMicros,
      if (state != null) 'state': state,
      if (isLocked != null) 'is_locked': isLocked,
      if (completionState != null) 'completion_state': completionState,
      if (note != null) 'note': note,
      if (isGenerated != null) 'is_generated': isGenerated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduleBlockEntriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? taskId,
    Value<int>? startMicros,
    Value<int>? endMicros,
    Value<String>? state,
    Value<bool>? isLocked,
    Value<String>? completionState,
    Value<String?>? note,
    Value<bool>? isGenerated,
    Value<int>? rowid,
  }) {
    return ScheduleBlockEntriesCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      startMicros: startMicros ?? this.startMicros,
      endMicros: endMicros ?? this.endMicros,
      state: state ?? this.state,
      isLocked: isLocked ?? this.isLocked,
      completionState: completionState ?? this.completionState,
      note: note ?? this.note,
      isGenerated: isGenerated ?? this.isGenerated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (startMicros.present) {
      map['start_micros'] = Variable<int>(startMicros.value);
    }
    if (endMicros.present) {
      map['end_micros'] = Variable<int>(endMicros.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    if (completionState.present) {
      map['completion_state'] = Variable<String>(completionState.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isGenerated.present) {
      map['is_generated'] = Variable<bool>(isGenerated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleBlockEntriesCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('startMicros: $startMicros, ')
          ..write('endMicros: $endMicros, ')
          ..write('state: $state, ')
          ..write('isLocked: $isLocked, ')
          ..write('completionState: $completionState, ')
          ..write('note: $note, ')
          ..write('isGenerated: $isGenerated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagEntriesTable extends TagEntries
    with TableInfo<$TagEntriesTable, TagEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, colorValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tag_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TagEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
    );
  }

  @override
  $TagEntriesTable createAlias(String alias) {
    return $TagEntriesTable(attachedDatabase, alias);
  }
}

class TagEntry extends DataClass implements Insertable<TagEntry> {
  final String id;
  final String name;
  final int colorValue;
  const TagEntry({
    required this.id,
    required this.name,
    required this.colorValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color_value'] = Variable<int>(colorValue);
    return map;
  }

  TagEntriesCompanion toCompanion(bool nullToAbsent) {
    return TagEntriesCompanion(
      id: Value(id),
      name: Value(name),
      colorValue: Value(colorValue),
    );
  }

  factory TagEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'colorValue': serializer.toJson<int>(colorValue),
    };
  }

  TagEntry copyWith({String? id, String? name, int? colorValue}) => TagEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    colorValue: colorValue ?? this.colorValue,
  );
  TagEntry copyWithCompanion(TagEntriesCompanion data) {
    return TagEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorValue == this.colorValue);
}

class TagEntriesCompanion extends UpdateCompanion<TagEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> colorValue;
  final Value<int> rowid;
  const TagEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagEntriesCompanion.insert({
    required String id,
    required String name,
    required int colorValue,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       colorValue = Value(colorValue);
  static Insertable<TagEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? colorValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorValue != null) 'color_value': colorValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? colorValue,
    Value<int>? rowid,
  }) {
    return TagEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskTagEntriesTable extends TaskTagEntries
    with TableInfo<$TaskTagEntriesTable, TaskTagEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskTagEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_entries (id)',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tag_entries (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [taskId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_tag_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskTagEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId, tagId};
  @override
  TaskTagEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskTagEntry(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $TaskTagEntriesTable createAlias(String alias) {
    return $TaskTagEntriesTable(attachedDatabase, alias);
  }
}

class TaskTagEntry extends DataClass implements Insertable<TaskTagEntry> {
  final String taskId;
  final String tagId;
  const TaskTagEntry({required this.taskId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  TaskTagEntriesCompanion toCompanion(bool nullToAbsent) {
    return TaskTagEntriesCompanion(taskId: Value(taskId), tagId: Value(tagId));
  }

  factory TaskTagEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskTagEntry(
      taskId: serializer.fromJson<String>(json['taskId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  TaskTagEntry copyWith({String? taskId, String? tagId}) =>
      TaskTagEntry(taskId: taskId ?? this.taskId, tagId: tagId ?? this.tagId);
  TaskTagEntry copyWithCompanion(TaskTagEntriesCompanion data) {
    return TaskTagEntry(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskTagEntry(')
          ..write('taskId: $taskId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(taskId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskTagEntry &&
          other.taskId == this.taskId &&
          other.tagId == this.tagId);
}

class TaskTagEntriesCompanion extends UpdateCompanion<TaskTagEntry> {
  final Value<String> taskId;
  final Value<String> tagId;
  final Value<int> rowid;
  const TaskTagEntriesCompanion({
    this.taskId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskTagEntriesCompanion.insert({
    required String taskId,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       tagId = Value(tagId);
  static Insertable<TaskTagEntry> custom({
    Expression<String>? taskId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskTagEntriesCompanion copyWith({
    Value<String>? taskId,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return TaskTagEntriesCompanion(
      taskId: taskId ?? this.taskId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskTagEntriesCompanion(')
          ..write('taskId: $taskId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeeklyAvailabilityEntriesTable extends WeeklyAvailabilityEntries
    with TableInfo<$WeeklyAvailabilityEntriesTable, WeeklyAvailabilityEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyAvailabilityEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinuteMeta = const VerificationMeta(
    'startMinute',
  );
  @override
  late final GeneratedColumn<int> startMinute = GeneratedColumn<int>(
    'start_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMinuteMeta = const VerificationMeta(
    'endMinute',
  );
  @override
  late final GeneratedColumn<int> endMinute = GeneratedColumn<int>(
    'end_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [weekday, startMinute, endMinute];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_availability_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyAvailabilityEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('start_minute')) {
      context.handle(
        _startMinuteMeta,
        startMinute.isAcceptableOrUnknown(
          data['start_minute']!,
          _startMinuteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinuteMeta);
    }
    if (data.containsKey('end_minute')) {
      context.handle(
        _endMinuteMeta,
        endMinute.isAcceptableOrUnknown(data['end_minute']!, _endMinuteMeta),
      );
    } else if (isInserting) {
      context.missing(_endMinuteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {weekday, startMinute, endMinute};
  @override
  WeeklyAvailabilityEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyAvailabilityEntry(
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      startMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minute'],
      )!,
      endMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minute'],
      )!,
    );
  }

  @override
  $WeeklyAvailabilityEntriesTable createAlias(String alias) {
    return $WeeklyAvailabilityEntriesTable(attachedDatabase, alias);
  }
}

class WeeklyAvailabilityEntry extends DataClass
    implements Insertable<WeeklyAvailabilityEntry> {
  final int weekday;
  final int startMinute;
  final int endMinute;
  const WeeklyAvailabilityEntry({
    required this.weekday,
    required this.startMinute,
    required this.endMinute,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['weekday'] = Variable<int>(weekday);
    map['start_minute'] = Variable<int>(startMinute);
    map['end_minute'] = Variable<int>(endMinute);
    return map;
  }

  WeeklyAvailabilityEntriesCompanion toCompanion(bool nullToAbsent) {
    return WeeklyAvailabilityEntriesCompanion(
      weekday: Value(weekday),
      startMinute: Value(startMinute),
      endMinute: Value(endMinute),
    );
  }

  factory WeeklyAvailabilityEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyAvailabilityEntry(
      weekday: serializer.fromJson<int>(json['weekday']),
      startMinute: serializer.fromJson<int>(json['startMinute']),
      endMinute: serializer.fromJson<int>(json['endMinute']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'weekday': serializer.toJson<int>(weekday),
      'startMinute': serializer.toJson<int>(startMinute),
      'endMinute': serializer.toJson<int>(endMinute),
    };
  }

  WeeklyAvailabilityEntry copyWith({
    int? weekday,
    int? startMinute,
    int? endMinute,
  }) => WeeklyAvailabilityEntry(
    weekday: weekday ?? this.weekday,
    startMinute: startMinute ?? this.startMinute,
    endMinute: endMinute ?? this.endMinute,
  );
  WeeklyAvailabilityEntry copyWithCompanion(
    WeeklyAvailabilityEntriesCompanion data,
  ) {
    return WeeklyAvailabilityEntry(
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      startMinute: data.startMinute.present
          ? data.startMinute.value
          : this.startMinute,
      endMinute: data.endMinute.present ? data.endMinute.value : this.endMinute,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyAvailabilityEntry(')
          ..write('weekday: $weekday, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(weekday, startMinute, endMinute);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyAvailabilityEntry &&
          other.weekday == this.weekday &&
          other.startMinute == this.startMinute &&
          other.endMinute == this.endMinute);
}

class WeeklyAvailabilityEntriesCompanion
    extends UpdateCompanion<WeeklyAvailabilityEntry> {
  final Value<int> weekday;
  final Value<int> startMinute;
  final Value<int> endMinute;
  final Value<int> rowid;
  const WeeklyAvailabilityEntriesCompanion({
    this.weekday = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeeklyAvailabilityEntriesCompanion.insert({
    required int weekday,
    required int startMinute,
    required int endMinute,
    this.rowid = const Value.absent(),
  }) : weekday = Value(weekday),
       startMinute = Value(startMinute),
       endMinute = Value(endMinute);
  static Insertable<WeeklyAvailabilityEntry> custom({
    Expression<int>? weekday,
    Expression<int>? startMinute,
    Expression<int>? endMinute,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (weekday != null) 'weekday': weekday,
      if (startMinute != null) 'start_minute': startMinute,
      if (endMinute != null) 'end_minute': endMinute,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeeklyAvailabilityEntriesCompanion copyWith({
    Value<int>? weekday,
    Value<int>? startMinute,
    Value<int>? endMinute,
    Value<int>? rowid,
  }) {
    return WeeklyAvailabilityEntriesCompanion(
      weekday: weekday ?? this.weekday,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (startMinute.present) {
      map['start_minute'] = Variable<int>(startMinute.value);
    }
    if (endMinute.present) {
      map['end_minute'] = Variable<int>(endMinute.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyAvailabilityEntriesCompanion(')
          ..write('weekday: $weekday, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AvailabilityExceptionEntriesTable extends AvailabilityExceptionEntries
    with
        TableInfo<
          $AvailabilityExceptionEntriesTable,
          AvailabilityExceptionEntry
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AvailabilityExceptionEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinuteMeta = const VerificationMeta(
    'startMinute',
  );
  @override
  late final GeneratedColumn<int> startMinute = GeneratedColumn<int>(
    'start_minute',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMinuteMeta = const VerificationMeta(
    'endMinute',
  );
  @override
  late final GeneratedColumn<int> endMinute = GeneratedColumn<int>(
    'end_minute',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [date, startMinute, endMinute];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'availability_exception_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AvailabilityExceptionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('start_minute')) {
      context.handle(
        _startMinuteMeta,
        startMinute.isAcceptableOrUnknown(
          data['start_minute']!,
          _startMinuteMeta,
        ),
      );
    }
    if (data.containsKey('end_minute')) {
      context.handle(
        _endMinuteMeta,
        endMinute.isAcceptableOrUnknown(data['end_minute']!, _endMinuteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date, startMinute, endMinute};
  @override
  AvailabilityExceptionEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AvailabilityExceptionEntry(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      startMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minute'],
      ),
      endMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minute'],
      ),
    );
  }

  @override
  $AvailabilityExceptionEntriesTable createAlias(String alias) {
    return $AvailabilityExceptionEntriesTable(attachedDatabase, alias);
  }
}

class AvailabilityExceptionEntry extends DataClass
    implements Insertable<AvailabilityExceptionEntry> {
  final String date;
  final int? startMinute;
  final int? endMinute;
  const AvailabilityExceptionEntry({
    required this.date,
    this.startMinute,
    this.endMinute,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || startMinute != null) {
      map['start_minute'] = Variable<int>(startMinute);
    }
    if (!nullToAbsent || endMinute != null) {
      map['end_minute'] = Variable<int>(endMinute);
    }
    return map;
  }

  AvailabilityExceptionEntriesCompanion toCompanion(bool nullToAbsent) {
    return AvailabilityExceptionEntriesCompanion(
      date: Value(date),
      startMinute: startMinute == null && nullToAbsent
          ? const Value.absent()
          : Value(startMinute),
      endMinute: endMinute == null && nullToAbsent
          ? const Value.absent()
          : Value(endMinute),
    );
  }

  factory AvailabilityExceptionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AvailabilityExceptionEntry(
      date: serializer.fromJson<String>(json['date']),
      startMinute: serializer.fromJson<int?>(json['startMinute']),
      endMinute: serializer.fromJson<int?>(json['endMinute']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'startMinute': serializer.toJson<int?>(startMinute),
      'endMinute': serializer.toJson<int?>(endMinute),
    };
  }

  AvailabilityExceptionEntry copyWith({
    String? date,
    Value<int?> startMinute = const Value.absent(),
    Value<int?> endMinute = const Value.absent(),
  }) => AvailabilityExceptionEntry(
    date: date ?? this.date,
    startMinute: startMinute.present ? startMinute.value : this.startMinute,
    endMinute: endMinute.present ? endMinute.value : this.endMinute,
  );
  AvailabilityExceptionEntry copyWithCompanion(
    AvailabilityExceptionEntriesCompanion data,
  ) {
    return AvailabilityExceptionEntry(
      date: data.date.present ? data.date.value : this.date,
      startMinute: data.startMinute.present
          ? data.startMinute.value
          : this.startMinute,
      endMinute: data.endMinute.present ? data.endMinute.value : this.endMinute,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AvailabilityExceptionEntry(')
          ..write('date: $date, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, startMinute, endMinute);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AvailabilityExceptionEntry &&
          other.date == this.date &&
          other.startMinute == this.startMinute &&
          other.endMinute == this.endMinute);
}

class AvailabilityExceptionEntriesCompanion
    extends UpdateCompanion<AvailabilityExceptionEntry> {
  final Value<String> date;
  final Value<int?> startMinute;
  final Value<int?> endMinute;
  final Value<int> rowid;
  const AvailabilityExceptionEntriesCompanion({
    this.date = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AvailabilityExceptionEntriesCompanion.insert({
    required String date,
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<AvailabilityExceptionEntry> custom({
    Expression<String>? date,
    Expression<int>? startMinute,
    Expression<int>? endMinute,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (startMinute != null) 'start_minute': startMinute,
      if (endMinute != null) 'end_minute': endMinute,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AvailabilityExceptionEntriesCompanion copyWith({
    Value<String>? date,
    Value<int?>? startMinute,
    Value<int?>? endMinute,
    Value<int>? rowid,
  }) {
    return AvailabilityExceptionEntriesCompanion(
      date: date ?? this.date,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (startMinute.present) {
      map['start_minute'] = Variable<int>(startMinute.value);
    }
    if (endMinute.present) {
      map['end_minute'] = Variable<int>(endMinute.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AvailabilityExceptionEntriesCompanion(')
          ..write('date: $date, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingEntriesTable extends SettingEntries
    with TableInfo<$SettingEntriesTable, SettingEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'setting_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingEntriesTable createAlias(String alias) {
    return $SettingEntriesTable(attachedDatabase, alias);
  }
}

class SettingEntry extends DataClass implements Insertable<SettingEntry> {
  final String key;
  final String value;
  const SettingEntry({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingEntriesCompanion toCompanion(bool nullToAbsent) {
    return SettingEntriesCompanion(key: Value(key), value: Value(value));
  }

  factory SettingEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingEntry copyWith({String? key, String? value}) =>
      SettingEntry(key: key ?? this.key, value: value ?? this.value);
  SettingEntry copyWithCompanion(SettingEntriesCompanion data) {
    return SettingEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingEntry(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingEntry &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingEntriesCompanion extends UpdateCompanion<SettingEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingEntriesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingEntriesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingEntriesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingEntriesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingEntriesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TaskListEntriesTable taskListEntries = $TaskListEntriesTable(
    this,
  );
  late final $RecurrenceRuleEntriesTable recurrenceRuleEntries =
      $RecurrenceRuleEntriesTable(this);
  late final $ProfileEntriesTable profileEntries = $ProfileEntriesTable(this);
  late final $TaskEntriesTable taskEntries = $TaskEntriesTable(this);
  late final $ScheduleBlockEntriesTable scheduleBlockEntries =
      $ScheduleBlockEntriesTable(this);
  late final $TagEntriesTable tagEntries = $TagEntriesTable(this);
  late final $TaskTagEntriesTable taskTagEntries = $TaskTagEntriesTable(this);
  late final $WeeklyAvailabilityEntriesTable weeklyAvailabilityEntries =
      $WeeklyAvailabilityEntriesTable(this);
  late final $AvailabilityExceptionEntriesTable availabilityExceptionEntries =
      $AvailabilityExceptionEntriesTable(this);
  late final $SettingEntriesTable settingEntries = $SettingEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    taskListEntries,
    recurrenceRuleEntries,
    profileEntries,
    taskEntries,
    scheduleBlockEntries,
    tagEntries,
    taskTagEntries,
    weeklyAvailabilityEntries,
    availabilityExceptionEntries,
    settingEntries,
  ];
}

typedef $$TaskListEntriesTableCreateCompanionBuilder =
    TaskListEntriesCompanion Function({
      required String id,
      required String name,
      required int colorValue,
      required int iconCodePoint,
      required bool isInbox,
      required int createdAtMicros,
      Value<int> rowid,
    });
typedef $$TaskListEntriesTableUpdateCompanionBuilder =
    TaskListEntriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> colorValue,
      Value<int> iconCodePoint,
      Value<bool> isInbox,
      Value<int> createdAtMicros,
      Value<int> rowid,
    });

final class $$TaskListEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $TaskListEntriesTable, TaskListEntry> {
  $$TaskListEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TaskEntriesTable, List<TaskEntry>>
  _taskEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskEntries,
    aliasName: 'task_list_entries__id__task_entries__list_id',
  );

  $$TaskEntriesTableProcessedTableManager get taskEntriesRefs {
    final manager = $$TaskEntriesTableTableManager(
      $_db,
      $_db.taskEntries,
    ).filter((f) => f.listId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaskListEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskListEntriesTable> {
  $$TaskListEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInbox => $composableBuilder(
    column: $table.isInbox,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> taskEntriesRefs(
    Expression<bool> Function($$TaskEntriesTableFilterComposer f) f,
  ) {
    final $$TaskEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableFilterComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskListEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskListEntriesTable> {
  $$TaskListEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInbox => $composableBuilder(
    column: $table.isInbox,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskListEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskListEntriesTable> {
  $$TaskListEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isInbox =>
      $composableBuilder(column: $table.isInbox, builder: (column) => column);

  GeneratedColumn<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => column,
  );

  Expression<T> taskEntriesRefs<T extends Object>(
    Expression<T> Function($$TaskEntriesTableAnnotationComposer a) f,
  ) {
    final $$TaskEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskListEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskListEntriesTable,
          TaskListEntry,
          $$TaskListEntriesTableFilterComposer,
          $$TaskListEntriesTableOrderingComposer,
          $$TaskListEntriesTableAnnotationComposer,
          $$TaskListEntriesTableCreateCompanionBuilder,
          $$TaskListEntriesTableUpdateCompanionBuilder,
          (TaskListEntry, $$TaskListEntriesTableReferences),
          TaskListEntry,
          PrefetchHooks Function({bool taskEntriesRefs})
        > {
  $$TaskListEntriesTableTableManager(
    _$AppDatabase db,
    $TaskListEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskListEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskListEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskListEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<int> iconCodePoint = const Value.absent(),
                Value<bool> isInbox = const Value.absent(),
                Value<int> createdAtMicros = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskListEntriesCompanion(
                id: id,
                name: name,
                colorValue: colorValue,
                iconCodePoint: iconCodePoint,
                isInbox: isInbox,
                createdAtMicros: createdAtMicros,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int colorValue,
                required int iconCodePoint,
                required bool isInbox,
                required int createdAtMicros,
                Value<int> rowid = const Value.absent(),
              }) => TaskListEntriesCompanion.insert(
                id: id,
                name: name,
                colorValue: colorValue,
                iconCodePoint: iconCodePoint,
                isInbox: isInbox,
                createdAtMicros: createdAtMicros,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskListEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (taskEntriesRefs) db.taskEntries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskEntriesRefs)
                    await $_getPrefetchedData<
                      TaskListEntry,
                      $TaskListEntriesTable,
                      TaskEntry
                    >(
                      currentTable: table,
                      referencedTable: $$TaskListEntriesTableReferences
                          ._taskEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TaskListEntriesTableReferences(
                            db,
                            table,
                            p0,
                          ).taskEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.listId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TaskListEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskListEntriesTable,
      TaskListEntry,
      $$TaskListEntriesTableFilterComposer,
      $$TaskListEntriesTableOrderingComposer,
      $$TaskListEntriesTableAnnotationComposer,
      $$TaskListEntriesTableCreateCompanionBuilder,
      $$TaskListEntriesTableUpdateCompanionBuilder,
      (TaskListEntry, $$TaskListEntriesTableReferences),
      TaskListEntry,
      PrefetchHooks Function({bool taskEntriesRefs})
    >;
typedef $$RecurrenceRuleEntriesTableCreateCompanionBuilder =
    RecurrenceRuleEntriesCompanion Function({
      required String id,
      required String frequency,
      required int interval,
      required String weekdays,
      Value<int?> untilDateMicros,
      Value<int?> occurrenceCount,
      Value<int> rowid,
    });
typedef $$RecurrenceRuleEntriesTableUpdateCompanionBuilder =
    RecurrenceRuleEntriesCompanion Function({
      Value<String> id,
      Value<String> frequency,
      Value<int> interval,
      Value<String> weekdays,
      Value<int?> untilDateMicros,
      Value<int?> occurrenceCount,
      Value<int> rowid,
    });

final class $$RecurrenceRuleEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecurrenceRuleEntriesTable,
          RecurrenceRuleEntry
        > {
  $$RecurrenceRuleEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TaskEntriesTable, List<TaskEntry>>
  _taskEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskEntries,
    aliasName: 'recurrence_rule_entries__id__task_entries__recurrence_rule_id',
  );

  $$TaskEntriesTableProcessedTableManager get taskEntriesRefs {
    final manager = $$TaskEntriesTableTableManager($_db, $_db.taskEntries)
        .filter(
          (f) => f.recurrenceRuleId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_taskEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecurrenceRuleEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurrenceRuleEntriesTable> {
  $$RecurrenceRuleEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get untilDateMicros => $composableBuilder(
    column: $table.untilDateMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurrenceCount => $composableBuilder(
    column: $table.occurrenceCount,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> taskEntriesRefs(
    Expression<bool> Function($$TaskEntriesTableFilterComposer f) f,
  ) {
    final $$TaskEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.recurrenceRuleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableFilterComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecurrenceRuleEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurrenceRuleEntriesTable> {
  $$RecurrenceRuleEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get untilDateMicros => $composableBuilder(
    column: $table.untilDateMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurrenceCount => $composableBuilder(
    column: $table.occurrenceCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecurrenceRuleEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurrenceRuleEntriesTable> {
  $$RecurrenceRuleEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<String> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<int> get untilDateMicros => $composableBuilder(
    column: $table.untilDateMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get occurrenceCount => $composableBuilder(
    column: $table.occurrenceCount,
    builder: (column) => column,
  );

  Expression<T> taskEntriesRefs<T extends Object>(
    Expression<T> Function($$TaskEntriesTableAnnotationComposer a) f,
  ) {
    final $$TaskEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.recurrenceRuleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecurrenceRuleEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurrenceRuleEntriesTable,
          RecurrenceRuleEntry,
          $$RecurrenceRuleEntriesTableFilterComposer,
          $$RecurrenceRuleEntriesTableOrderingComposer,
          $$RecurrenceRuleEntriesTableAnnotationComposer,
          $$RecurrenceRuleEntriesTableCreateCompanionBuilder,
          $$RecurrenceRuleEntriesTableUpdateCompanionBuilder,
          (RecurrenceRuleEntry, $$RecurrenceRuleEntriesTableReferences),
          RecurrenceRuleEntry,
          PrefetchHooks Function({bool taskEntriesRefs})
        > {
  $$RecurrenceRuleEntriesTableTableManager(
    _$AppDatabase db,
    $RecurrenceRuleEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurrenceRuleEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecurrenceRuleEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecurrenceRuleEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<int> interval = const Value.absent(),
                Value<String> weekdays = const Value.absent(),
                Value<int?> untilDateMicros = const Value.absent(),
                Value<int?> occurrenceCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurrenceRuleEntriesCompanion(
                id: id,
                frequency: frequency,
                interval: interval,
                weekdays: weekdays,
                untilDateMicros: untilDateMicros,
                occurrenceCount: occurrenceCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String frequency,
                required int interval,
                required String weekdays,
                Value<int?> untilDateMicros = const Value.absent(),
                Value<int?> occurrenceCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurrenceRuleEntriesCompanion.insert(
                id: id,
                frequency: frequency,
                interval: interval,
                weekdays: weekdays,
                untilDateMicros: untilDateMicros,
                occurrenceCount: occurrenceCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecurrenceRuleEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (taskEntriesRefs) db.taskEntries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskEntriesRefs)
                    await $_getPrefetchedData<
                      RecurrenceRuleEntry,
                      $RecurrenceRuleEntriesTable,
                      TaskEntry
                    >(
                      currentTable: table,
                      referencedTable: $$RecurrenceRuleEntriesTableReferences
                          ._taskEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RecurrenceRuleEntriesTableReferences(
                            db,
                            table,
                            p0,
                          ).taskEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.recurrenceRuleId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RecurrenceRuleEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurrenceRuleEntriesTable,
      RecurrenceRuleEntry,
      $$RecurrenceRuleEntriesTableFilterComposer,
      $$RecurrenceRuleEntriesTableOrderingComposer,
      $$RecurrenceRuleEntriesTableAnnotationComposer,
      $$RecurrenceRuleEntriesTableCreateCompanionBuilder,
      $$RecurrenceRuleEntriesTableUpdateCompanionBuilder,
      (RecurrenceRuleEntry, $$RecurrenceRuleEntriesTableReferences),
      RecurrenceRuleEntry,
      PrefetchHooks Function({bool taskEntriesRefs})
    >;
typedef $$ProfileEntriesTableCreateCompanionBuilder =
    ProfileEntriesCompanion Function({
      required String id,
      required String name,
      required int colorValue,
      required bool isMe,
      Value<int> rowid,
    });
typedef $$ProfileEntriesTableUpdateCompanionBuilder =
    ProfileEntriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> colorValue,
      Value<bool> isMe,
      Value<int> rowid,
    });

final class $$ProfileEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $ProfileEntriesTable, ProfileEntry> {
  $$ProfileEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TaskEntriesTable, List<TaskEntry>>
  _taskEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskEntries,
    aliasName: 'profile_entries__id__task_entries__assignee_profile_id',
  );

  $$TaskEntriesTableProcessedTableManager get taskEntriesRefs {
    final manager = $$TaskEntriesTableTableManager($_db, $_db.taskEntries)
        .filter(
          (f) => f.assigneeProfileId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_taskEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProfileEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfileEntriesTable> {
  $$ProfileEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMe => $composableBuilder(
    column: $table.isMe,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> taskEntriesRefs(
    Expression<bool> Function($$TaskEntriesTableFilterComposer f) f,
  ) {
    final $$TaskEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.assigneeProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableFilterComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfileEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfileEntriesTable> {
  $$ProfileEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMe => $composableBuilder(
    column: $table.isMe,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfileEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfileEntriesTable> {
  $$ProfileEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isMe =>
      $composableBuilder(column: $table.isMe, builder: (column) => column);

  Expression<T> taskEntriesRefs<T extends Object>(
    Expression<T> Function($$TaskEntriesTableAnnotationComposer a) f,
  ) {
    final $$TaskEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.assigneeProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfileEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfileEntriesTable,
          ProfileEntry,
          $$ProfileEntriesTableFilterComposer,
          $$ProfileEntriesTableOrderingComposer,
          $$ProfileEntriesTableAnnotationComposer,
          $$ProfileEntriesTableCreateCompanionBuilder,
          $$ProfileEntriesTableUpdateCompanionBuilder,
          (ProfileEntry, $$ProfileEntriesTableReferences),
          ProfileEntry,
          PrefetchHooks Function({bool taskEntriesRefs})
        > {
  $$ProfileEntriesTableTableManager(
    _$AppDatabase db,
    $ProfileEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfileEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfileEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfileEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<bool> isMe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfileEntriesCompanion(
                id: id,
                name: name,
                colorValue: colorValue,
                isMe: isMe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int colorValue,
                required bool isMe,
                Value<int> rowid = const Value.absent(),
              }) => ProfileEntriesCompanion.insert(
                id: id,
                name: name,
                colorValue: colorValue,
                isMe: isMe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProfileEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (taskEntriesRefs) db.taskEntries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskEntriesRefs)
                    await $_getPrefetchedData<
                      ProfileEntry,
                      $ProfileEntriesTable,
                      TaskEntry
                    >(
                      currentTable: table,
                      referencedTable: $$ProfileEntriesTableReferences
                          ._taskEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProfileEntriesTableReferences(
                            db,
                            table,
                            p0,
                          ).taskEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.assigneeProfileId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProfileEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfileEntriesTable,
      ProfileEntry,
      $$ProfileEntriesTableFilterComposer,
      $$ProfileEntriesTableOrderingComposer,
      $$ProfileEntriesTableAnnotationComposer,
      $$ProfileEntriesTableCreateCompanionBuilder,
      $$ProfileEntriesTableUpdateCompanionBuilder,
      (ProfileEntry, $$ProfileEntriesTableReferences),
      ProfileEntry,
      PrefetchHooks Function({bool taskEntriesRefs})
    >;
typedef $$TaskEntriesTableCreateCompanionBuilder =
    TaskEntriesCompanion Function({
      required String id,
      required String title,
      Value<String?> notes,
      required String listId,
      Value<String?> parentTaskId,
      required String status,
      required String priority,
      Value<int?> earliestStartMicros,
      Value<int?> deadlineMicros,
      Value<int?> estimatedMinutes,
      Value<int?> remainingMinutes,
      required bool allowSplit,
      required int minimumSessionMinutes,
      required int maximumSessionMinutes,
      Value<String?> recurrenceRuleId,
      Value<String?> recurrenceSeriesId,
      Value<int?> occurrenceDateMicros,
      Value<String?> assigneeProfileId,
      required bool includeInMyPlan,
      required int createdAtMicros,
      required int updatedAtMicros,
      Value<int?> completedAtMicros,
      Value<int> rowid,
    });
typedef $$TaskEntriesTableUpdateCompanionBuilder =
    TaskEntriesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> notes,
      Value<String> listId,
      Value<String?> parentTaskId,
      Value<String> status,
      Value<String> priority,
      Value<int?> earliestStartMicros,
      Value<int?> deadlineMicros,
      Value<int?> estimatedMinutes,
      Value<int?> remainingMinutes,
      Value<bool> allowSplit,
      Value<int> minimumSessionMinutes,
      Value<int> maximumSessionMinutes,
      Value<String?> recurrenceRuleId,
      Value<String?> recurrenceSeriesId,
      Value<int?> occurrenceDateMicros,
      Value<String?> assigneeProfileId,
      Value<bool> includeInMyPlan,
      Value<int> createdAtMicros,
      Value<int> updatedAtMicros,
      Value<int?> completedAtMicros,
      Value<int> rowid,
    });

final class $$TaskEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $TaskEntriesTable, TaskEntry> {
  $$TaskEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TaskListEntriesTable _listIdTable(_$AppDatabase db) => db
      .taskListEntries
      .createAlias('task_entries__list_id__task_list_entries__id');

  $$TaskListEntriesTableProcessedTableManager get listId {
    final $_column = $_itemColumn<String>('list_id')!;

    final manager = $$TaskListEntriesTableTableManager(
      $_db,
      $_db.taskListEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RecurrenceRuleEntriesTable _recurrenceRuleIdTable(_$AppDatabase db) =>
      db.recurrenceRuleEntries.createAlias(
        'task_entries__recurrence_rule_id__recurrence_rule_entries__id',
      );

  $$RecurrenceRuleEntriesTableProcessedTableManager? get recurrenceRuleId {
    final $_column = $_itemColumn<String>('recurrence_rule_id');
    if ($_column == null) return null;
    final manager = $$RecurrenceRuleEntriesTableTableManager(
      $_db,
      $_db.recurrenceRuleEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recurrenceRuleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProfileEntriesTable _assigneeProfileIdTable(_$AppDatabase db) => db
      .profileEntries
      .createAlias('task_entries__assignee_profile_id__profile_entries__id');

  $$ProfileEntriesTableProcessedTableManager? get assigneeProfileId {
    final $_column = $_itemColumn<String>('assignee_profile_id');
    if ($_column == null) return null;
    final manager = $$ProfileEntriesTableTableManager(
      $_db,
      $_db.profileEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assigneeProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ScheduleBlockEntriesTable,
    List<ScheduleBlockEntry>
  >
  _scheduleBlockEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.scheduleBlockEntries,
        aliasName: 'task_entries__id__schedule_block_entries__task_id',
      );

  $$ScheduleBlockEntriesTableProcessedTableManager
  get scheduleBlockEntriesRefs {
    final manager = $$ScheduleBlockEntriesTableTableManager(
      $_db,
      $_db.scheduleBlockEntries,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _scheduleBlockEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskTagEntriesTable, List<TaskTagEntry>>
  _taskTagEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskTagEntries,
    aliasName: 'task_entries__id__task_tag_entries__task_id',
  );

  $$TaskTagEntriesTableProcessedTableManager get taskTagEntriesRefs {
    final manager = $$TaskTagEntriesTableTableManager(
      $_db,
      $_db.taskTagEntries,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskTagEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaskEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskEntriesTable> {
  $$TaskEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentTaskId => $composableBuilder(
    column: $table.parentTaskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get earliestStartMicros => $composableBuilder(
    column: $table.earliestStartMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deadlineMicros => $composableBuilder(
    column: $table.deadlineMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingMinutes => $composableBuilder(
    column: $table.remainingMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allowSplit => $composableBuilder(
    column: $table.allowSplit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minimumSessionMinutes => $composableBuilder(
    column: $table.minimumSessionMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maximumSessionMinutes => $composableBuilder(
    column: $table.maximumSessionMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceSeriesId => $composableBuilder(
    column: $table.recurrenceSeriesId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurrenceDateMicros => $composableBuilder(
    column: $table.occurrenceDateMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get includeInMyPlan => $composableBuilder(
    column: $table.includeInMyPlan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMicros => $composableBuilder(
    column: $table.updatedAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAtMicros => $composableBuilder(
    column: $table.completedAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  $$TaskListEntriesTableFilterComposer get listId {
    final $$TaskListEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.taskListEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskListEntriesTableFilterComposer(
            $db: $db,
            $table: $db.taskListEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecurrenceRuleEntriesTableFilterComposer get recurrenceRuleId {
    final $$RecurrenceRuleEntriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.recurrenceRuleId,
          referencedTable: $db.recurrenceRuleEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurrenceRuleEntriesTableFilterComposer(
                $db: $db,
                $table: $db.recurrenceRuleEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ProfileEntriesTableFilterComposer get assigneeProfileId {
    final $$ProfileEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assigneeProfileId,
      referencedTable: $db.profileEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfileEntriesTableFilterComposer(
            $db: $db,
            $table: $db.profileEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> scheduleBlockEntriesRefs(
    Expression<bool> Function($$ScheduleBlockEntriesTableFilterComposer f) f,
  ) {
    final $$ScheduleBlockEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleBlockEntries,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleBlockEntriesTableFilterComposer(
            $db: $db,
            $table: $db.scheduleBlockEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> taskTagEntriesRefs(
    Expression<bool> Function($$TaskTagEntriesTableFilterComposer f) f,
  ) {
    final $$TaskTagEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskTagEntries,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTagEntriesTableFilterComposer(
            $db: $db,
            $table: $db.taskTagEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskEntriesTable> {
  $$TaskEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentTaskId => $composableBuilder(
    column: $table.parentTaskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get earliestStartMicros => $composableBuilder(
    column: $table.earliestStartMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deadlineMicros => $composableBuilder(
    column: $table.deadlineMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingMinutes => $composableBuilder(
    column: $table.remainingMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allowSplit => $composableBuilder(
    column: $table.allowSplit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minimumSessionMinutes => $composableBuilder(
    column: $table.minimumSessionMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maximumSessionMinutes => $composableBuilder(
    column: $table.maximumSessionMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceSeriesId => $composableBuilder(
    column: $table.recurrenceSeriesId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurrenceDateMicros => $composableBuilder(
    column: $table.occurrenceDateMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get includeInMyPlan => $composableBuilder(
    column: $table.includeInMyPlan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMicros => $composableBuilder(
    column: $table.updatedAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAtMicros => $composableBuilder(
    column: $table.completedAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskListEntriesTableOrderingComposer get listId {
    final $$TaskListEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.taskListEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskListEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.taskListEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecurrenceRuleEntriesTableOrderingComposer get recurrenceRuleId {
    final $$RecurrenceRuleEntriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.recurrenceRuleId,
          referencedTable: $db.recurrenceRuleEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurrenceRuleEntriesTableOrderingComposer(
                $db: $db,
                $table: $db.recurrenceRuleEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ProfileEntriesTableOrderingComposer get assigneeProfileId {
    final $$ProfileEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assigneeProfileId,
      referencedTable: $db.profileEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfileEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.profileEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskEntriesTable> {
  $$TaskEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get parentTaskId => $composableBuilder(
    column: $table.parentTaskId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get earliestStartMicros => $composableBuilder(
    column: $table.earliestStartMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deadlineMicros => $composableBuilder(
    column: $table.deadlineMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remainingMinutes => $composableBuilder(
    column: $table.remainingMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get allowSplit => $composableBuilder(
    column: $table.allowSplit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minimumSessionMinutes => $composableBuilder(
    column: $table.minimumSessionMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maximumSessionMinutes => $composableBuilder(
    column: $table.maximumSessionMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrenceSeriesId => $composableBuilder(
    column: $table.recurrenceSeriesId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get occurrenceDateMicros => $composableBuilder(
    column: $table.occurrenceDateMicros,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get includeInMyPlan => $composableBuilder(
    column: $table.includeInMyPlan,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMicros => $composableBuilder(
    column: $table.updatedAtMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedAtMicros => $composableBuilder(
    column: $table.completedAtMicros,
    builder: (column) => column,
  );

  $$TaskListEntriesTableAnnotationComposer get listId {
    final $$TaskListEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.taskListEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskListEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskListEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecurrenceRuleEntriesTableAnnotationComposer get recurrenceRuleId {
    final $$RecurrenceRuleEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.recurrenceRuleId,
          referencedTable: $db.recurrenceRuleEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurrenceRuleEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.recurrenceRuleEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ProfileEntriesTableAnnotationComposer get assigneeProfileId {
    final $$ProfileEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assigneeProfileId,
      referencedTable: $db.profileEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfileEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.profileEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> scheduleBlockEntriesRefs<T extends Object>(
    Expression<T> Function($$ScheduleBlockEntriesTableAnnotationComposer a) f,
  ) {
    final $$ScheduleBlockEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.scheduleBlockEntries,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ScheduleBlockEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.scheduleBlockEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> taskTagEntriesRefs<T extends Object>(
    Expression<T> Function($$TaskTagEntriesTableAnnotationComposer a) f,
  ) {
    final $$TaskTagEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskTagEntries,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTagEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskTagEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskEntriesTable,
          TaskEntry,
          $$TaskEntriesTableFilterComposer,
          $$TaskEntriesTableOrderingComposer,
          $$TaskEntriesTableAnnotationComposer,
          $$TaskEntriesTableCreateCompanionBuilder,
          $$TaskEntriesTableUpdateCompanionBuilder,
          (TaskEntry, $$TaskEntriesTableReferences),
          TaskEntry,
          PrefetchHooks Function({
            bool listId,
            bool recurrenceRuleId,
            bool assigneeProfileId,
            bool scheduleBlockEntriesRefs,
            bool taskTagEntriesRefs,
          })
        > {
  $$TaskEntriesTableTableManager(_$AppDatabase db, $TaskEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> listId = const Value.absent(),
                Value<String?> parentTaskId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<int?> earliestStartMicros = const Value.absent(),
                Value<int?> deadlineMicros = const Value.absent(),
                Value<int?> estimatedMinutes = const Value.absent(),
                Value<int?> remainingMinutes = const Value.absent(),
                Value<bool> allowSplit = const Value.absent(),
                Value<int> minimumSessionMinutes = const Value.absent(),
                Value<int> maximumSessionMinutes = const Value.absent(),
                Value<String?> recurrenceRuleId = const Value.absent(),
                Value<String?> recurrenceSeriesId = const Value.absent(),
                Value<int?> occurrenceDateMicros = const Value.absent(),
                Value<String?> assigneeProfileId = const Value.absent(),
                Value<bool> includeInMyPlan = const Value.absent(),
                Value<int> createdAtMicros = const Value.absent(),
                Value<int> updatedAtMicros = const Value.absent(),
                Value<int?> completedAtMicros = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskEntriesCompanion(
                id: id,
                title: title,
                notes: notes,
                listId: listId,
                parentTaskId: parentTaskId,
                status: status,
                priority: priority,
                earliestStartMicros: earliestStartMicros,
                deadlineMicros: deadlineMicros,
                estimatedMinutes: estimatedMinutes,
                remainingMinutes: remainingMinutes,
                allowSplit: allowSplit,
                minimumSessionMinutes: minimumSessionMinutes,
                maximumSessionMinutes: maximumSessionMinutes,
                recurrenceRuleId: recurrenceRuleId,
                recurrenceSeriesId: recurrenceSeriesId,
                occurrenceDateMicros: occurrenceDateMicros,
                assigneeProfileId: assigneeProfileId,
                includeInMyPlan: includeInMyPlan,
                createdAtMicros: createdAtMicros,
                updatedAtMicros: updatedAtMicros,
                completedAtMicros: completedAtMicros,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> notes = const Value.absent(),
                required String listId,
                Value<String?> parentTaskId = const Value.absent(),
                required String status,
                required String priority,
                Value<int?> earliestStartMicros = const Value.absent(),
                Value<int?> deadlineMicros = const Value.absent(),
                Value<int?> estimatedMinutes = const Value.absent(),
                Value<int?> remainingMinutes = const Value.absent(),
                required bool allowSplit,
                required int minimumSessionMinutes,
                required int maximumSessionMinutes,
                Value<String?> recurrenceRuleId = const Value.absent(),
                Value<String?> recurrenceSeriesId = const Value.absent(),
                Value<int?> occurrenceDateMicros = const Value.absent(),
                Value<String?> assigneeProfileId = const Value.absent(),
                required bool includeInMyPlan,
                required int createdAtMicros,
                required int updatedAtMicros,
                Value<int?> completedAtMicros = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskEntriesCompanion.insert(
                id: id,
                title: title,
                notes: notes,
                listId: listId,
                parentTaskId: parentTaskId,
                status: status,
                priority: priority,
                earliestStartMicros: earliestStartMicros,
                deadlineMicros: deadlineMicros,
                estimatedMinutes: estimatedMinutes,
                remainingMinutes: remainingMinutes,
                allowSplit: allowSplit,
                minimumSessionMinutes: minimumSessionMinutes,
                maximumSessionMinutes: maximumSessionMinutes,
                recurrenceRuleId: recurrenceRuleId,
                recurrenceSeriesId: recurrenceSeriesId,
                occurrenceDateMicros: occurrenceDateMicros,
                assigneeProfileId: assigneeProfileId,
                includeInMyPlan: includeInMyPlan,
                createdAtMicros: createdAtMicros,
                updatedAtMicros: updatedAtMicros,
                completedAtMicros: completedAtMicros,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                listId = false,
                recurrenceRuleId = false,
                assigneeProfileId = false,
                scheduleBlockEntriesRefs = false,
                taskTagEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (scheduleBlockEntriesRefs) db.scheduleBlockEntries,
                    if (taskTagEntriesRefs) db.taskTagEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (listId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.listId,
                                    referencedTable:
                                        $$TaskEntriesTableReferences
                                            ._listIdTable(db),
                                    referencedColumn:
                                        $$TaskEntriesTableReferences
                                            ._listIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (recurrenceRuleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.recurrenceRuleId,
                                    referencedTable:
                                        $$TaskEntriesTableReferences
                                            ._recurrenceRuleIdTable(db),
                                    referencedColumn:
                                        $$TaskEntriesTableReferences
                                            ._recurrenceRuleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (assigneeProfileId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.assigneeProfileId,
                                    referencedTable:
                                        $$TaskEntriesTableReferences
                                            ._assigneeProfileIdTable(db),
                                    referencedColumn:
                                        $$TaskEntriesTableReferences
                                            ._assigneeProfileIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (scheduleBlockEntriesRefs)
                        await $_getPrefetchedData<
                          TaskEntry,
                          $TaskEntriesTable,
                          ScheduleBlockEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TaskEntriesTableReferences
                              ._scheduleBlockEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TaskEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).scheduleBlockEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (taskTagEntriesRefs)
                        await $_getPrefetchedData<
                          TaskEntry,
                          $TaskEntriesTable,
                          TaskTagEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TaskEntriesTableReferences
                              ._taskTagEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TaskEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).taskTagEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TaskEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskEntriesTable,
      TaskEntry,
      $$TaskEntriesTableFilterComposer,
      $$TaskEntriesTableOrderingComposer,
      $$TaskEntriesTableAnnotationComposer,
      $$TaskEntriesTableCreateCompanionBuilder,
      $$TaskEntriesTableUpdateCompanionBuilder,
      (TaskEntry, $$TaskEntriesTableReferences),
      TaskEntry,
      PrefetchHooks Function({
        bool listId,
        bool recurrenceRuleId,
        bool assigneeProfileId,
        bool scheduleBlockEntriesRefs,
        bool taskTagEntriesRefs,
      })
    >;
typedef $$ScheduleBlockEntriesTableCreateCompanionBuilder =
    ScheduleBlockEntriesCompanion Function({
      required String id,
      Value<String?> taskId,
      required int startMicros,
      required int endMicros,
      required String state,
      required bool isLocked,
      required String completionState,
      Value<String?> note,
      required bool isGenerated,
      Value<int> rowid,
    });
typedef $$ScheduleBlockEntriesTableUpdateCompanionBuilder =
    ScheduleBlockEntriesCompanion Function({
      Value<String> id,
      Value<String?> taskId,
      Value<int> startMicros,
      Value<int> endMicros,
      Value<String> state,
      Value<bool> isLocked,
      Value<String> completionState,
      Value<String?> note,
      Value<bool> isGenerated,
      Value<int> rowid,
    });

final class $$ScheduleBlockEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ScheduleBlockEntriesTable,
          ScheduleBlockEntry
        > {
  $$ScheduleBlockEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TaskEntriesTable _taskIdTable(_$AppDatabase db) => db.taskEntries
      .createAlias('schedule_block_entries__task_id__task_entries__id');

  $$TaskEntriesTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<String>('task_id');
    if ($_column == null) return null;
    final manager = $$TaskEntriesTableTableManager(
      $_db,
      $_db.taskEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScheduleBlockEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduleBlockEntriesTable> {
  $$ScheduleBlockEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMicros => $composableBuilder(
    column: $table.startMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMicros => $composableBuilder(
    column: $table.endMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completionState => $composableBuilder(
    column: $table.completionState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGenerated => $composableBuilder(
    column: $table.isGenerated,
    builder: (column) => ColumnFilters(column),
  );

  $$TaskEntriesTableFilterComposer get taskId {
    final $$TaskEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableFilterComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduleBlockEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduleBlockEntriesTable> {
  $$ScheduleBlockEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMicros => $composableBuilder(
    column: $table.startMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMicros => $composableBuilder(
    column: $table.endMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completionState => $composableBuilder(
    column: $table.completionState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGenerated => $composableBuilder(
    column: $table.isGenerated,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskEntriesTableOrderingComposer get taskId {
    final $$TaskEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduleBlockEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduleBlockEntriesTable> {
  $$ScheduleBlockEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startMicros => $composableBuilder(
    column: $table.startMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMicros =>
      $composableBuilder(column: $table.endMicros, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<bool> get isLocked =>
      $composableBuilder(column: $table.isLocked, builder: (column) => column);

  GeneratedColumn<String> get completionState => $composableBuilder(
    column: $table.completionState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isGenerated => $composableBuilder(
    column: $table.isGenerated,
    builder: (column) => column,
  );

  $$TaskEntriesTableAnnotationComposer get taskId {
    final $$TaskEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduleBlockEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduleBlockEntriesTable,
          ScheduleBlockEntry,
          $$ScheduleBlockEntriesTableFilterComposer,
          $$ScheduleBlockEntriesTableOrderingComposer,
          $$ScheduleBlockEntriesTableAnnotationComposer,
          $$ScheduleBlockEntriesTableCreateCompanionBuilder,
          $$ScheduleBlockEntriesTableUpdateCompanionBuilder,
          (ScheduleBlockEntry, $$ScheduleBlockEntriesTableReferences),
          ScheduleBlockEntry,
          PrefetchHooks Function({bool taskId})
        > {
  $$ScheduleBlockEntriesTableTableManager(
    _$AppDatabase db,
    $ScheduleBlockEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduleBlockEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduleBlockEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ScheduleBlockEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<int> startMicros = const Value.absent(),
                Value<int> endMicros = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
                Value<String> completionState = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> isGenerated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduleBlockEntriesCompanion(
                id: id,
                taskId: taskId,
                startMicros: startMicros,
                endMicros: endMicros,
                state: state,
                isLocked: isLocked,
                completionState: completionState,
                note: note,
                isGenerated: isGenerated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> taskId = const Value.absent(),
                required int startMicros,
                required int endMicros,
                required String state,
                required bool isLocked,
                required String completionState,
                Value<String?> note = const Value.absent(),
                required bool isGenerated,
                Value<int> rowid = const Value.absent(),
              }) => ScheduleBlockEntriesCompanion.insert(
                id: id,
                taskId: taskId,
                startMicros: startMicros,
                endMicros: endMicros,
                state: state,
                isLocked: isLocked,
                completionState: completionState,
                note: note,
                isGenerated: isGenerated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ScheduleBlockEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable:
                                    $$ScheduleBlockEntriesTableReferences
                                        ._taskIdTable(db),
                                referencedColumn:
                                    $$ScheduleBlockEntriesTableReferences
                                        ._taskIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScheduleBlockEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduleBlockEntriesTable,
      ScheduleBlockEntry,
      $$ScheduleBlockEntriesTableFilterComposer,
      $$ScheduleBlockEntriesTableOrderingComposer,
      $$ScheduleBlockEntriesTableAnnotationComposer,
      $$ScheduleBlockEntriesTableCreateCompanionBuilder,
      $$ScheduleBlockEntriesTableUpdateCompanionBuilder,
      (ScheduleBlockEntry, $$ScheduleBlockEntriesTableReferences),
      ScheduleBlockEntry,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$TagEntriesTableCreateCompanionBuilder =
    TagEntriesCompanion Function({
      required String id,
      required String name,
      required int colorValue,
      Value<int> rowid,
    });
typedef $$TagEntriesTableUpdateCompanionBuilder =
    TagEntriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> colorValue,
      Value<int> rowid,
    });

final class $$TagEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $TagEntriesTable, TagEntry> {
  $$TagEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TaskTagEntriesTable, List<TaskTagEntry>>
  _taskTagEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskTagEntries,
    aliasName: 'tag_entries__id__task_tag_entries__tag_id',
  );

  $$TaskTagEntriesTableProcessedTableManager get taskTagEntriesRefs {
    final manager = $$TaskTagEntriesTableTableManager(
      $_db,
      $_db.taskTagEntries,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskTagEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TagEntriesTable> {
  $$TagEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> taskTagEntriesRefs(
    Expression<bool> Function($$TaskTagEntriesTableFilterComposer f) f,
  ) {
    final $$TaskTagEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskTagEntries,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTagEntriesTableFilterComposer(
            $db: $db,
            $table: $db.taskTagEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TagEntriesTable> {
  $$TagEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagEntriesTable> {
  $$TagEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  Expression<T> taskTagEntriesRefs<T extends Object>(
    Expression<T> Function($$TaskTagEntriesTableAnnotationComposer a) f,
  ) {
    final $$TaskTagEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskTagEntries,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTagEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskTagEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagEntriesTable,
          TagEntry,
          $$TagEntriesTableFilterComposer,
          $$TagEntriesTableOrderingComposer,
          $$TagEntriesTableAnnotationComposer,
          $$TagEntriesTableCreateCompanionBuilder,
          $$TagEntriesTableUpdateCompanionBuilder,
          (TagEntry, $$TagEntriesTableReferences),
          TagEntry,
          PrefetchHooks Function({bool taskTagEntriesRefs})
        > {
  $$TagEntriesTableTableManager(_$AppDatabase db, $TagEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagEntriesCompanion(
                id: id,
                name: name,
                colorValue: colorValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int colorValue,
                Value<int> rowid = const Value.absent(),
              }) => TagEntriesCompanion.insert(
                id: id,
                name: name,
                colorValue: colorValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TagEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskTagEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (taskTagEntriesRefs) db.taskTagEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskTagEntriesRefs)
                    await $_getPrefetchedData<
                      TagEntry,
                      $TagEntriesTable,
                      TaskTagEntry
                    >(
                      currentTable: table,
                      referencedTable: $$TagEntriesTableReferences
                          ._taskTagEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TagEntriesTableReferences(
                            db,
                            table,
                            p0,
                          ).taskTagEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagEntriesTable,
      TagEntry,
      $$TagEntriesTableFilterComposer,
      $$TagEntriesTableOrderingComposer,
      $$TagEntriesTableAnnotationComposer,
      $$TagEntriesTableCreateCompanionBuilder,
      $$TagEntriesTableUpdateCompanionBuilder,
      (TagEntry, $$TagEntriesTableReferences),
      TagEntry,
      PrefetchHooks Function({bool taskTagEntriesRefs})
    >;
typedef $$TaskTagEntriesTableCreateCompanionBuilder =
    TaskTagEntriesCompanion Function({
      required String taskId,
      required String tagId,
      Value<int> rowid,
    });
typedef $$TaskTagEntriesTableUpdateCompanionBuilder =
    TaskTagEntriesCompanion Function({
      Value<String> taskId,
      Value<String> tagId,
      Value<int> rowid,
    });

final class $$TaskTagEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $TaskTagEntriesTable, TaskTagEntry> {
  $$TaskTagEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TaskEntriesTable _taskIdTable(_$AppDatabase db) =>
      db.taskEntries.createAlias('task_tag_entries__task_id__task_entries__id');

  $$TaskEntriesTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TaskEntriesTableTableManager(
      $_db,
      $_db.taskEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagEntriesTable _tagIdTable(_$AppDatabase db) =>
      db.tagEntries.createAlias('task_tag_entries__tag_id__tag_entries__id');

  $$TagEntriesTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagEntriesTableTableManager(
      $_db,
      $_db.tagEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskTagEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskTagEntriesTable> {
  $$TaskTagEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TaskEntriesTableFilterComposer get taskId {
    final $$TaskEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableFilterComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagEntriesTableFilterComposer get tagId {
    final $$TagEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tagEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagEntriesTableFilterComposer(
            $db: $db,
            $table: $db.tagEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskTagEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskTagEntriesTable> {
  $$TaskTagEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TaskEntriesTableOrderingComposer get taskId {
    final $$TaskEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagEntriesTableOrderingComposer get tagId {
    final $$TagEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tagEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.tagEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskTagEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskTagEntriesTable> {
  $$TaskTagEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TaskEntriesTableAnnotationComposer get taskId {
    final $$TaskEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagEntriesTableAnnotationComposer get tagId {
    final $$TagEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tagEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.tagEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskTagEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskTagEntriesTable,
          TaskTagEntry,
          $$TaskTagEntriesTableFilterComposer,
          $$TaskTagEntriesTableOrderingComposer,
          $$TaskTagEntriesTableAnnotationComposer,
          $$TaskTagEntriesTableCreateCompanionBuilder,
          $$TaskTagEntriesTableUpdateCompanionBuilder,
          (TaskTagEntry, $$TaskTagEntriesTableReferences),
          TaskTagEntry,
          PrefetchHooks Function({bool taskId, bool tagId})
        > {
  $$TaskTagEntriesTableTableManager(
    _$AppDatabase db,
    $TaskTagEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskTagEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskTagEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskTagEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> taskId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskTagEntriesCompanion(
                taskId: taskId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String taskId,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => TaskTagEntriesCompanion.insert(
                taskId: taskId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskTagEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$TaskTagEntriesTableReferences
                                    ._taskIdTable(db),
                                referencedColumn:
                                    $$TaskTagEntriesTableReferences
                                        ._taskIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $$TaskTagEntriesTableReferences
                                    ._tagIdTable(db),
                                referencedColumn:
                                    $$TaskTagEntriesTableReferences
                                        ._tagIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaskTagEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskTagEntriesTable,
      TaskTagEntry,
      $$TaskTagEntriesTableFilterComposer,
      $$TaskTagEntriesTableOrderingComposer,
      $$TaskTagEntriesTableAnnotationComposer,
      $$TaskTagEntriesTableCreateCompanionBuilder,
      $$TaskTagEntriesTableUpdateCompanionBuilder,
      (TaskTagEntry, $$TaskTagEntriesTableReferences),
      TaskTagEntry,
      PrefetchHooks Function({bool taskId, bool tagId})
    >;
typedef $$WeeklyAvailabilityEntriesTableCreateCompanionBuilder =
    WeeklyAvailabilityEntriesCompanion Function({
      required int weekday,
      required int startMinute,
      required int endMinute,
      Value<int> rowid,
    });
typedef $$WeeklyAvailabilityEntriesTableUpdateCompanionBuilder =
    WeeklyAvailabilityEntriesCompanion Function({
      Value<int> weekday,
      Value<int> startMinute,
      Value<int> endMinute,
      Value<int> rowid,
    });

class $$WeeklyAvailabilityEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyAvailabilityEntriesTable> {
  $$WeeklyAvailabilityEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyAvailabilityEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyAvailabilityEntriesTable> {
  $$WeeklyAvailabilityEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyAvailabilityEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyAvailabilityEntriesTable> {
  $$WeeklyAvailabilityEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinute =>
      $composableBuilder(column: $table.endMinute, builder: (column) => column);
}

class $$WeeklyAvailabilityEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyAvailabilityEntriesTable,
          WeeklyAvailabilityEntry,
          $$WeeklyAvailabilityEntriesTableFilterComposer,
          $$WeeklyAvailabilityEntriesTableOrderingComposer,
          $$WeeklyAvailabilityEntriesTableAnnotationComposer,
          $$WeeklyAvailabilityEntriesTableCreateCompanionBuilder,
          $$WeeklyAvailabilityEntriesTableUpdateCompanionBuilder,
          (
            WeeklyAvailabilityEntry,
            BaseReferences<
              _$AppDatabase,
              $WeeklyAvailabilityEntriesTable,
              WeeklyAvailabilityEntry
            >,
          ),
          WeeklyAvailabilityEntry,
          PrefetchHooks Function()
        > {
  $$WeeklyAvailabilityEntriesTableTableManager(
    _$AppDatabase db,
    $WeeklyAvailabilityEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyAvailabilityEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WeeklyAvailabilityEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WeeklyAvailabilityEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> weekday = const Value.absent(),
                Value<int> startMinute = const Value.absent(),
                Value<int> endMinute = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyAvailabilityEntriesCompanion(
                weekday: weekday,
                startMinute: startMinute,
                endMinute: endMinute,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int weekday,
                required int startMinute,
                required int endMinute,
                Value<int> rowid = const Value.absent(),
              }) => WeeklyAvailabilityEntriesCompanion.insert(
                weekday: weekday,
                startMinute: startMinute,
                endMinute: endMinute,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyAvailabilityEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyAvailabilityEntriesTable,
      WeeklyAvailabilityEntry,
      $$WeeklyAvailabilityEntriesTableFilterComposer,
      $$WeeklyAvailabilityEntriesTableOrderingComposer,
      $$WeeklyAvailabilityEntriesTableAnnotationComposer,
      $$WeeklyAvailabilityEntriesTableCreateCompanionBuilder,
      $$WeeklyAvailabilityEntriesTableUpdateCompanionBuilder,
      (
        WeeklyAvailabilityEntry,
        BaseReferences<
          _$AppDatabase,
          $WeeklyAvailabilityEntriesTable,
          WeeklyAvailabilityEntry
        >,
      ),
      WeeklyAvailabilityEntry,
      PrefetchHooks Function()
    >;
typedef $$AvailabilityExceptionEntriesTableCreateCompanionBuilder =
    AvailabilityExceptionEntriesCompanion Function({
      required String date,
      Value<int?> startMinute,
      Value<int?> endMinute,
      Value<int> rowid,
    });
typedef $$AvailabilityExceptionEntriesTableUpdateCompanionBuilder =
    AvailabilityExceptionEntriesCompanion Function({
      Value<String> date,
      Value<int?> startMinute,
      Value<int?> endMinute,
      Value<int> rowid,
    });

class $$AvailabilityExceptionEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AvailabilityExceptionEntriesTable> {
  $$AvailabilityExceptionEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AvailabilityExceptionEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AvailabilityExceptionEntriesTable> {
  $$AvailabilityExceptionEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AvailabilityExceptionEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AvailabilityExceptionEntriesTable> {
  $$AvailabilityExceptionEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinute =>
      $composableBuilder(column: $table.endMinute, builder: (column) => column);
}

class $$AvailabilityExceptionEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AvailabilityExceptionEntriesTable,
          AvailabilityExceptionEntry,
          $$AvailabilityExceptionEntriesTableFilterComposer,
          $$AvailabilityExceptionEntriesTableOrderingComposer,
          $$AvailabilityExceptionEntriesTableAnnotationComposer,
          $$AvailabilityExceptionEntriesTableCreateCompanionBuilder,
          $$AvailabilityExceptionEntriesTableUpdateCompanionBuilder,
          (
            AvailabilityExceptionEntry,
            BaseReferences<
              _$AppDatabase,
              $AvailabilityExceptionEntriesTable,
              AvailabilityExceptionEntry
            >,
          ),
          AvailabilityExceptionEntry,
          PrefetchHooks Function()
        > {
  $$AvailabilityExceptionEntriesTableTableManager(
    _$AppDatabase db,
    $AvailabilityExceptionEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AvailabilityExceptionEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AvailabilityExceptionEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AvailabilityExceptionEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int?> startMinute = const Value.absent(),
                Value<int?> endMinute = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AvailabilityExceptionEntriesCompanion(
                date: date,
                startMinute: startMinute,
                endMinute: endMinute,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                Value<int?> startMinute = const Value.absent(),
                Value<int?> endMinute = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AvailabilityExceptionEntriesCompanion.insert(
                date: date,
                startMinute: startMinute,
                endMinute: endMinute,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AvailabilityExceptionEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AvailabilityExceptionEntriesTable,
      AvailabilityExceptionEntry,
      $$AvailabilityExceptionEntriesTableFilterComposer,
      $$AvailabilityExceptionEntriesTableOrderingComposer,
      $$AvailabilityExceptionEntriesTableAnnotationComposer,
      $$AvailabilityExceptionEntriesTableCreateCompanionBuilder,
      $$AvailabilityExceptionEntriesTableUpdateCompanionBuilder,
      (
        AvailabilityExceptionEntry,
        BaseReferences<
          _$AppDatabase,
          $AvailabilityExceptionEntriesTable,
          AvailabilityExceptionEntry
        >,
      ),
      AvailabilityExceptionEntry,
      PrefetchHooks Function()
    >;
typedef $$SettingEntriesTableCreateCompanionBuilder =
    SettingEntriesCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingEntriesTableUpdateCompanionBuilder =
    SettingEntriesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SettingEntriesTable> {
  $$SettingEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingEntriesTable> {
  $$SettingEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingEntriesTable> {
  $$SettingEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingEntriesTable,
          SettingEntry,
          $$SettingEntriesTableFilterComposer,
          $$SettingEntriesTableOrderingComposer,
          $$SettingEntriesTableAnnotationComposer,
          $$SettingEntriesTableCreateCompanionBuilder,
          $$SettingEntriesTableUpdateCompanionBuilder,
          (
            SettingEntry,
            BaseReferences<_$AppDatabase, $SettingEntriesTable, SettingEntry>,
          ),
          SettingEntry,
          PrefetchHooks Function()
        > {
  $$SettingEntriesTableTableManager(
    _$AppDatabase db,
    $SettingEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  SettingEntriesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingEntriesCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingEntriesTable,
      SettingEntry,
      $$SettingEntriesTableFilterComposer,
      $$SettingEntriesTableOrderingComposer,
      $$SettingEntriesTableAnnotationComposer,
      $$SettingEntriesTableCreateCompanionBuilder,
      $$SettingEntriesTableUpdateCompanionBuilder,
      (
        SettingEntry,
        BaseReferences<_$AppDatabase, $SettingEntriesTable, SettingEntry>,
      ),
      SettingEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TaskListEntriesTableTableManager get taskListEntries =>
      $$TaskListEntriesTableTableManager(_db, _db.taskListEntries);
  $$RecurrenceRuleEntriesTableTableManager get recurrenceRuleEntries =>
      $$RecurrenceRuleEntriesTableTableManager(_db, _db.recurrenceRuleEntries);
  $$ProfileEntriesTableTableManager get profileEntries =>
      $$ProfileEntriesTableTableManager(_db, _db.profileEntries);
  $$TaskEntriesTableTableManager get taskEntries =>
      $$TaskEntriesTableTableManager(_db, _db.taskEntries);
  $$ScheduleBlockEntriesTableTableManager get scheduleBlockEntries =>
      $$ScheduleBlockEntriesTableTableManager(_db, _db.scheduleBlockEntries);
  $$TagEntriesTableTableManager get tagEntries =>
      $$TagEntriesTableTableManager(_db, _db.tagEntries);
  $$TaskTagEntriesTableTableManager get taskTagEntries =>
      $$TaskTagEntriesTableTableManager(_db, _db.taskTagEntries);
  $$WeeklyAvailabilityEntriesTableTableManager get weeklyAvailabilityEntries =>
      $$WeeklyAvailabilityEntriesTableTableManager(
        _db,
        _db.weeklyAvailabilityEntries,
      );
  $$AvailabilityExceptionEntriesTableTableManager
  get availabilityExceptionEntries =>
      $$AvailabilityExceptionEntriesTableTableManager(
        _db,
        _db.availabilityExceptionEntries,
      );
  $$SettingEntriesTableTableManager get settingEntries =>
      $$SettingEntriesTableTableManager(_db, _db.settingEntries);
}
