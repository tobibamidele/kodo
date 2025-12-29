import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kodo/core/routing/app_routes.dart';
import 'package:kodo/src/providers/onboarding/profile_setup_page_controller.dart';
import 'package:kodo/src/state/onboarding/profile_setup_page_state.dart';
import 'package:kodo/src/widgets/input_field.dart';

class ProfileSetupPage extends ConsumerStatefulWidget {
  static const String routeName = "/profileSetup";
  const ProfileSetupPage({super.key});
  @override
  ConsumerState<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends ConsumerState<ProfileSetupPage> {
  late TextEditingController usernameController;
  late TextEditingController displayNameController;
  late TextEditingController aboutController;
  late FocusNode usernameFocusNode;
  late FocusNode displayNameFocusNode;
  late FocusNode aboutFocusNode;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    displayNameController = TextEditingController();
    aboutController = TextEditingController();
    usernameFocusNode = FocusNode();
    displayNameFocusNode = FocusNode();
    aboutFocusNode = FocusNode();

    usernameFocusNode.addListener(() {
      setState(() {});
    });
    displayNameFocusNode.addListener(() {
      setState(() {});
    });
    aboutFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    displayNameController.dispose();
    aboutController.dispose();
    usernameFocusNode.dispose();
    displayNameFocusNode.dispose();
    aboutFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileSetupPageAsync = ref.watch(profileSetupPageControllerProvider);
    final controller = ref.read(profileSetupPageControllerProvider.notifier);
    return profileSetupPageAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (profileSetupPageState) {
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: _buildProfileSetupPage(profileSetupPageState, controller),
          ),
        );
      },
    );
  }

  Widget _buildProfileSetupPage(
    ProfileSetupPageState state,
    ProfileSetupPageController controller,
  ) {
    return SingleChildScrollView(
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            "Let's setup your profile!",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          Text(
            "Complete setting up your Kodo user profile and chat with loved ones.",
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),

          inputFields(state, controller),

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
              onPressed: state.isButtonEnabled
                  ? state.isLoading
                        ? null
                        : () async {
                            try {
                              if (usernameFocusNode.hasPrimaryFocus ||
                                  displayNameFocusNode.hasPrimaryFocus ||
                                  aboutFocusNode.hasPrimaryFocus) {
                                usernameFocusNode.unfocus();
                                displayNameFocusNode.unfocus();
                                aboutFocusNode.unfocus();
                              }
                              controller.toggleLoadingState(true);
                              await controller.createUser(
                                username: state.username,
                                displayName: state.displayName,
                                about: state.about,
                              );
                              if (!mounted) return;

                              context.pushReplacement(AppRoutes.home);
                            } catch (e) {
                              controller.setError(e.toString());
                            } finally {
                              controller.toggleLoadingState(false);
                            }
                          }
                  : null,
              child: state.isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      "Continue",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(color: Colors.black),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputFields(
    ProfileSetupPageState state,
    ProfileSetupPageController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Username:", style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        InputField(
          controller: usernameController,
          textInputType: TextInputType.text,
          focusNode: usernameFocusNode,
          labelText: "Username",
          onSubmitted: () =>
              FocusScope.of(context).requestFocus(displayNameFocusNode),
          onChanged: (value) {
            controller.setUsername(value);
            controller.setError("");
          },
        ),

        const SizedBox(height: 15),

        Text("Display name:", style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        InputField(
          controller: displayNameController,
          textInputType: TextInputType.text,
          focusNode: displayNameFocusNode,
          labelText: "Display name",
          onSubmitted: () =>
              FocusScope.of(context).requestFocus(aboutFocusNode),
          onChanged: (value) {
            controller.setDisplayName(value);
            controller.setError("");
          },
        ),

        const SizedBox(height: 15),
        Text("About", style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        InputField(
          controller: aboutController,
          textInputType: TextInputType.text,
          focusNode: aboutFocusNode,
          labelText: "About",
          onSubmitted: () {},
          onChanged: (value) {
            controller.setAbout(value);
            controller.setError("");
          },
        ),
        SizedBox(height: 5),
        Row(
          children: [
            const Spacer(),
            Text(
              "${state.about.trim().length.toString()}/150",
              style: Theme.of(
                context,
              ).textTheme.labelSmall!.copyWith(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
