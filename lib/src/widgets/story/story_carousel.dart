import 'package:flutter/material.dart';
import 'package:kodo/src/models/story_model.dart';
import 'package:kodo/src/widgets/story/story_circle.dart';

class StoryCarousel extends StatelessWidget {
  final List<Story?> stories;

  const StoryCarousel({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: stories.length + 2, // add story + divider
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          // Add story
          if (index == 0) {
            return StoryCircle(
              onPressed: () {},
              text: "Add story",
              child: const Icon(Icons.add),
            );
          }

          // Divider
          if (index == 1) {
            return Container(
              height: 50,
              width: 1,
              color: Theme.of(context).cardTheme.color ?? Colors.grey.shade400,
            );
          }

          // Stories
          final story = stories[index - 2];
          if (story == null) return const SizedBox.shrink();

          return StoryCircle(
            onPressed: () {},
            onLongPressed: () {},
            text: story.username,
            pfp: story.pfpUrl,
          );
        },
      ),
    );
  }
}

// class StoryCarousel extends StatefulWidget {
//   final List<Story?> stories;

//   const StoryCarousel({super.key, required this.stories});

//   @override
//   State<StoryCarousel> createState() => _StoryCarouselState();
// }

// class _StoryCarouselState extends State<StoryCarousel> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 90,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: StoryCircle(
//               onPressed: () {},
//               text: "Add story",
//               child: Icon(Icons.add),
//             ),
//           ),

//           const SizedBox(width: 6),

//           // Divider
//           Container(
//             height: 50,
//             width: 1,
//             color: Theme.of(context).cardTheme.color ?? Colors.grey.shade400,
//           ),

//           Expanded(
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               itemCount: (widget.stories.length - 1)
//                   .clamp(0, double.infinity)
//                   .toInt(),
//               separatorBuilder: (_, _) => const SizedBox(width: 12),
//               itemBuilder: (context, index) {
//                 if (widget.stories[index] != null) {
//                   return StoryCircle(
//                     onPressed: () {},
//                     onLongPressed: () {},
//                     text: widget.stories[index]!.username,
//                     pfp: widget.stories[index]!.pfpUrl,
//                   );
//                 } else {
//                   return const SizedBox.shrink();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
