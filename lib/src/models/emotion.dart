/// Represents a discrete emotion that users can select when logging their feelings.
/// 
/// Each emotion has a name, description, valence (whether it's positive or negative),
/// and an arousal level (intensity). This model is used throughout the application
/// for emotion logging, display, and analysis.
class Emotion {
  /// Unique identifier for the emotion.
  final String id;
  
  /// Name of the emotion (e.g., "happy", "angry", "anxious").
  final String name;
  
  /// Description of what the emotion feels like or represents.
  final String description;
  
  /// The valence of the emotion - whether it's "positive", "negative", or "neutral".
  /// 
  /// This is used for categorization and visualization purposes.
  final String valence;
  
  /// The intensity level of the emotion - typically "high", "medium", or "low".
  /// 
  /// Represents the arousal component in the valence-arousal emotion model.
  final String arousalLevel;

  /// Creates a new Emotion instance with the provided properties.
  Emotion({
    required this.id,
    required this.name,
    required this.description,
    required this.valence,
    required this.arousalLevel,
  });

  /// Creates an Emotion instance from a JSON map.
  /// 
  /// Used when deserializing emotion data from the database or local storage.
  /// 
  /// @param json The JSON map containing emotion data.
  /// @return A new Emotion instance populated with values from JSON.
  factory Emotion.fromJson(Map<String, dynamic> json) {
    return Emotion(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      valence: json['valence'] ?? '',
      arousalLevel: json['arousal_level'] ?? '',
    );
  }

  /// Converts this emotion to a JSON representation.
  /// 
  /// Used when serializing emotion data for storage or transmission.
  /// 
  /// @return A Map representation of this emotion.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'valence': valence,
      'arousal_level': arousalLevel,
    };
  }
}