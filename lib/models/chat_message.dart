class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      isUser: json['isUser'] ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  ChatMessage copyWith({
    String? id,
    String? message,
    bool? isUser,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class ChatRequest {
  final String message;
  final String? conversationId;

  ChatRequest({required this.message, this.conversationId});

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'message': message};
    if (conversationId != null) {
      json['conversationId'] = conversationId;
    }
    return json;
  }
}

class ChatResponse {
  final String response;
  final String conversationId;
  final DateTime timestamp;
  final String? context;

  ChatResponse({
    required this.response,
    required this.conversationId,
    required this.timestamp,
    this.context,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      response: json['response'] ?? '',
      conversationId: json['conversationId'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      context: json['context'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'conversationId': conversationId,
      'timestamp': timestamp.toIso8601String(),
      'context': context,
    };
  }
}
