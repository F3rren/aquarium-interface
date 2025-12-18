import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:acquariumfe/models/chat_message.dart';
import 'package:acquariumfe/services/ai_chat_service.dart';
import 'package:acquariumfe/services/api_service.dart';
import 'package:uuid/uuid.dart';

part 'ai_chat_provider.g.dart';

/// Provider per il servizio di chat AI
@riverpod
AiChatService aiChatService(AiChatServiceRef ref) {
  final apiService = ApiService();
  return AiChatService(apiService);
}

/// Stato della chat AI
class AiChatState {
  final List<ChatMessage> messages;
  final String? conversationId;
  final bool isLoading;
  final String? error;
  final bool isHealthy;

  AiChatState({
    this.messages = const [],
    this.conversationId,
    this.isLoading = false,
    this.error,
    this.isHealthy = true,
  });

  AiChatState copyWith({
    List<ChatMessage>? messages,
    String? conversationId,
    bool? isLoading,
    String? error,
    bool? isHealthy,
    bool clearConversationId = false,
    bool clearError = false,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      conversationId: clearConversationId
          ? null
          : (conversationId ?? this.conversationId),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isHealthy: isHealthy ?? this.isHealthy,
    );
  }
}

/// Provider per gestire lo stato della chat AI
@riverpod
class AiChat extends _$AiChat {
  static const _uuid = Uuid();

  @override
  AiChatState build() {
    print('🟢 Provider build() called - creating initial state');
    // Non fare health check per ora - sempre online
    return AiChatState(isHealthy: true);
  }

  /// Verifica lo stato di salute del servizio AI
  Future<void> _checkHealth() async {
    try {
      final service = ref.read(aiChatServiceProvider);
      final isHealthy = await service.checkHealth();
      state = state.copyWith(isHealthy: isHealthy);
    } catch (e) {
      state = state.copyWith(isHealthy: false);
    }
  }

  /// Invia un messaggio all'AI
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Aggiungi il messaggio utente alla lista
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      message: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      clearError: true,
    );

    try {
      final service = ref.read(aiChatServiceProvider);
      final request = ChatRequest(
        message: message,
        conversationId: state.conversationId,
      );

      final response = await service.sendMessage(request);

      // Aggiungi la risposta dell'AI alla lista
      final aiMessage = ChatMessage(
        id: _uuid.v4(),
        message: response.response,
        isUser: false,
        timestamp: response.timestamp,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        conversationId: response.conversationId,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Cancella la conversazione corrente
  Future<void> clearConversation() async {
    if (state.conversationId != null) {
      try {
        final service = ref.read(aiChatServiceProvider);
        await service.deleteConversation(state.conversationId!);
      } catch (e) {
        // Ignora errori nella cancellazione lato server
      }
    }

    state = AiChatState();
    await _checkHealth();
  }

  /// Rimuove l'errore
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
