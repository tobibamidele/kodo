import 'package:flutter/material.dart';
import 'package:kodo/src/models/chat_tile_model.dart';
import 'package:kodo/src/widgets/chats/chat_tile.dart';

class ChatsList extends StatefulWidget {
  final List<ChatTileModel> chats;
  const ChatsList({super.key, required this.chats});
  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.chats.length,
              itemBuilder: (_, index) {
                return ChatTile(chat: widget.chats[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Chats", style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          IconButton(icon: Icon(Icons.more_horiz), onPressed: () {}),
        ],
      ),
    );
  }
}
