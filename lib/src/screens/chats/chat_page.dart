import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodo/src/models/chat_model.dart';
import 'package:kodo/src/models/user_model.dart';
import 'package:kodo/src/providers/chats/chat_page_controller.dart';
import 'package:kodo/src/services/auth_service.dart';
import 'package:kodo/src/state/chats/chat_page_state.dart';
import 'package:kodo/src/widgets/chats/message_widget.dart';
import 'package:kodo/src/widgets/input_bar.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ChatPageArguments {
  final ChatModel chat;
  final KodoUser otherUser;
  ChatPageArguments({required this.chat, required this.otherUser});
}

class ChatPage extends ConsumerStatefulWidget {
  static const String routeName = "/chatpage";
  final ChatPageArguments args;
  const ChatPage({super.key, required this.args});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatPageControllerProvider(widget.args.chat));
    final controller = ref.watch(
      chatPageControllerProvider(widget.args.chat).notifier,
    );

    // Listen for state changes and scroll to bottom
    ref.listen(chatPageControllerProvider(widget.args.chat), (_, next) {
      next.whenData((state) => _scrollToBottom());
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.args.otherUser.displayName,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: chatAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (state) {
          // Scroll to bottom when messages first load
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _scrollToBottom(),
          );
          return _buildChatPage(state, controller);
        },
      ),
    );
  }

  Widget _buildChatPage(ChatPageState state, ChatPageController controller) {
    final myUid = AuthService.currentUser!.uid;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                // Reverse makes messages start from bottom
                reverse: false,
                separatorBuilder: (context, _) {
                  return SizedBox(height: 10);
                },
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  if (index == state.messages.length) {
                    return _BottomObserver(chat: widget.args.chat);
                  }

                  final msg = state.messages[index];
                  return MessageBubble(
                    controller: controller,
                    message: msg,
                    isMe: msg.senderId == myUid,
                  );
                },
              ),
            ),
            InputBar(
              state: state,
              onSend: (text) {
                controller.sendText(
                  receiverId: widget.args.otherUser.id,
                  text: text,
                );
              },
            ),
          ],
        ),

        if (!state.isAtBottom)
          Positioned(
            right: 12,
            bottom: 72, // adjust to sit above InputBar
            child: InkWell(
              overlayColor: WidgetStateProperty.all(
                Colors.transparent,
              ), // Disable splash on tap
              onTap: _scrollToBottom,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.arrow_drop_down),
              ),
            ),
          ),
      ],
    );
  }
}

class _BottomObserver extends ConsumerWidget {
  final ChatModel chat;
  const _BottomObserver({required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VisibilityDetector(
      key: const Key('chat-bottom-observer'),
      onVisibilityChanged: (info) {
        final isVisible = info.visibleFraction > 0.2;
        print(isVisible);

        final controller = ref.read(chatPageControllerProvider(chat).notifier);
        final state = ref.read(chatPageControllerProvider(chat)).value;

        if (state != null && state.isAtBottom != isVisible) {
          controller.setIsAtBottom(isVisible);
        }
      },
      child: const SizedBox(height: 1),
    );
  }
}
