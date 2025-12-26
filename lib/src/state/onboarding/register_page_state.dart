import 'package:kodo/src/widgets/password_validation_widget.dart';

class RegisterPageState {
  final String email;
  final String password;
  final double borderRadius;
  final String error;
  final bool isEnabled;
  final bool obscurePassword;
  final bool isLoading;
  final PasswordValidation validation;

  RegisterPageState({
    this.email = "",
    this.password = "",
    this.borderRadius = 10,
    this.error = "",
    this.isEnabled = false,
    this.obscurePassword = true,
    this.isLoading = false,
    this.validation = const PasswordValidation(
      hasDigit: false,
      hasLowercase: false,
      hasMinLength: false,
      hasSpecialChar: false,
      hasUppercase: false,
    ),
  });

  RegisterPageState copyWith({
    String? email,
    String? password,
    double? borderRadius,
    String? error,
    bool? isEnabled,
    bool? obscurePassword,
    bool? isLoading,
    PasswordValidation? validation,
  }) {
    return RegisterPageState(
      email: email ?? this.email,
      password: password ?? this.password,
      borderRadius: borderRadius ?? this.borderRadius,
      error: error ?? this.error,
      isEnabled: isEnabled ?? this.isEnabled,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isLoading: isLoading ?? this.isLoading,
      validation: validation ?? this.validation,
    );
  }
}
