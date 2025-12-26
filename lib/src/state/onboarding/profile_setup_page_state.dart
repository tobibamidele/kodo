class ProfileSetupPageState {
  final String username;
  final String displayName;
  final String about;
  final String error;
  final bool isLoading;
  final bool isButtonEnabled;

  ProfileSetupPageState({
    this.username = "",
    this.displayName = "",
    this.about = "",
    this.error = "",
    this.isLoading = false,
    this.isButtonEnabled = false,
  });

  ProfileSetupPageState copyWith({
    String? username,
    String? displayName,
    String? about,
    String? error,
    bool? isLoading,
    bool? isButtonEnabled,
  }) {
    return ProfileSetupPageState(
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      about: about ?? this.about,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }
}
