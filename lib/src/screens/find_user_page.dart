import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kodo/core/routing/app_routes.dart';
import 'package:kodo/src/models/user_model.dart';
import 'package:kodo/src/screens/chats/chat_page.dart';
import 'package:kodo/src/services/auth_service.dart';
import 'package:kodo/src/services/chat_service.dart';
import 'package:kodo/src/services/user_service.dart';
import 'package:kodo/src/widgets/avatar.dart';
import 'package:kodo/src/widgets/bottom_modal.dart';
import 'package:kodo/src/widgets/input_field.dart';
import 'package:kodo/utils/helpers.dart';

class FindUserPage extends StatefulWidget {
  static const String routeName = "/find-user";
  const FindUserPage({super.key});
  @override
  State<FindUserPage> createState() => _FindUserPageState();
}

class _FindUserPageState extends State<FindUserPage> {
  late final TextEditingController controller;
  late final FocusNode focusNode;
  bool doesUserExist = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Find a user",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Enter a username into the text box below to start a new chat.",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),
              inputFields(),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(10),
          child: Text(
            "@",
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(width: 6),

        Expanded(
          child: InputField(
            controller: controller,
            focusNode: focusNode,
            labelText: "Enter a username",
            onSubmitted: () async {
              final user = await KodoUserService().getUserByUsername(
                controller.text.trim(),
              );
              if (user == null) {
                setState(() {
                  doesUserExist = false;
                });
              } else {
                setState(() {
                  doesUserExist = true;
                });
                if (user.username == getCurrentUsername()) {
                  setState(() {
                    doesUserExist = false;
                  });
                  return;
                }
                if (!mounted) return;
                showKodoBottomModal(
                  context,
                  builder: (dismiss) {
                    return SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // critical
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 16),
                              _UserConfirmContent(user: user, dismiss: dismiss),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
            textInputType: TextInputType.text,
            onChanged: (_) {},
            suffixIcon: (controller.text.trim().isNotEmpty)
                ? doesUserExist
                      ? Icon(Icons.check)
                      : Icon(Icons.error)
                : null,
          ),
        ),
      ],
    );
  }
}

class _UserConfirmContent extends StatelessWidget {
  final KodoUser user;
  final Function() dismiss;
  const _UserConfirmContent({required this.user, required this.dismiss});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Avatar(photoUrl: user.photoUrl, radius: 36),
        const SizedBox(height: 12),

        Text(
          "Add @${user.username}?",
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 6),

        if (user.about != null)
          Text(
            user.about!,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final chat = await ChatService().getOrCreateChat(
                myUid: AuthService.currentUser!.uid,
                otherUser: user,
              );

              dismiss();

              if (!context.mounted) return;
              context.push(
                AppRoutes.chat,
                extra: ChatPageArguments(chat: chat, otherUser: user),
              );
            },
            child: const Text("Add", style: TextStyle(color: Colors.black)),
          ),
        ),
      ],
    );
  }
}
