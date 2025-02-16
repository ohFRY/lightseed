import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:lightseed/src/models/timeline_item.dart';
import 'package:lightseed/src/models/affirmation.dart';

void main() {
  group('TimelineItem', () {
    final testUserId = 'test-user-123';
    final testDate = DateTime.parse('2023-01-01T12:00:00Z');

    test('should create instance with required parameters', () {
      final item = TimelineItem(
        id: const Uuid().v4(),
        userId: testUserId,
        content: 'Test content',
        type: TimelineItemType.affirmation,
        createdAt: testDate,
      );
      
      expect(item.userId, equals(testUserId));
      expect(item.content, equals('Test content'));
      expect(item.type, equals(TimelineItemType.affirmation));
      expect(item.createdAt, equals(testDate));
      expect(item.metadata, equals({}));
    });

    group('fromAffirmation', () {
      test('should create from complete affirmation', () {
        final affirmation = Affirmation(
          id: 1,
          content: 'Test affirmation',
          createdAt: testDate,
        );

        final item = TimelineItem.fromAffirmation(affirmation, testUserId);
        
        expect(item.userId, equals(testUserId));
        expect(item.content, equals('Test affirmation'));
        expect(item.type, equals(TimelineItemType.affirmation));
        expect(item.metadata['affirmation_id'], equals(1));
        expect(item.metadata['saved_at'], isNotNull);
      });
    });

    group('fromJson', () {
      test('should create instance from complete json', () {
        final testId = const Uuid().v4();
        final json = {
          'id': testId,
          'user_id': testUserId,
          'content': 'Test content',
          'type': 'affirmation',
          'created_at': '2023-01-01T12:00:00Z',
          'metadata': {
            'affirmation_id': 1,
            'saved_at': '2023-01-01T12:00:00Z'
          }
        };

        final item = TimelineItem.fromJson(json);
        
        expect(item.id, equals(testId));
        expect(item.userId, equals(testUserId));
        expect(item.content, equals('Test content'));
        expect(item.type, equals(TimelineItemType.affirmation));
        expect(item.createdAt, equals(testDate));
        expect(item.metadata['affirmation_id'], equals(1));
      });

      test('should handle different TimelineItemTypes', () {
        final types = {
          'journalEntry': TimelineItemType.journalEntry,
          'emotionLog': TimelineItemType.emotionLog,
        };

        types.forEach((jsonValue, expectedType) {
          final json = {
            'id': const Uuid().v4(),
            'user_id': testUserId,
            'content': 'Test content',
            'type': jsonValue,
            'created_at': '2023-01-01T12:00:00Z',
            'metadata': {}
          };

          final item = TimelineItem.fromJson(json);
          expect(item.type, equals(expectedType));
        });
      });
    });

    group('toJson', () {
      test('should convert instance to json with all fields', () {
        final testId = const Uuid().v4();
        final item = TimelineItem(
          id: testId,
          userId: testUserId,
          content: 'Test content',
          type: TimelineItemType.affirmation,
          createdAt: testDate,
          updatedAt: testDate,  // Add updatedAt
          metadata: {
            'affirmation_id': 1,
            'saved_at': testDate.toIso8601String()
          }
        );

        final json = item.toJson();
        
        expect(json['id'], equals(testId));
        expect(json['user_id'], equals(testUserId));
        expect(json['content'], equals('Test content'));
        expect(json['type'], equals('affirmation'));
        expect(json['created_at'], equals(testDate.toIso8601String()));
        expect(json['updated_at'], equals(testDate.toIso8601String()));
        expect(json['metadata']['affirmation_id'], equals(1));
      });

      test('should exclude null updatedAt from json', () {
        final item = TimelineItem(
          id: const Uuid().v4(),
          userId: testUserId,
          content: 'Test content',
          type: TimelineItemType.affirmation,
          createdAt: testDate,
          updatedAt: null,
        );

        final json = item.toJson();
        expect(json.containsKey('updated_at'), isFalse);
      });
    });

    test('should maintain data consistency between fromJson and toJson', () {
      final testId = const Uuid().v4();
      final initialJson = {
        'id': testId,
        'user_id': testUserId,
        'content': 'Test content',
        'type': 'affirmation',
        'created_at': '2023-01-01T12:00:00Z',
        'updated_at': '2023-01-01T12:00:00Z',
        'metadata': {
          'affirmation_id': 1,
          'saved_at': '2023-01-01T12:00:00Z'
        }
      };

      final item = TimelineItem.fromJson(initialJson);
      final resultJson = item.toJson();
      
      expect(resultJson, equals(initialJson));
    });
  });
}