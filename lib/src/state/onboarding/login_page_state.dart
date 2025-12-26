class LoginPageState {
  final String email;
  final String password;
  final double borderRadius;
  final String error;
  final bool isEnabled;
  final bool obscurePassword;
  final bool isLoading;

  LoginPageState({
    this.email = "",
    this.password = "",
    this.borderRadius = 10,
    this.error = "",
    this.isEnabled = false,
    this.obscurePassword = true,
    this.isLoading = false,
  });

  LoginPageState copyWith({
    String? email,
    String? password,
    double? borderRadius,
    String? error,
    bool? isEnabled,
    bool? obscurePassword,
    bool? isLoading,
  }) {
    return LoginPageState(
      email: email ?? this.email,
      password: password ?? this.password,
      borderRadius: borderRadius ?? this.borderRadius,
      error: error ?? this.error,
      isEnabled: isEnabled ?? this.isEnabled,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
