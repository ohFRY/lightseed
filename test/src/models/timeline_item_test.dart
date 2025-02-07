import 'package:test/test.dart';
import 'package:lightseed/src/models/timeline_item.dart';
import 'package:lightseed/src/models/affirmation.dart';

void main() {
  group('TimelineItem', () {
    test('should create instance with required parameters', () {
      final now = DateTime.now();
      final item = TimelineItem(
        id: 1,
        content: 'Test content',
        type: TimelineItemType.affirmation,
        createdAt: now,
        savedAt: now,
      );
      
      expect(item.id, equals(1));
      expect(item.content, equals('Test content'));
      expect(item.type, equals(TimelineItemType.affirmation));
      expect(item.createdAt, equals(now));
      expect(item.savedAt, equals(now));
    });

    group('fromAffirmation', () {
      test('should create from complete affirmation', () {
        final createdAt = DateTime.parse('2023-01-01T12:00:00Z');
        final affirmation = Affirmation(
          id: 1,
          content: 'Test affirmation',
          createdAt: createdAt,
        );

        final item = TimelineItem.fromAffirmation(affirmation);
        
        expect(item.id, equals(1));
        expect(item.content, equals('Test affirmation'));
        expect(item.type, equals(TimelineItemType.affirmation));
        expect(item.createdAt, equals(createdAt));
        expect(item.savedAt, isNotNull);
      });

      test('should handle affirmation with null dates', () {
        final affirmation = Affirmation(
          id: 1,
          content: 'Test affirmation',
        );

        final item = TimelineItem.fromAffirmation(affirmation);
        
        expect(item.id, equals(1));
        expect(item.content, equals('Test affirmation'));
        expect(item.type, equals(TimelineItemType.affirmation));
        expect(item.createdAt, isNotNull);
        expect(item.savedAt, isNotNull);
      });
    });

    group('fromJson', () {
      test('should create instance from complete json', () {
        final json = {
          'id': 1,
          'content': 'Test content',
          'type': 'TimelineItemType.affirmation',
          'created_at': '2023-01-01T12:00:00Z',
          'saved_at': '2023-01-01T12:00:00Z',
        };

        final item = TimelineItem.fromJson(json);
        
        expect(item.id, equals(1));
        expect(item.content, equals('Test content'));
        expect(item.type, equals(TimelineItemType.affirmation));
        expect(item.createdAt, equals(DateTime.parse('2023-01-01T12:00:00Z')));
        expect(item.savedAt, equals(DateTime.parse('2023-01-01T12:00:00Z')));
      });

      test('should handle different TimelineItemTypes', () {
        final types = {
          'TimelineItemType.journalEntry': TimelineItemType.journalEntry,
          'TimelineItemType.emotion': TimelineItemType.emotion,
        };

        types.forEach((jsonValue, expectedType) {
          final json = {
            'id': 1,
            'content': 'Test content',
            'type': jsonValue,
            'created_at': '2023-01-01T12:00:00Z',
            'saved_at': '2023-01-01T12:00:00Z',
          };

          final item = TimelineItem.fromJson(json);
          expect(item.type, equals(expectedType));
        });
      });
    });

    group('toJson', () {
      test('should convert instance to json with all fields', () {
        final dateTime = DateTime.parse('2023-01-01T12:00:00Z');
        final item = TimelineItem(
          id: 1,
          content: 'Test content',
          type: TimelineItemType.affirmation,
          createdAt: dateTime,
          savedAt: dateTime,
        );

        final json = item.toJson();
        
        expect(json['id'], equals(1));
        expect(json['content'], equals('Test content'));
        expect(json['type'], equals('TimelineItemType.affirmation'));
        expect(json['created_at'], equals(dateTime.toIso8601String()));
        expect(json['saved_at'], equals(dateTime.toIso8601String()));
      });
    });

    test('should maintain data consistency between fromJson and toJson', () {
      final initialJson = {
        'id': 1,
        'content': 'Test content',
        'type': 'TimelineItemType.affirmation',
        'created_at': '2023-01-01T12:00:00Z',
        'saved_at': '2023-01-01T12:00:00Z',
      };

      final item = TimelineItem.fromJson(initialJson);
      final resultJson = item.toJson();
      
      expect(resultJson, equals(initialJson));
    });
  });
}