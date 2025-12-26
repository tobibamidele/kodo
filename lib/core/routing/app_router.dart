import 'package:go_router/go_router.dart';
import 'package:kodo/core/routing/app_routes.dart';
import 'package:kodo/src/screens/chats/chat_page.dart';
import 'package:kodo/src/screens/error_page.dart';
import 'package:kodo/src/screens/find_user_page.dart';
import 'package:kodo/src/screens/home_page.dart';
import 'package:kodo/src/screens/onboarding/login.dart';
import 'package:kodo/src/screens/onboarding/onboarding.dart';
import 'package:kodo/src/screens/onboarding/profile_setup_page.dart';
import 'package:kodo/src/screens/onboarding/register.dart';
import 'package:kodo/src/services/auth_service.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    redirect: (context, state) {
      final isLoggedIn = AuthService.currentUser != null;
      final location = state.fullPath;
      final isAuthRoute =
          location == AppRoutes.login ||
          location == AppRoutes.onboarding ||
          location == AppRoutes.register;

      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.onboarding;
      }

      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.profileSetup,
        builder: (context, state) => const ProfileSetupPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.findUser,
        builder: (context, state) => const FindUserPage(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) {
          final args = state.extra;
          if (args is! ChatPageArguments) {
            return ErrorPage(error: "Missing chat arguments");
          }
          return ChatPage(args: args);
        },
      ),
    ],
    errorBuilder: (context, state) {
      final error = state.error.toString();
      return ErrorPage(error: error);
    },
  );
}
