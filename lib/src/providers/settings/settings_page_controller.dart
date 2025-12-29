import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kodo/src/models/settings_tile_model.dart';
import 'package:kodo/src/models/user_model.dart';
import 'package:kodo/src/providers/user_provider.dart';
import 'package:kodo/src/services/auth_service.dart';
import 'package:kodo/src/services/storage_service.dart';
import 'package:kodo/src/state/settings/settings_page_state.dart';
import 'package:riverpod/riverpod.dart';

class SettingsPageController extends AsyncNotifier<SettingsPageState> {
  final _storage = KodoStorageService.instance;
  @override
  FutureOr<SettingsPageState> build() async {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) {
      return SettingsPageState(user: null, tiles: _loadSettingsTiles());
    }

    // Get the cached user if any and set the initial state to hold that user
    final cachedUser = _storage.getUser(uid);

    // listen for user updates from the userProvider
    _listenToUserUpdates();

    return SettingsPageState(user: cachedUser, tiles: _loadSettingsTiles());
  }

  void _listenToUserUpdates() {
    ref.listen<AsyncValue<KodoUser?>>(userProvider, (previous, next) async {
      next.whenData((user) async {
        if (user == null) return;

        await _storage.cacheUser(user);

        state = AsyncData(state.value!.copyWith(user: user));
      });
    });
  }

  List<SettingsTileModel> _loadSettingsTiles() {
    return [
      SettingsTileModel(
        title: "Account",
        subtitle: "Manage your account",
        onTap: () {},
        leading: Icon(Icons.person),
      ),
      SettingsTileModel(
        title: "Account",
        subtitle: "Manager your account",
        onTap: () {},
        leading: Icon(Icons.person),
      ),
      SettingsTileModel(
        title: "Account",
        subtitle: "Manager your account",
        onTap: () {},
        leading: Icon(Icons.person),
      ),
      SettingsTileModel(
        title: "Account",
        subtitle: "Manager your account",
        onTap: () {},
        leading: Icon(Icons.person),
      ),
      SettingsTileModel(
        title: "Account",
        subtitle: "Manager your account",
        onTap: () {},
        leading: Icon(Icons.person),
      ),
      SettingsTileModel(
        title: "Account",
        subtitle: "Manager your account",
        onTap: () {},
        leading: Icon(Icons.person),
      ),
      SettingsTileModel(
        title: "Account",
        subtitle: "Manager your account",
        onTap: () {},
        leading: Icon(Icons.person),
      ),
      SettingsTileModel(
        title: "Account",
        subtitle: "Manager your account",
        onTap: () {},
        leading: Icon(Icons.person),
      ),
    ];
  }
}

final settingsPageControllerProvider =
    AsyncNotifierProvider<SettingsPageController, SettingsPageState>(
      SettingsPageController.new,
    );
