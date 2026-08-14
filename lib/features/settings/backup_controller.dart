import 'package:anydoes/app/providers.dart';
import 'package:anydoes/core/result/app_failure.dart';
import 'package:anydoes/core/time/clock.dart';
import 'package:anydoes/data/portability/dayplan_file_service.dart';
import 'package:anydoes/domain/portability/dayplan_codec.dart';
import 'package:anydoes/domain/portability/dayplan_document.dart';
import 'package:anydoes/domain/portability/dayplan_validator.dart';
import 'package:anydoes/domain/portability/import_preview.dart';
import 'package:anydoes/domain/repositories/planner_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class BackupState {
  const BackupState({
    this.preview,
    this.isBusy = false,
    this.failure,
    this.message,
    this.requiresReplaceConfirmation = false,
  });

  final ImportPreview? preview;
  final bool isBusy;
  final String? failure;
  final String? message;
  final bool requiresReplaceConfirmation;

  BackupState copyWith({
    ImportPreview? preview,
    bool? isBusy,
    String? failure,
    String? message,
    bool? requiresReplaceConfirmation,
    bool clearPreview = false,
    bool clearFailure = false,
    bool clearMessage = false,
  }) => BackupState(
    preview: clearPreview ? null : preview ?? this.preview,
    isBusy: isBusy ?? this.isBusy,
    failure: clearFailure ? null : failure ?? this.failure,
    message: clearMessage ? null : message ?? this.message,
    requiresReplaceConfirmation:
        requiresReplaceConfirmation ?? this.requiresReplaceConfirmation,
  );
}

final backupControllerProvider =
    StateNotifierProvider<BackupController, BackupState>((ref) {
      return BackupController(
        ref.watch(plannerRepositoryProvider),
        ref.watch(dayplanFileServiceProvider),
        const DayplanCodec(),
        ref.watch(appClockProvider),
      );
    });

final class BackupController extends StateNotifier<BackupState> {
  BackupController(this._repository, this._files, this._codec, this._clock)
    : super(const BackupState());

  final PlannerRepository _repository;
  final DayplanFileGateway _files;
  final DayplanCodec _codec;
  final AppClock _clock;

  Future<bool> exportBackup() async {
    state = state.copyWith(
      isBusy: true,
      clearFailure: true,
      clearMessage: true,
    );
    try {
      final source = _codec.encode(
        kind: DayplanKind.fullBackup,
        snapshot: await _repository.currentSnapshot(),
        metadata: await _metadata(),
      );
      final saved = await _files.saveFullBackup(
        source,
        suggestedName: 'anydoes-backup-${_date(_clock.now())}.dayplan',
      );
      state = state.copyWith(
        isBusy: false,
        message: saved ? 'Backup exported.' : 'Export cancelled.',
      );
      return saved;
    } catch (error) {
      _fail(error, 'The backup could not be exported. Try another location.');
      return false;
    }
  }

  Future<bool> exportList(String listId) async {
    state = state.copyWith(
      isBusy: true,
      clearFailure: true,
      clearMessage: true,
    );
    try {
      final snapshot = await _repository.currentSnapshot();
      final list = snapshot.lists.singleWhere((value) => value.id == listId);
      final source = _codec.encode(
        kind: DayplanKind.sharedList,
        snapshot: snapshot,
        metadata: await _metadata(sharedListId: listId),
      );
      final safeName = list.name
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
          .replaceAll(RegExp(r'^-|-$'), '');
      final saved = await _files.saveSharedList(
        source,
        suggestedName: '${safeName.isEmpty ? 'shared-list' : safeName}.dayplan',
      );
      state = state.copyWith(
        isBusy: false,
        message: saved ? 'List exported.' : 'Export cancelled.',
      );
      return saved;
    } catch (error) {
      _fail(error, 'The list could not be exported. Try another location.');
      return false;
    }
  }

  Future<ImportPreview?> previewImport() async {
    state = state.copyWith(
      isBusy: true,
      clearFailure: true,
      clearMessage: true,
      requiresReplaceConfirmation: false,
    );
    try {
      final source = await _files.read();
      if (source == null) {
        state = state.copyWith(isBusy: false, message: 'Import cancelled.');
        return null;
      }
      final document = _codec.decode(source);
      final local = await _repository.currentSnapshot();
      final result = DayplanValidator(
        destinationTimeZone: await _files.localTimeZone(),
      ).validate(document, local);
      if (!result.isValid) {
        state = state.copyWith(
          isBusy: false,
          failure: result.errors.map((error) => error.message).join(' '),
        );
        return null;
      }
      state = state.copyWith(
        preview: result.preview,
        isBusy: false,
        clearFailure: true,
      );
      return result.preview;
    } catch (error) {
      _fail(error, 'This file is not a valid .dayplan document.');
      return null;
    }
  }

  Future<bool> applyMerge() => _apply(
    () => _repository.mergeSnapshot(state.preview!.snapshot),
    expectedKind: DayplanKind.fullBackup,
  );

  Future<bool> applyReplace({required bool confirmed}) async {
    if (!confirmed) {
      state = state.copyWith(requiresReplaceConfirmation: true);
      return false;
    }
    return _apply(
      () => _repository.replaceSnapshot(state.preview!.snapshot),
      expectedKind: DayplanKind.fullBackup,
    );
  }

  Future<bool> importList() => _apply(
    () => _repository.mergeSnapshot(state.preview!.snapshot),
    expectedKind: DayplanKind.sharedList,
  );

  Future<bool> _apply(
    Future<void> Function() operation, {
    required DayplanKind expectedKind,
  }) async {
    final preview = state.preview;
    if (preview == null || preview.kind != expectedKind) {
      state = state.copyWith(
        failure: 'Preview the matching .dayplan file before importing.',
      );
      return false;
    }
    state = state.copyWith(
      isBusy: true,
      clearFailure: true,
      clearMessage: true,
    );
    try {
      await operation();
      state = state.copyWith(
        isBusy: false,
        clearPreview: true,
        requiresReplaceConfirmation: false,
        message: expectedKind == DayplanKind.sharedList
            ? 'Shared list imported.'
            : 'Backup restored.',
      );
      return true;
    } catch (error) {
      _fail(error, 'Import failed. Existing data was not changed.');
      return false;
    }
  }

  void cancelPreview() {
    state = state.copyWith(
      clearPreview: true,
      clearFailure: true,
      requiresReplaceConfirmation: false,
    );
  }

  Future<DayplanMetadata> _metadata({String? sharedListId}) async =>
      DayplanMetadata(
        exportedAt: _clock.now(),
        sourceTimeZone: await _files.localTimeZone(),
        appVersion: '1.0.0',
        platform: defaultTargetPlatform.name,
        sharedListId: sharedListId,
      );

  void _fail(Object error, String fallback) {
    final message = error is AppFailure
        ? '${error.message} ${error.recovery}'
        : fallback;
    state = state.copyWith(isBusy: false, failure: message);
  }

  String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
