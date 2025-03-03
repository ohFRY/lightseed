// ignore_for_file: constant_identifier_names

import 'package:uuid/uuid.dart';
import 'affirmation.dart' show Affirmation;

/// Enum representing the different types of items that can appear in a user's timeline.
/// 
/// Used to categorize and filter timeline items in the UI.
enum TimelineItemType {
  affirmation,
  journal_entry,
  gratitude,
  morning_pages,
  emotion_log,
  activity_log,
  thought_awareness
}

/// Represents an item in the user's timeline.
/// 
/// Timeline items are the primary data structure for storing user activities and content
/// such as saved affirmations, journal entries, emotion logs, etc. They are stored both
/// locally and in the Supabase database.
class TimelineItem {
  /// Unique identifier for this timeline item.
  final String id;
  
  /// ID of the user who owns this timeline item.
  final String userId;
  
  /// The primary content of the timeline item (e.g., affirmation text, journal content).
  final String content;
  
  /// The type of timeline item, used for categorization and specialized handling.
  final TimelineItemType type;
  
  /// When this timeline item was created.
  final DateTime createdAt;
  
  /// When this timeline item was last updated, null if never updated.
  final DateTime? updatedAt;
  
  /// Additional data specific to the type of timeline item.
  /// 
  /// May include:
  /// - 'affirmation_id': ID of the original affirmation if type is affirmation
  /// - 'emotion_ids': List of emotion IDs for emotion logs
  /// - 'saved_at': Timestamp when the item was saved (used for syncing)
  final Map<String, dynamic> metadata;

  /// Creates a new timeline item with the specified properties.
  TimelineItem({
    required this.id,
    required this.userId,
    required this.content,
    required this.type,
    required this.createdAt,
    this.updatedAt,
    this.metadata = const {},
  });

  /// Creates a timeline item from an affirmation.
  /// 
  /// @param affirmation The affirmation to convert to a timeline item.
  /// @param userId The ID of the user who is saving this affirmation.
  /// @return A new TimelineItem containing the affirmation's content.
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

  /// Creates a timeline item for logging emotions.
  /// 
  /// @param userId The ID of the user logging the emotions.
  /// @param notes Any notes or context about the emotion log.
  /// @param emotionIds List of IDs representing the emotions being logged.
  /// @return A new TimelineItem representing an emotion log.
  factory TimelineItem.forEmotionLog(String userId, String notes, List<String> emotionIds) {
    return TimelineItem(
      id: const Uuid().v4(),
      userId: userId,
      content: notes,
      type: TimelineItemType.emotion_log,
      createdAt: DateTime.now(),
      metadata: {
        'emotion_ids': emotionIds,
        'saved_at': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Creates a timeline item from a JSON representation.
  /// 
  /// Used when loading timeline items from local storage or the database.
  /// 
  /// @param json The JSON representation of a timeline item.
  /// @return A new TimelineItem populated with the values from JSON.
  /// @throws StateError if the type in the JSON is not valid.
  factory TimelineItem.fromJson(Map<String, dynamic> json) {
    String typeString = json['type'];
    // Convert camel case to snake case
    typeString = typeString.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (Match m) => '${m[1]}_${m[2]}').toLowerCase();
    return TimelineItem(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      type: TimelineItemType.values.firstWhere(
        (e) => e.toString().split('.').last == typeString,
        orElse: () => throw StateError('Invalid type value: ${json['type']}'),
      ),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  /// Converts this timeline item to a JSON representation.
  /// 
  /// Used when saving to local storage or sending to the database.
  /// 
  /// @return A Map representation of this timeline item.
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'content': content,
    'type': type.toString().split('.').last,
    'created_at': createdAt.toUtc().toIso8601String(),
    if (updatedAt != null) 
      'updated_at': updatedAt!.toUtc().toIso8601String(),
    'metadata': metadata,
  };
}