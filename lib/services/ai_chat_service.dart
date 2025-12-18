import 'package:acquariumfe/models/chat_message.dart';
import 'package:acquariumfe/services/api_service.dart';

/// Servizio per gestire la chat con l'AI
class AiChatService {
  final ApiService _apiService;

  AiChatService(this._apiService);

  /// Invia un messaggio all'AI e riceve una risposta
  Future<ChatResponse> sendMessage(ChatRequest request) async {
    // Timeout più lungo per l'AI (60 secondi)
    final data = await _apiService.post(
      '/api/ai/chat',
      request.toJson(),
      timeout: const Duration(seconds: 60),
    );
    return ChatResponse.fromJson(data);
  }

  /// Elimina una conversazione
  Future<void> deleteConversation(String conversationId) async {
    await _apiService.delete('/api/ai/conversation/$conversationId');
  }

  /// Verifica lo stato di salute del servizio AI
  Future<bool> checkHealth() async {
    try {
      await _apiService.get('/api/ai/health');
      return true;
    } catch (e) {
      return false;
    }
  }
}
