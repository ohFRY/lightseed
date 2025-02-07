class Affirmation {
  final int id;
  final String content;
  final DateTime? createdAt;  // When the affirmation was created
  final DateTime? savedAt;    // When user saved it

  Affirmation({
    required this.id, 
    required this.content,
    this.createdAt,
    this.savedAt,
  });

  factory Affirmation.fromJson(Map<String, dynamic> json) {
    return Affirmation(
      id: json['id'],
      content: json['content'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      savedAt: json['saved_at'] != null ? DateTime.parse(json['saved_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'created_at': createdAt?.toIso8601String(),
    'saved_at': savedAt?.toIso8601String(),
  };
}