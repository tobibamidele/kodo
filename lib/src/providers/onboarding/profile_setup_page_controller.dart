import 'dart:async';

import 'package:kodo/src/services/user_service.dart';
import 'package:kodo/src/state/onboarding/profile_setup_page_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSetupPageController extends AsyncNotifier<ProfileSetupPageState> {
  @override
  FutureOr<ProfileSetupPageState> build() {
    return ProfileSetupPageState();
  }

  String? isUsernameValid(String? value) {
    final RegExp usernameRegex = RegExp(r'^[a-z][a-z0-9]*(?:_[a-z0-9]+)*$');
    if (value == null || value.isEmpty) {
      return 'Username is required.';
    }

    value = value.trim();

    if (value.length < 3 || value.length > 20) {
      return 'Username must be 3–20 characters.';
    }

    if (!usernameRegex.hasMatch(value)) {
      return 'Use lowercase letters, numbers, and underscores only for the username.';
    }

    return null; // valid
  }

  String? isDisplayNameValid(String? name) {
    final RegExp displayNameRegex = RegExp(r'^[A-Za-z]+(?: [A-Za-z]+)*$');

    if (name == null || name.isEmpty) {
      // Empty names
      return "Display name cannot be empty.";
    }

    if (name.trim().length < 2) {
      // At least 2 chars for the name
      return "Display name should be at least 2 characters long.";
    }

    if (displayNameRegex.hasMatch(name.trim())) {
      // Regex matches
      return "Display name cannot contain numbers or symbols, only spaces allowed.";
    }

    return null;
  }

  String? isAboutValid(String? about) {
    if (about == null || about.isEmpty) {
      return "About cannot be empty.";
    }

    if (about.trim().length > 150) {
      return "About cannot be greater than 150 characters";
    }

    return null;
  }

  void _updateButtonState() {
    final usernameError = isUsernameValid(state.value!.username);
    if (usernameError != null) {
      state = AsyncData(state.value!.copyWith(error: usernameError));
      return;
    }

    final displayNameError = isDisplayNameValid(state.value!.displayName);
    if (displayNameError != null) {
      state = AsyncData(state.value!.copyWith(error: displayNameError));
      return;
    }

    final aboutError = isAboutValid(state.value!.about);
    if (aboutError != null) {
      // Kinda looking like go😂
      state = AsyncData(state.value!.copyWith(error: aboutError));
      return;
    }

    // We can now update button state
    state = AsyncData(state.value!.copyWith(isButtonEnabled: true));
  }

  void setUsername(String username) {
    state = AsyncData(state.value!.copyWith(username: username));
    _updateButtonState();
  }

  void setDisplayName(String displayName) {
    state = AsyncData(state.value!.copyWith(displayName: displayName));
    _updateButtonState();
  }

  void setAbout(String about) {
    if (state.value!.about.length > 150) {
      return;
    }
    state = AsyncData(state.value!.copyWith(about: about));
    _updateButtonState();
  }

  void setError(String error) {
    state = AsyncData(state.value!.copyWith(error: error));
  }

  void toggleLoadingState(bool loading) {
    state = AsyncData(state.value!.copyWith(isLoading: loading));
  }

  Future<void> createUser({
    required String username,
    required String displayName,
    required String about,
  }) async {
    final user = await KodoUserService().getUserByUsername(username);
    if (user != null) {
      state = AsyncData(
        state.value!.copyWith(error: "Username is already taken."),
      );
      return;
    }

    return await KodoUserService().createUserIfNotExists(
      username: username,
      displayName: displayName,
      about: about,
    );
  }
}

final profileSetupPageControllerProvider =
    AsyncNotifierProvider<ProfileSetupPageController, ProfileSetupPageState>(
      ProfileSetupPageController.new,
    );
