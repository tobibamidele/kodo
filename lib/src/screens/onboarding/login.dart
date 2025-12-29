import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kodo/core/routing/app_routes.dart';
import 'package:kodo/src/providers/onboarding/login_page_controller.dart';
import 'package:kodo/src/services/auth_service.dart';
import 'package:kodo/src/state/onboarding/login_page_state.dart';
import 'package:kodo/src/widgets/icon_buttons.dart';
import 'package:kodo/src/widgets/input_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const String routeName = "/login";
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  // Redirect user away from this screen if they're already logged in
  void _checkAuthState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = AuthService.currentUser;
      if (user != null) {
        context.replace(AppRoutes.home);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    emailFocusNode.addListener(() {
      setState(() {});
    });

    passwordFocusNode.addListener(() {
      setState(() {});
    });

    _checkAuthState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginStateAsync = ref.watch(loginPageControllerProvider);
    return loginStateAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (loginState) {
        return Scaffold(
          appBar: AppBar(),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: buildLoginPage(loginState),
        );
      },
    );
  }

  Widget buildLoginPage(LoginPageState state) {
    final controller = ref.read(loginPageControllerProvider.notifier);
    return SafeArea(
      child: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text(
              "Welcome back to Kodo!",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Text(
              "Log back in to your Kodo account and catch up with friends and family.",
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            inputFields(state),

            const SizedBox(height: 20),

            Visibility(
              visible: state.error.isNotEmpty,
              child: Column(
                children: [
                  Text(
                    state.error,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium!.copyWith(color: Colors.redAccent),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            FractionallySizedBox(
              widthFactor: 1,
              child: ElevatedButton(
                onPressed: state.isEnabled
                    ? state.isLoading
                          ? null
                          : () async {
                              try {
                                if (emailFocusNode.hasPrimaryFocus ||
                                    passwordFocusNode.hasPrimaryFocus) {
                                  emailFocusNode.unfocus();
                                  passwordFocusNode.unfocus();
                                }
                                controller.toggleLoadingState(true);
                                await controller.signIn(
                                  email: state.email,
                                  password: state.password,
                                );
                                if (!mounted) return;
                                context.pushReplacement(AppRoutes.home);
                              } on FirebaseAuthException catch (e) {
                                print("Error: $e");
                                controller.setError(e.message ?? "");
                              } finally {
                                controller.toggleLoadingState(false);
                              }
                            }
                    : null,
                child: state.isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        "Login",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: Colors.black),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: TextButton(
                onPressed: () => context.pushReplacement(AppRoutes.register),
                child: Text(
                  "Don't have an account? Register.",
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall!.copyWith(color: Colors.greenAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputFields(LoginPageState state) {
    final controller = ref.read(loginPageControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email:", style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        InputField(
          controller: emailController,
          textInputType: TextInputType.emailAddress,
          focusNode: emailFocusNode,
          maxLines: 1,
          labelText: "Email",
          onSubmitted: () =>
              FocusScope.of(context).requestFocus(passwordFocusNode),
          onChanged: (value) {
            controller.setEmail(value);
            controller.setError("");
          },
        ),

        const SizedBox(height: 15),

        Text("Password:", style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        InputField(
          controller: passwordController,
          textInputType: TextInputType.visiblePassword,
          focusNode: passwordFocusNode,
          maxLines: 1,
          labelText: "Password",
          onSubmitted: () {},
          onChanged: (value) {
            controller.setPassword(value);
            controller.setError("");
          },
          obscureText: state.obscurePassword,
          suffixIcon: KodoIconButtons.eyeIcon(
            controller.toggleObscurePassword,
            state.obscurePassword,
          ),
        ),
      ],
    );
  }
}
