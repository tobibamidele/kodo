import 'package:flutter/material.dart';
import 'package:kodo/src/providers/chats/chat_page_controller.dart';
import 'package:kodo/src/state/chats/chat_page_state.dart';
import 'package:kodo/src/widgets/input_field.dart';
import 'package:kodo/utils/helpers.dart';

class InputBar extends StatefulWidget {
  const InputBar({
    super.key,
    required this.state,
    required this.controller,
    required this.onSend,
  });

  final void Function(String text, String? id) onSend;
  final ChatPageState state;
  final ChatPageController controller;

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    String? replyMessageId = getMessageById(
      widget.state.replyMessageId,
      widget.state.messages,
    );
    if (replyMessageId.isEmpty) {
      replyMessageId = null;
    }

    widget.onSend(text, replyMessageId);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Column(
          children: [
            if (widget.state.replyMessageId != null) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: _ReplyMessageView(
                  msg: getMessageById(
                    widget.state.replyMessageId,
                    widget.state.messages,
                  ),
                  onClose: () {
                    widget.controller.setReplyMessageId(null);
                  },
                ),
              ),
            ],
            Row(
              children: [
                Expanded(
                  child: InputField(
                    controller: _controller,
                    focusNode: _focusNode,
                    labelText: 'Message',
                    onSubmitted: _handleSend,
                    onChanged: (_) {},
                    textInputType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                const SizedBox(width: 8),
                if (widget.state.isSending) ...[
                  const CircularProgressIndicator(),
                ] else ...[
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _handleSend,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReplyMessageView extends StatelessWidget {
  final String msg;
  final VoidCallback onClose;
  const _ReplyMessageView({required this.msg, required this.onClose});
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Reply to:",
                    style: TextStyle(color: Colors.grey, fontSize: 8),
                  ),
                  const Spacer(),
                  InkWell(
                    child: Icon(Icons.close_rounded, size: 10),
                    onTap: () => onClose(),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                msg,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall!.copyWith(color: Colors.white),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
