import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/affirmation.dart';

class SavedAffirmationsService {
  final supabase = Supabase.instance.client;
  
  Future<List<Affirmation>> loadSavedAffirmations() async {
    try {
      final data = await supabase
          .from('saved_affirmations')
          .select()
          .order('saved_at', ascending: false);
          
      return data.map((item) => Affirmation(
        id: item['affirmation_id'],
        content: item['content'],
        createdAt: DateTime.parse(item['created_at']),
        savedAt: DateTime.parse(item['saved_at']),
      )).toList();
    } catch (e) {
      print('Error loading saved affirmations: $e');
      return [];
    }
  }
  
  Future<void> saveAffirmation(Affirmation affirmation) async {
    try {
      await supabase.from('saved_affirmations').insert({
        'user_id': supabase.auth.currentUser!.id,
        'affirmation_id': affirmation.id,
        'content': affirmation.content,
        'created_at': affirmation.createdAt?.toIso8601String(),
        'saved_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error saving affirmation: $e');
      rethrow;
    }
  }
  
  Future<void> removeSavedAffirmation(int affirmationId) async {
    try {
      await supabase
          .from('saved_affirmations')
          .delete()
          .eq('user_id', supabase.auth.currentUser!.id)
          .eq('affirmation_id', affirmationId);
    } catch (e) {
      print('Error removing saved affirmation: $e');
      rethrow;
    }
  }
}