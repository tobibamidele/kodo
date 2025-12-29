import 'package:kodo/src/models/settings_tile_model.dart';
import 'package:kodo/src/models/user_model.dart';

class SettingsPageState {
  final KodoUser? user;
  final List<SettingsTileModel>? tiles;

  const SettingsPageState({this.user, this.tiles});

  SettingsPageState copyWith({KodoUser? user, List<SettingsTileModel>? tiles}) {
    return SettingsPageState(
      user: user ?? this.user,
      tiles: tiles ?? this.tiles,
    );
  }
}
