import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lightseed/config.dart'; // Import the configuration file
import 'package:shared_preferences/shared_preferences.dart';
import '../models/affirmation.dart'; // Import the Affirmation model

/*
Service connecting to a Google Sheets API endpoint to fetch all affirmations or a specific affirmation by ID.
*/
class AffirmationsService {
  static const String _cacheKey = 'cached_affirmations';


  // Fetch all affirmations
  Future<List<Affirmation>> fetchAllAffirmations() async {
    final String url = '$baseUrl?sheet=AFFIRMATIONS';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final affirmations = (data['data'] as List)
              .map((item) => Affirmation.fromJson(item))
              .toList();
          await _saveAffirmationsToCache(affirmations);
          return affirmations;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to fetch affirmations. Status code: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw Exception('Network error: $e');
    } catch (e) {
      throw Exception('Error fetching affirmations: $e');
    }
  }

  // Fetch a specific affirmation by ID
  Future<Affirmation> fetchAffirmationById(int id) async {
    final String url = '$baseUrl?sheet=AFFIRMATIONS&id=$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return Affirmation.fromJson(data['data']);
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to fetch affirmation by ID. Status code: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw Exception('Network error: $e');
    } catch (e) {
      throw Exception('Error fetching affirmation by ID: $e');
    }
  }


  // Save affirmations to local cache
  Future<void> _saveAffirmationsToCache(List<Affirmation> affirmations) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(affirmations.map((a) => a.toJson()).toList());
    await prefs.setString(_cacheKey, jsonString);
  }

  // Load affirmations from local cache
  Future<List<Affirmation>> loadAffirmationsFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cacheKey);
    if (jsonString != null) {
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((item) => Affirmation.fromJson(item)).toList();
    }
    return [];
  }

}