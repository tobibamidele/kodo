import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodo/src/services/auth_service.dart';
import 'package:kodo/src/state/onboarding/login_page_state.dart';

class LoginPageController extends AsyncNotifier<LoginPageState> {
  @override
  FutureOr<LoginPageState> build() {
    return LoginPageState();
  }

  void toggleObscurePassword() {
    state = AsyncData(
      state.value!.copyWith(obscurePassword: !state.value!.obscurePassword),
    );
  }

  void _updateButtonState() {
    final enabled =
        state.value!.email.isNotEmpty && state.value!.password.isNotEmpty;
    state = AsyncData(state.value!.copyWith(isEnabled: enabled));
  }

  void setEmail(String email) {
    state = AsyncData(state.value!.copyWith(email: email));
    _updateButtonState();
  }

  void setPassword(String password) {
    state = AsyncData(state.value!.copyWith(password: password));
    _updateButtonState();
  }

  void setError(String error) {
    state = AsyncData(state.value!.copyWith(error: error));
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await AuthService.signIn(email: email, password: password);
  }

  void toggleLoadingState(bool isLoading) {
    state = AsyncData(state.value!.copyWith(isLoading: isLoading));
  }
}

final loginPageControllerProvider =
    AsyncNotifierProvider<LoginPageController, LoginPageState>(
      LoginPageController.new,
    );
