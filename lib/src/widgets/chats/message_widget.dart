import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kodo/src/models/message_model.dart';
import 'package:kodo/src/providers/chats/chat_page_controller.dart';
import 'package:kodo/src/services/auth_service.dart';
import 'package:kodo/src/widgets/bottom_modal.dart';
import 'package:kodo/src/widgets/emoji_row.dart';
import 'package:kodo/src/widgets/message_reactions.dart';
import 'package:kodo/utils/helpers.dart';
import 'package:kodo/utils/theme/extensions/chat_colors.dart';

class MessageBubble extends StatelessWidget {
  final ChatPageController controller;
  final Message message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.controller,
    required this.message,
    required this.isMe,
  });

  void showMessageModal(BuildContext context, Message msg) {
    // final backgroundColor = Theme.of(context)
    return showKodoBottomModal(
      context,
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
      backgroundColor: Theme.of(context).cardColor,
      builder: (dismiss) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.fromLTRB(20, 16, 20, 24),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const SizedBox(height: 10),
                  _MessageModalContent(
                    msg: msg,
                    controller: controller,
                    onDismiss: dismiss,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = AuthService.currentUser!.uid;
    final chatColors = Theme.of(context).extension<ChatColors>()!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onLongPress: () {
          showMessageModal(context, message);
        },
        child: Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: isMe ? chatColors.myMessage : chatColors.otherMessage,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.isEdited) ...[
                  Text(
                    'Edited',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(fontSize: 10),
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  message.content ?? '',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatTime(
                        message.isEdited
                            ? message.editedAt!
                                  .toDate() // Edited at cannot be null if isEdited is true
                            : message.createdAt.toDate(),
                      ),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(fontSize: 10),
                    ),
                  ],
                ),

                MessageReactions(
                  reactions: message.reactions,
                  currentUid: userId,
                  onTap: (emoji) async {
                    await controller.toggleReaction(
                      messageId: message.id,
                      emoji: emoji,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageModalContent extends StatelessWidget {
  final ChatPageController controller;
  final Message msg;
  final Function() onDismiss;
  const _MessageModalContent({
    required this.msg,
    required this.controller,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The message itself
        FractionallySizedBox(
          widthFactor: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color!.withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Text(
              msg.content ?? '',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          height: 70,
          child: EmojiRow(
            onTap: (emoji) async {
              await controller.toggleReaction(messageId: msg.id, emoji: emoji);
              if (!context.mounted) return;
              context.pop();
            },
          ),
        ),

        const SizedBox(height: 20),

        ListTile(
          trailing: Icon(Icons.copy_outlined),
          onTap: () {
            copyToClipboard(msg.content ?? '');
            onDismiss();
          },
          title: Text(
            'Copy',
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400),
          ),
        ),
        ListTile(
          trailing: Icon(Icons.reply_outlined),
          onTap: () {
            onDismiss();
          },
          title: Text(
            'Reply',
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400),
          ),
        ),
        ListTile(
          trailing: Icon(Icons.forward_outlined),
          onTap: () {
            onDismiss();
          },
          title: Text(
            'Forward',
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400),
          ),
        ),
        ListTile(
          trailing: Icon(Icons.delete_outline),
          onTap: () {
            onDismiss();
          },
          title: Text(
            'Delete',
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
