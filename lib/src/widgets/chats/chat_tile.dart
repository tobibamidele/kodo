import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kodo/core/routing/app_routes.dart';
import 'package:kodo/src/models/chat_tile_model.dart';
import 'package:kodo/src/screens/chats/chat_page.dart';
import 'package:kodo/src/services/auth_service.dart';
import 'package:kodo/src/services/biometric_service.dart';
import 'package:kodo/src/services/chat_service.dart';
import 'package:kodo/src/widgets/avatar.dart';
import 'package:kodo/src/widgets/bottom_modal.dart';
import 'package:kodo/utils/helpers.dart';

class ChatTile extends StatelessWidget {
  final ChatTileModel chat;
  ChatTile({super.key, required this.chat});

  final BiometricService _biometricService = BiometricService.instance;
  final ChatService _chatService = ChatService.instance;

  void _navigateToChat(BuildContext context) async {
    // Check if chat is locked and attempt to authenticate if it is
    if (await _chatService.isChatLocked(id: chat.chatId)) {
      final authenticated = await _biometricService.authenticate("");
      if (!authenticated) return;
    }

    // Get the chat details
    final chatModel = await ChatService().getOrCreateChat(
      myUid: AuthService.currentUser!.uid,
      otherUser: chat.otherUser,
    );
    final args = ChatPageArguments(chat: chatModel, otherUser: chat.otherUser);

    if (!context.mounted) return;
    context.push(AppRoutes.chat, extra: args);
  }

  void _showModal(BuildContext context) async {
    final locked = await _chatService.isChatLocked(id: chat.chatId);
    if (!context.mounted) return;
    showKodoBottomModal(
      context,
      builder: (dismiss) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.archive_outlined),
              onTap: () {
                dismiss();
              },
              title: Text(
                'Archive chat',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            ListTile(
              leading: (locked)
                  ? Icon(Icons.lock_outline)
                  : Icon(Icons.lock_open_outlined),
              onTap: () async {
                dismiss();
                if (!await _biometricService.isBiometricEnabled()) {
                  _biometricService.setBiometricEnabled(
                    true,
                  ); // Ask for user interest later. this is purely for testing
                }
                if (await _chatService.isChatLocked(id: chat.chatId)) {
                  // Require biometric auth if the chat is locked to open it
                  final authenticated = await _biometricService.authenticate(
                    "",
                  );
                  if (!authenticated) return;
                }
                await _chatService.toggleChatLock(id: chat.chatId);
              },
              title: Text(
                (locked) ? 'Lock Chat' : 'Unlock chat',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToChat(context),
        onLongPress: () => _showModal(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              Avatar(photoUrl: chat.photoUrl),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.displayName,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      chat.lastMessageText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatTime(chat.lastMessageTime),
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 11,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (chat.unreadCount > 0)
                    _UnreadBadge(count: chat.unreadCount),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final int count;
  const _UnreadBadge({required this.count});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
