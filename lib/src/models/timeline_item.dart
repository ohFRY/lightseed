import 'package:uuid/uuid.dart'; // Add this import
import 'affirmation.dart' show Affirmation;

enum TimelineItemType {
  affirmation,
  journalEntry,
  gratitude,
  morningPages,
  emotionLog,
  activityLog,
  thoughtAwareness
}

class TimelineItem {
  final String id;  // Changed to UUID String
  final String userId;
  final String content;
  final TimelineItemType type;
  final DateTime createdAt;
  final DateTime? updatedAt; // Make nullable
  final Map<String, dynamic> metadata;

  TimelineItem({
    required this.id,
    required this.userId,
    required this.content,
    required this.type,
    required this.createdAt,
    this.updatedAt,
    this.metadata = const {},
  });

  factory TimelineItem.fromAffirmation(Affirmation affirmation, String userId) {
    return TimelineItem(
      id: const Uuid().v4(),
      userId: userId,
      content: affirmation.content,
      type: TimelineItemType.affirmation,
      createdAt: DateTime.now(),
      metadata: {
        'affirmation_id': affirmation.id,
        'saved_at': DateTime.now().toIso8601String(),
      },
    );
  }

  factory TimelineItem.fromJson(Map<String, dynamic> json) {
    return TimelineItem(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      type: TimelineItemType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),  // Fix type casting
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'content': content,
    'type': type.toString().split('.').last,
    'created_at': createdAt.toUtc().toIso8601String(),  // Remove replaceAll('.000', '')
    if (updatedAt != null) 
      'updated_at': updatedAt!.toUtc().toIso8601String(),  // Remove replaceAll('.000', '')
    'metadata': metadata,
  };
}