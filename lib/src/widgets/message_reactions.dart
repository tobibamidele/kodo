import 'package:flutter/material.dart';

class MessageReactions extends StatelessWidget {
  final Map<String, List<String>> reactions;
  final String currentUid;
  final void Function(String emoji) onTap;

  const MessageReactions({
    super.key,
    required this.reactions,
    required this.currentUid,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (reactions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 6,
        children: reactions.entries.map((entry) {
          final emoji = entry.key;
          final users = entry.value;
          final reactedByMe = users.contains(currentUid);

          return GestureDetector(
            onTap: () => onTap(emoji),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: reactedByMe
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    users.length.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
