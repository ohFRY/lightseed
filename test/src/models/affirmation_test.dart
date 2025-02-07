import 'package:test/test.dart';
import 'package:lightseed/src/models/affirmation.dart';

void main() {
  group('Affirmation', () {
    test('should create instance with required parameters', () {
      final affirmation = Affirmation(
        id: 1,
        content: 'Test content',
      );
      
      expect(affirmation.id, equals(1));
      expect(affirmation.content, equals('Test content'));
      expect(affirmation.createdAt, isNull);
      expect(affirmation.savedAt, isNull);
    });

    test('should create instance with all parameters', () {
      final now = DateTime.now();
      final affirmation = Affirmation(
        id: 1,
        content: 'Test content',
        createdAt: now,
        savedAt: now,
      );
      
      expect(affirmation.id, equals(1));
      expect(affirmation.content, equals('Test content'));
      expect(affirmation.createdAt, equals(now));
      expect(affirmation.savedAt, equals(now));
    });

    group('fromJson', () {
      test('should create instance from complete json', () {
        final json = {
          'id': 1,
          'content': 'Test content',
          'created_at': '2023-01-01T12:00:00Z',
          'saved_at': '2023-01-01T12:00:00Z',
        };

        final affirmation = Affirmation.fromJson(json);
        
        expect(affirmation.id, equals(1));
        expect(affirmation.content, equals('Test content'));
        expect(affirmation.createdAt, equals(DateTime.parse('2023-01-01T12:00:00Z')));
        expect(affirmation.savedAt, equals(DateTime.parse('2023-01-01T12:00:00Z')));
      });

      test('should create instance with null dates', () {
        final json = {
          'id': 1,
          'content': 'Test content',
          'created_at': null,
          'saved_at': null,
        };

        final affirmation = Affirmation.fromJson(json);
        
        expect(affirmation.id, equals(1));
        expect(affirmation.content, equals('Test content'));
        expect(affirmation.createdAt, isNull);
        expect(affirmation.savedAt, isNull);
      });
    });

    group('toJson', () {
      test('should convert instance to json with all fields', () {
        final dateTime = DateTime.parse('2023-01-01T12:00:00Z');
        final affirmation = Affirmation(
          id: 1,
          content: 'Test content',
          createdAt: dateTime,
          savedAt: dateTime,
        );

        final json = affirmation.toJson();
        
        expect(json['id'], equals(1));
        expect(json['content'], equals('Test content'));
        expect(json['created_at'], equals(dateTime.toIso8601String()));
        expect(json['saved_at'], equals(dateTime.toIso8601String()));
      });

      test('should convert instance to json with null dates', () {
        final affirmation = Affirmation(
          id: 1,
          content: 'Test content',
        );

        final json = affirmation.toJson();
        
        expect(json['id'], equals(1));
        expect(json['content'], equals('Test content'));
        expect(json['created_at'], isNull);
        expect(json['saved_at'], isNull);
      });
    });

    test('should maintain data consistency between fromJson and toJson', () {
      final initialJson = {
        'id': 1,
        'content': 'Test content',
        'created_at': '2023-01-01T12:00:00Z',
        'saved_at': '2023-01-01T12:00:00Z',
      };

      final affirmation = Affirmation.fromJson(initialJson);
      final resultJson = affirmation.toJson();
      
      expect(resultJson, equals(initialJson));
    });
  });
}