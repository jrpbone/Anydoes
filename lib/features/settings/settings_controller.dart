import 'dart:async';

import 'package:anydoes/app/providers.dart';
import 'package:anydoes/core/result/app_failure.dart';
import 'package:anydoes/domain/models/availability.dart';
import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/planning_preferences.dart';
import 'package:anydoes/domain/repositories/planner_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SettingsState {
  SettingsState({
    PlannerSnapshot? snapshot,
    this.isLoading = true,
    this.failure,
  }) : snapshot = snapshot ?? PlannerSnapshot();

  final PlannerSnapshot snapshot;
  final bool isLoading;
  final String? failure;

  SettingsState copyWith({
    PlannerSnapshot? snapshot,
    bool? isLoading,
    String? failure,
    bool clearFailure = false,
  }) => SettingsState(
    snapshot: snapshot ?? this.snapshot,
    isLoading: isLoading ?? this.isLoading,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
      return SettingsController(ref.watch(plannerRepositoryProvider));
    });

final appearanceProvider = Provider<PlanningPreferences>(
  (ref) => ref.watch(settingsControllerProvider).snapshot.preferences,
);

final class SettingsController extends StateNotifier<SettingsState> {
  SettingsController(this._repository) : super(SettingsState()) {
    ready = _start();
  }

  final PlannerRepository _repository;
  late final Future<void> ready;
  StreamSubscription<PlannerSnapshot>? _subscription;

  Future<void> _start() async {
    try {
      await _repository.initializeDefaults();
      final snapshot = await _repository.currentSnapshot();
      state = state.copyWith(
        snapshot: snapshot,
        isLoading: false,
        clearFailure: true,
      );
      _subscription = _repository.watchSnapshot().listen(
        (value) => state = state.copyWith(
          snapshot: value,
          isLoading: false,
          clearFailure: true,
        ),
        onError: (Object error) => _record(error),
      );
    } catch (error) {
      _record(error);
    }
  }

  Future<void> addWeeklyWindow(
    int weekday,
    int startMinute,
    int endMinute,
  ) async {
    final window = AvailabilityWindow(
      weekday: weekday,
      startMinute: startMinute,
      endMinute: endMinute,
    );
    final updated = [...state.snapshot.weeklyAvailability, window];
    _validateNoOverlaps(updated);
    await _saveAvailability(updated, state.snapshot.availabilityExceptions);
  }

  Future<void> removeWeeklyWindow(AvailabilityWindow window) async {
    final updated = state.snapshot.weeklyAvailability
        .where((candidate) => !identical(candidate, window))
        .toList();
    await _saveAvailability(updated, state.snapshot.availabilityExceptions);
  }

  Future<void> setDateException(
    DateTime date,
    List<AvailabilityWindow> windows,
  ) async {
    _validateNoOverlaps(windows);
    final normalized = DateTime(date.year, date.month, date.day);
    final exceptions =
        state.snapshot.availabilityExceptions
            .where((exception) => exception.date != normalized)
            .toList()
          ..add(AvailabilityException(date: normalized, windows: windows));
    await _saveAvailability(state.snapshot.weeklyAvailability, exceptions);
  }

  Future<void> removeDateException(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    await _saveAvailability(
      state.snapshot.weeklyAvailability,
      state.snapshot.availabilityExceptions
          .where((exception) => exception.date != normalized)
          .toList(),
    );
  }

  Future<void> updatePlanning({
    int? horizonDays,
    int? minimumSessionMinutes,
    int? maximumSessionMinutes,
    int? notificationOffsetMinutes,
    bool? notificationsEnabled,
  }) async {
    await _savePreferences(
      state.snapshot.preferences.copyWith(
        horizonDays: horizonDays,
        defaultMinimumSessionMinutes: minimumSessionMinutes,
        defaultMaximumSessionMinutes: maximumSessionMinutes,
        notificationOffsetMinutes: notificationOffsetMinutes,
        notificationsEnabled: notificationsEnabled,
      ),
    );
  }

  Future<void> setAppearance({
    AppThemeMode? themeMode,
    bool? highContrast,
    bool? reduceMotion,
  }) async {
    await _savePreferences(
      state.snapshot.preferences.copyWith(
        themeMode: themeMode,
        highContrast: highContrast,
        reduceMotion: reduceMotion,
      ),
    );
  }

  Future<void> _saveAvailability(
    List<AvailabilityWindow> weekly,
    List<AvailabilityException> exceptions,
  ) async {
    final previous = state.snapshot;
    state = state.copyWith(
      snapshot: previous.copyWith(
        weeklyAvailability: weekly,
        availabilityExceptions: exceptions,
      ),
      clearFailure: true,
    );
    try {
      await _repository.saveAvailability(
        weekly: weekly,
        exceptions: exceptions,
      );
    } catch (error) {
      state = state.copyWith(snapshot: previous);
      _record(error);
      rethrow;
    }
  }

  Future<void> _savePreferences(PlanningPreferences preferences) async {
    final previous = state.snapshot;
    state = state.copyWith(
      snapshot: previous.copyWith(preferences: preferences),
      clearFailure: true,
    );
    try {
      await _repository.savePreferences(preferences);
    } catch (error) {
      state = state.copyWith(snapshot: previous);
      _record(error);
      rethrow;
    }
  }

  void _validateNoOverlaps(List<AvailabilityWindow> windows) {
    final sorted = [...windows]
      ..sort((a, b) {
        final weekday = a.weekday.compareTo(b.weekday);
        return weekday != 0 ? weekday : a.startMinute.compareTo(b.startMinute);
      });
    for (var index = 1; index < sorted.length; index++) {
      final previous = sorted[index - 1];
      final current = sorted[index];
      if (previous.weekday == current.weekday &&
          current.startMinute < previous.endMinute) {
        final error = ArgumentError('Availability windows cannot overlap.');
        _record(error);
        throw error;
      }
    }
  }

  void _record(Object error) {
    final message = switch (error) {
      AppFailure() => error.message,
      ArgumentError() => error.message?.toString() ?? 'Invalid setting.',
      _ => 'Settings could not be saved.',
    };
    state = state.copyWith(isLoading: false, failure: message);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
