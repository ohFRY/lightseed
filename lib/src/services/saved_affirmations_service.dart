import 'dart:convert';

import 'package:lightseed/src/models/affirmation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedAffirmationsService {
  static const String _savedAffirmationsKey = 'saved_affirmations';
  
  Future<List<Affirmation>> loadSavedAffirmations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_savedAffirmationsKey);
    if (jsonString != null) {
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((item) => Affirmation.fromJson(item)).toList();
    }
    return [];
  }
  
  Future<void> saveAffirmation(Affirmation affirmation) async {
    // Will be useful when implementing database storage
    final savedAffirmation = Affirmation(
      id: affirmation.id,
      content: affirmation.content,
      createdAt: affirmation.createdAt,
      savedAt: DateTime.now(),
    );
    // Save locally for now, later will also save to database
    // ...
  }
}