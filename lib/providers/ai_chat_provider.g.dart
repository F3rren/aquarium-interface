// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiChatServiceHash() => r'e606d420460e8636e2943bc52a41a4504db1d8e4';

/// Provider per il servizio di chat AI
///
/// Copied from [aiChatService].
@ProviderFor(aiChatService)
final aiChatServiceProvider = AutoDisposeProvider<AiChatService>.internal(
  aiChatService,
  name: r'aiChatServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aiChatServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AiChatServiceRef = AutoDisposeProviderRef<AiChatService>;
String _$aiChatHash() => r'acaf4dde1d716be06da0310465ffaa603b8891d1';

/// Provider per gestire lo stato della chat AI
///
/// Copied from [AiChat].
@ProviderFor(AiChat)
final aiChatProvider =
    AutoDisposeNotifierProvider<AiChat, AiChatState>.internal(
      AiChat.new,
      name: r'aiChatProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$aiChatHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AiChat = AutoDisposeNotifier<AiChatState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
