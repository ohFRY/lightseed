import 'affirmation.dart' show Affirmation;

enum TimelineItemType {
  affirmation,
  journalEntry,
  emotion
}

class TimelineItem {
  final int id;
  final String content;
  final TimelineItemType type;
  final DateTime createdAt;
  final DateTime savedAt;

  TimelineItem({
    required this.id,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.savedAt,
  });

  factory TimelineItem.fromAffirmation(Affirmation affirmation) {
    return TimelineItem(
      id: affirmation.id,
      content: affirmation.content,
      type: TimelineItemType.affirmation,
      createdAt: affirmation.createdAt ?? DateTime.now(),
      savedAt: DateTime.now(),
    );
  }

  factory TimelineItem.fromJson(Map<String, dynamic> json) {
    return TimelineItem(
      id: json['id'],
      content: json['content'],
      type: TimelineItemType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      createdAt: DateTime.parse(json['created_at']),
      savedAt: DateTime.parse(json['saved_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'type': type.toString(),
    'created_at': createdAt.toIso8601String(),
    'saved_at': savedAt.toIso8601String(),
  };
}