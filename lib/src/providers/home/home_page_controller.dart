import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kodo/core/routing/app_routes.dart';
import 'package:kodo/src/models/chat_tile_model.dart';
import 'package:kodo/src/models/user_model.dart';
import 'package:kodo/src/providers/user_provider.dart';
import 'package:kodo/src/services/auth_service.dart';
import 'package:kodo/src/services/chat_service.dart';
import 'package:kodo/src/services/storage_service.dart';
import 'package:kodo/src/state/home/home_page_state.dart';
import 'package:kodo/src/widgets/bottom_modal.dart';

class HomePageController extends Notifier<HomePageState> {
  final storage = KodoStorageService.instance;
  bool _listening = false;

  @override
  HomePageState build() {
    final cachedTiles = storage.getChatTiles();
    final cachedUser = storage.getUser(AuthService.currentUser?.uid ?? "");

    if (!_listening) {
      _listening = true;
      _listenToChatTileStream();
    }

    _checkIfUserExists();

    return HomePageState(
      isUserCreated: (cachedUser == null),
      chatTiles: cachedTiles,
      stories: [],
    );
  }

  void _listenToChatTileStream() {
    ref.listen(chatTilesStreamProvider, (previous, next) {
      next.whenData((tiles) async {
        state = state.copyWith(chatTiles: tiles);
        await storage.cacheChatTiles(tiles);
      });
    });
  }

  void _checkIfUserExists() {
    ref.listen<AsyncValue<KodoUser?>>(userProvider, (previous, next) async {
      next.whenData((user) async {
        if (user == null) {
          state = state.copyWith(isUserCreated: false);
        } else {
          state = state.copyWith(isUserCreated: true);
          storage.cacheUser(user);
        }
      });
    });
  }

  void loadStories() {
    state = state.copyWith(stories: []);
  }

  void onFloatingActionButtonPressed(BuildContext context) {
    showKodoBottomModal(
      context,
      builder: (dismiss) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.message_outlined),
              onTap: () {
                dismiss();
                context.push(AppRoutes.findUser);
              },
              title: Text(
                'New Chat',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Send a message'),
            ),
          ],
        );
      },
    );
  }
}

final homePageControllerProvider =
    NotifierProvider<HomePageController, HomePageState>(HomePageController.new);

// Create a stream provider
final chatTilesStreamProvider = StreamProvider<List<ChatTileModel>>((ref) {
  return ChatService.instance.chatTilesStream();
});
