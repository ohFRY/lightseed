import 'package:test/test.dart';

extension StringExtensions on String {
  bool get isNotEmpty => this.isNotEmpty;
}

void main() {
  group('StringExtensions', () {
    test('isNotEmpty returns true for non-empty string', () {
      expect('Hello'.isNotEmpty, isTrue);
    });

    test('isNotEmpty returns false for empty string', () {
      expect(''.isNotEmpty, isFalse);
    });
  });
}