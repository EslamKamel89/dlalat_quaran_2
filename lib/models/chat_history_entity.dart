// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatHistoryEntity {
  String? id;
  final String? title;
  final DateTime timestamp;
  ChatHistoryEntity({this.id, this.title, required this.timestamp}) {
    id ??= createId();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'title': title, 'timestamp': timestamp.toIso8601String()};
  }

  factory ChatHistoryEntity.fromJson(Map<String, dynamic> json) {
    return ChatHistoryEntity(
      id: json['id'] as String,
      title: json['title'] as String?,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  @override
  String toString() => 'ChatHistoryEntity(id: $id, title: $title)';

  static String createId() {
    return "ChatHistoryEntity.${DateTime.now().millisecondsSinceEpoch}";
  }

  ChatHistoryEntity copyWith({String? id, String? title, DateTime? timestamp}) {
    return ChatHistoryEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
