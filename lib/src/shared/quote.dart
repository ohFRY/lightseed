import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Quote {
  final int id;
  final String quote;
  final String author;

  Quote({required this.id, required this.quote, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      quote: json['quote'],
      author: json['author'],
    );
  }
}

Future<Quote> getRandomDailyQuote() async {
  // Load JSON data from assets
  final String response = await rootBundle.loadString('assets/quotes.json');
  final List<dynamic> data = json.decode(response);

  // Parse the JSON into a list of Quote objects
  final List<Quote> quotes = data.map((json) => Quote.fromJson(json)).toList();

  // Get a random quote based on the current day
  final int dayOfYear = int.parse(DateFormat("D").format(DateTime.now()));
  final int index = dayOfYear % quotes.length;

  return quotes[index];
}
