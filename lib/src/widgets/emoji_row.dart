import 'package:flutter/material.dart';

class EmojiRow extends StatelessWidget {
  final Function(String) onTap;

  const EmojiRow({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final List<String> emojis = [
      // In prod, probably use an `emoji_picker_flutter`
      "❤️",
      "😂",
      "😮",
      "😢",
      "😡",
      "👍",
      "👎",
      "🔥",
      "👏",
      "🎉",
    ];
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 8),
      itemCount: emojis.length,
      separatorBuilder: (_, _) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onTap(emojis[index]),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color!.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(10),
            child: Text(emojis[index], style: TextStyle(fontSize: 25)),
          ),
        );
      },
    );
  }
}
