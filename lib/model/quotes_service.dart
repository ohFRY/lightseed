import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart'; // Import the configuration file

class QuotesService {
  
  // Fetch all quotes
  Future<List<Map<String, dynamic>>> fetchAllQuotes() async {
    final String url = '$baseUrl?sheet=QUOTES';
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
        throw Exception('Failed to fetch quotes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching quotes: $e');
    }
  }

  // Fetch a specific quote by ID
  Future<String> fetchQuoteById(int id) async {
    final String url = '$baseUrl?sheet=QUOTES&id=$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data['data']['quote'] as String;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to fetch quote by ID. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching quote by ID: $e');
    }
  }
}
