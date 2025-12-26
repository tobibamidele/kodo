import 'package:flutter/material.dart';
import 'package:kodo/src/screens/home_page.dart';
import 'package:kodo/src/screens/onboarding/onboarding.dart';
import 'package:kodo/src/services/auth_service.dart';

/// [AuthGate] is the first layer that is loaded after app initialization
/// It helps us route the user according their authentication state
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // User is logged in
        if (snapshot.hasData) {
          return const HomePage();
        }

        // User is NOT logged in
        return const OnboardingPage();
      },
    );
  }
}
