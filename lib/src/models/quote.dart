import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/*
Class representing a quote object with an ID, quote, and author.
The class also contains a factory method to parse JSON data into a Quote object.
The data is loaded from a local JSON file containing a list of quotes.

The function geetRandomDailyQuote() returns a random quote based on the current day. 
Returning a different quote each day, the quotes are cycled through in order.
*/
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
