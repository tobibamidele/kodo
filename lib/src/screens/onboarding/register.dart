import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kodo/core/routing/app_routes.dart';
import 'package:kodo/src/providers/onboarding/register_page_controller.dart';
import 'package:kodo/src/screens/onboarding/profile_setup_page.dart';
import 'package:kodo/src/services/auth_service.dart';
import 'package:kodo/src/state/onboarding/register_page_state.dart';
import 'package:kodo/src/widgets/icon_buttons.dart';
import 'package:kodo/src/widgets/input_field.dart';
import 'package:kodo/src/widgets/password_validation_widget.dart';

class RegisterPage extends ConsumerStatefulWidget {
  static const String routeName = "/register";
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  final double borderRadius = 10;

  void _checkAuthState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = AuthService.currentUser;
      if (user != null) {
        context.replace(AppRoutes.home);
      }
    });
  }

  // The `initState` function is called when the screen enters the stack (i.e., on the first render of the screen).
  @override
  void initState() {
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

  // The `dispose` function is called when the current screen is removed or changed on the stack
  // It is mostly used to clean up resources to avoid memory leaks and other problems
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  // The `build` function is what renders the actual UI.
  // You describe the UI here and it get's rendered on the device
  @override
  Widget build(BuildContext context) {
    final registerStateAsync = ref.watch(registerPageControllerProvider);
    return registerStateAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (registerState) {
        return Scaffold(
          appBar: AppBar(),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: buildRegistrationPage(registerState),
        );
      },
    );
  }

  Widget buildRegistrationPage(RegisterPageState state) {
    final controller = ref.read(registerPageControllerProvider.notifier);
    return SafeArea(
      child: SingleChildScrollView(
        reverse: true, // scroll up when the text box is active
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              "Start chatting with your friends today!",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Text(
              "Create a Kodo account and share messages and moments with your loved ones.",
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

            PasswordValidationWidget(
              password: passwordController.text.trim(),
              passwordValidation: state.validation,
            ),

            const SizedBox(height: 20),

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
                                await controller.signUp(
                                  email: state.email,
                                  password: state.password,
                                );
                                if (!mounted) return;
                                Navigator.of(
                                  context,
                                ).pushNamed(ProfileSetupPage.routeName);
                              } on FirebaseAuthException catch (e) {
                                controller.setError(e.message ?? "");
                              } finally {
                                controller.toggleLoadingState(false);
                              }
                            }
                    : null,
                child: state.isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        "Register",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: Colors.black),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: TextButton(
                onPressed: () => context.push(AppRoutes.login),
                child: Text(
                  "Already have an account? Login.",
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

  Widget inputFields(RegisterPageState state) {
    final controller = ref.read(registerPageControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email:", style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        InputField(
          controller: emailController,
          textInputType: TextInputType.emailAddress,
          focusNode: emailFocusNode,
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
