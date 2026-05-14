enum MessageRole { user, ai }

class MessageModel {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;

  const MessageModel({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
  });

  bool get isUser => role == MessageRole.user;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'role': role.name,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      content: map['content'] as String,
      role: MessageRole.values.byName(map['role'] as String),
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}
