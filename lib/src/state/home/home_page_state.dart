import 'package:kodo/src/models/chat_tile_model.dart';
import 'package:kodo/src/models/story_model.dart';

class HomePageState {
  final bool isUserCreated;
  final List<Story?> stories;
  final List<ChatTileModel> chatTiles;

  HomePageState({this.isUserCreated = false, this.stories = const [], this.chatTiles = const []});

  HomePageState copyWith({
    bool? isUserCreated,
    List<Story?>? stories,
    List<ChatTileModel>? chatTiles,
  }) {
    return HomePageState(
      isUserCreated: isUserCreated ?? this.isUserCreated,
      stories: stories ?? this.stories,
      chatTiles: chatTiles ?? this.chatTiles,
    );
  }
}
