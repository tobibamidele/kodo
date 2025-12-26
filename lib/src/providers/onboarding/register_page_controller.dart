import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodo/src/services/auth_service.dart';
import 'package:kodo/src/state/onboarding/register_page_state.dart';
import 'package:kodo/src/widgets/password_validation_widget.dart';

class RegisterPageController extends AsyncNotifier<RegisterPageState> {
  @override
  FutureOr<RegisterPageState> build() {
    return RegisterPageState();
  }

  void toggleObscurePassword() {
    state = AsyncData(
      state.value!.copyWith(obscurePassword: !state.value!.obscurePassword),
    );
  }

  void _updatePasswordValidation() {
    final validation = PasswordValidation.validate(state.value!.password);
    state = AsyncData(state.value!.copyWith(validation: validation));
  }

  void _updateButtonState() {
    final enabled =
        state.value!.email.isNotEmpty &&
        state.value!.password.isNotEmpty &&
        state.value!.validation.isValid;

    state = AsyncData(state.value!.copyWith(isEnabled: enabled));
  }

  void setEmail(String email) {
    state = AsyncData(state.value!.copyWith(email: email));
    _updateButtonState();
  }

  void setPassword(String password) {
    state = AsyncData(state.value!.copyWith(password: password));
    _updatePasswordValidation();
    _updateButtonState();
  }

  void setError(String error) {
    state = AsyncData(state.value!.copyWith(error: error));
  }

  void toggleLoadingState(bool isLoading) {
    state = AsyncData(state.value!.copyWith(isLoading: isLoading));
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await AuthService.signUp(email: email, password: password);
  }
}

final registerPageControllerProvider =
    AsyncNotifierProvider<RegisterPageController, RegisterPageState>(
      RegisterPageController.new,
    );
