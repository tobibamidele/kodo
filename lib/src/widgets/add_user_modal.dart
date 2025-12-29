import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kodo/core/routing/app_routes.dart';
import 'package:kodo/src/models/user_model.dart';
import 'package:kodo/src/screens/chats/chat_page.dart';
import 'package:kodo/src/services/auth_service.dart';
import 'package:kodo/src/services/chat_service.dart';
import 'package:kodo/src/widgets/avatar.dart';

class AddUserModal extends StatelessWidget {
  final KodoUser user;
  final Function() dismiss;
  const AddUserModal({required this.user, required this.dismiss});

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
