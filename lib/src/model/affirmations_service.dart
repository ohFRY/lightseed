import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../config.dart'; // Import the configuration file

class AffirmationsService {

  // Fetch all affirmations
  Future<List<Map<String, dynamic>>> fetchAllAffirmations() async {
    final String url = '$baseUrl?sheet=AFFIRMATIONS';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return List<Map<String, dynamic>>.from(data['data']);
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
  Future<String> fetchAffirmationById(int id) async {
    final String url = '$baseUrl?sheet=AFFIRMATIONS&id=$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data['data']['content'] as String;
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
}
