import 'package:flutter/material.dart';

class StoryCircle extends StatelessWidget {
  final Widget? child;
  final String? pfp;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final bool? opened;
  final String text;

  const StoryCircle({
    super.key,
    this.child,
    this.pfp,
    required this.onPressed,
    required this.text,
    this.opened = false,
    this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onPressed,
          onLongPress: onLongPressed,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
            child: (child != null)
                ? child
                : (pfp == null)
                ? ColoredBox(color: Theme.of(context).primaryColor)
                : (pfp!.isEmpty)
                ? ColoredBox(color: Theme.of(context).primaryColor)
                : ClipOval(child: Image.network(pfp!, fit: BoxFit.cover)),
          ),
        ),

        const SizedBox(height: 5),

        Text(
          text,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}
