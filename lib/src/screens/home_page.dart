import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kodo/core/routing/app_routes.dart';
import 'package:kodo/src/providers/home/home_page_controller.dart';
import 'package:kodo/src/services/auth_service.dart';
import 'package:kodo/src/state/home/home_page_state.dart';
import 'package:kodo/src/widgets/chats/chat_tile.dart';
import 'package:kodo/src/widgets/story/story_carousel.dart';

class HomePage extends ConsumerStatefulWidget {
  static const String routeName = "/home";
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homePageControllerProvider.notifier).loadStories();
    });
  }

  @override
  Widget build(BuildContext context) {
    // No more .when() - just watch the state directly
    final homeState = ref.watch(homePageControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Kodo", style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: "New chat",
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          ref
              .read(homePageControllerProvider.notifier)
              .onFloatingActionButtonPressed(context);
        },
      ),
      body: buildHomePage(homeState),
    );
  }

  Widget buildHomePage(HomePageState state) {
    print('tiles: ${state.chatTiles.length}');
    final controller = ref.read(homePageControllerProvider.notifier);
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(child: StoryCarousel(stories: state.stories)),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: _ChatsHeader(state: state, controller: controller),
          ),
          // Handle empty state
          if (state.chatTiles.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('No chats yet')),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return ChatTile(chat: state.chatTiles[index]);
              }, childCount: state.chatTiles.length),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
          SliverToBoxAdapter(
            child: ElevatedButton(
              onPressed: () async {
                await AuthService.signOut();
                if (!mounted) return;
                context.push(AppRoutes.onboarding);
              },
              child: const Text("Sign Out"),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatsHeader extends StatelessWidget {
  final HomePageState state;
  final HomePageController controller;
  const _ChatsHeader({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    final count = state.chatTiles.fold<int>(
      0,
      (total, tile) => total + tile.unreadCount,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          // Display the number of unread chats by the side
          if (state.chatTiles.isEmpty) ...[
            Text("Chats", style: Theme.of(context).textTheme.bodyLarge),
          ] else ...[
            Row(
              children: [
                Text("Chats", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(width: 5),
                if (count > 0) ...[
                  // Only display if the number is greater than 0
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      count.toString(),
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
          const Spacer(),
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
        ],
      ),
    );
  }
}
