import 'package:flutter/material.dart';
import 'package:kodo/src/state/chats/chat_page_state.dart';
import 'package:kodo/src/widgets/input_field.dart';

class InputBar extends StatefulWidget {
  const InputBar({super.key, required this.state, required this.onSend});

  final void Function(String text) onSend;
  final ChatPageState state;

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

    widget.onSend(text);
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
                    maxLines: null,
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
