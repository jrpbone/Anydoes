import 'dart:async';

import 'package:anydoes/app/providers.dart';
import 'package:anydoes/core/result/app_failure.dart';
import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/profile.dart';
import 'package:anydoes/domain/repositories/planner_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final class ProfilesState {
  const ProfilesState({
    this.profiles = const [],
    this.isLoading = true,
    this.failure,
  });

  final List<LocalProfile> profiles;
  final bool isLoading;
  final AppFailure? failure;

  ProfilesState copyWith({
    List<LocalProfile>? profiles,
    bool? isLoading,
    AppFailure? failure,
    bool clearFailure = false,
  }) => ProfilesState(
    profiles: profiles ?? this.profiles,
    isLoading: isLoading ?? this.isLoading,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}

final profilesControllerProvider =
    StateNotifierProvider<ProfilesController, ProfilesState>((ref) {
      return ProfilesController(ref.watch(plannerRepositoryProvider));
    });

final class ProfilesController extends StateNotifier<ProfilesState> {
  ProfilesController(this._repository, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid(),
      super(const ProfilesState()) {
    _start();
  }

  final PlannerRepository _repository;
  final Uuid _uuid;
  StreamSubscription<PlannerSnapshot>? _subscription;

  Future<void> _start() async {
    try {
      await _repository.initializeDefaults();
      _subscription = _repository.watchSnapshot().listen(
        (snapshot) => state = state.copyWith(
          profiles: snapshot.profiles,
          isLoading: false,
          clearFailure: true,
        ),
        onError: (Object error) => _setFailure(error),
      );
    } catch (error) {
      _setFailure(error);
    }
  }

  Future<void> addProfile(String name, {int colorValue = 0xFF2878E3}) async {
    try {
      await _repository.saveProfile(
        LocalProfile(id: _uuid.v4(), name: name, colorValue: colorValue),
      );
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<void> deleteProfile(LocalProfile profile) async {
    if (profile.isMe) {
      _setFailure(
        const AppFailure(
          code: AppFailureCode.validation,
          message: 'The Me profile cannot be deleted.',
          recovery: 'Edit the profile instead.',
        ),
      );
      return;
    }
    await _repository.deleteProfile(profile.id);
  }

  void _setFailure(Object error) {
    state = state.copyWith(
      isLoading: false,
      failure: error is AppFailure
          ? error
          : AppFailure(
              code: AppFailureCode.persistence,
              message: 'Profiles could not be updated.',
              recovery: 'Try again.',
              cause: error,
            ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
