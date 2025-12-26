// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatPageController)
const chatPageControllerProvider = ChatPageControllerFamily._();

final class ChatPageControllerProvider
    extends $AsyncNotifierProvider<ChatPageController, ChatPageState> {
  const ChatPageControllerProvider._({
    required ChatPageControllerFamily super.from,
    required ChatModel super.argument,
  }) : super(
         retry: null,
         name: r'chatPageControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatPageControllerHash();

  @override
  String toString() {
    return r'chatPageControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatPageController create() => ChatPageController();

  @override
  bool operator ==(Object other) {
    return other is ChatPageControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatPageControllerHash() =>
    r'fd1f55b0e96b9156e00d43f62f2cc0af271c607e';

final class ChatPageControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatPageController,
          AsyncValue<ChatPageState>,
          ChatPageState,
          FutureOr<ChatPageState>,
          ChatModel
        > {
  const ChatPageControllerFamily._()
    : super(
        retry: null,
        name: r'chatPageControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatPageControllerProvider call(ChatModel chat) =>
      ChatPageControllerProvider._(argument: chat, from: this);

  @override
  String toString() => r'chatPageControllerProvider';
}

abstract class _$ChatPageController extends $AsyncNotifier<ChatPageState> {
  late final _$args = ref.$arg as ChatModel;
  ChatModel get chat => _$args;

  FutureOr<ChatPageState> build(ChatModel chat);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<ChatPageState>, ChatPageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ChatPageState>, ChatPageState>,
              AsyncValue<ChatPageState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
