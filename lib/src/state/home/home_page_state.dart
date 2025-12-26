import 'package:kodo/src/models/chat_tile_model.dart';
import 'package:kodo/src/models/story_model.dart';

class HomePageState {
  final List<Story?> stories;
  final List<ChatTileModel> chatTiles;

  HomePageState({this.stories = const [], this.chatTiles = const []});

  HomePageState copyWith({
    List<Story?>? stories,
    List<ChatTileModel>? chatTiles,
    int? unreadChatCount,
  }) {
    return HomePageState(
      stories: stories ?? this.stories,
      chatTiles: chatTiles ?? this.chatTiles,
    );
  }
}
