import 'package:flutter_test/flutter_test.dart';
import 'package:isef01_second_brain_frontend/features/chat/data/models/sse_event_model.dart';

void main() {
  group('SseEvent.tryParse', () {
    test('chunk → SseChunkEvent mit text', () {
      final event = SseEvent.tryParse('data: {"type":"chunk","text":"Hallo"}');
      expect(event, isA<SseChunkEvent>());
      expect((event as SseChunkEvent).text, 'Hallo');
    });

    test('chunk ohne text → leerer String', () {
      final event = SseEvent.tryParse('data: {"type":"chunk"}');
      expect((event as SseChunkEvent).text, '');
    });

    test('status → SseStatusEvent mit message', () {
      final event = SseEvent.tryParse(
        'data: {"type":"status","message":"LLM läuft"}',
      );
      expect(event, isA<SseStatusEvent>());
      expect((event as SseStatusEvent).message, 'LLM läuft');
    });

    test('tool_call → SseStatusEvent mit service:tool', () {
      final event = SseEvent.tryParse(
        'data: {"type":"tool_call","service":"notion","tool":"search"}',
      );
      expect(event, isA<SseStatusEvent>());
      expect((event as SseStatusEvent).message, 'notion: search…');
    });

    test('result → SseResultEvent mit response', () {
      final event = SseEvent.tryParse(
        'data: {"type":"result","data":{"response":"Fertig","deep_link":null}}',
      );
      expect(event, isA<SseResultEvent>());
      final r = event as SseResultEvent;
      expect(r.response, 'Fertig');
      expect(r.deepLink, isNull);
    });

    test('result mit deep_link', () {
      final event = SseEvent.tryParse(
        'data: {"type":"result","data":{"response":"ok","deep_link":"https://notion.so/1"}}',
      );
      expect((event as SseResultEvent).deepLink, 'https://notion.so/1');
    });

    test('done mit int input_id → SseDoneEvent', () {
      final event = SseEvent.tryParse('data: {"type":"done","input_id":42}');
      expect(event, isA<SseDoneEvent>());
      expect((event as SseDoneEvent).inputId, 42);
    });

    test('done mit String input_id → SseDoneEvent', () {
      final event = SseEvent.tryParse('data: {"type":"done","input_id":"123"}');
      expect(event, isA<SseDoneEvent>());
      expect((event as SseDoneEvent).inputId, 123);
    });

    test('done mit UUID-String input_id → SseDoneEvent mit inputId 0', () {
      // UUID-Strings können nicht als int geparst werden → Fallback 0
      final event = SseEvent.tryParse(
        'data: {"type":"done","input_id":"abc-uuid-1"}',
      );
      expect(event, isA<SseDoneEvent>());
      expect((event as SseDoneEvent).inputId, 0);
    });

    test('error → SseErrorEvent', () {
      final event = SseEvent.tryParse(
        'data: {"type":"error","message":"Timeout"}',
      );
      expect(event, isA<SseErrorEvent>());
      expect((event as SseErrorEvent).message, 'Timeout');
    });

    test('unbekannter Typ → null', () {
      final event = SseEvent.tryParse('data: {"type":"unknown"}');
      expect(event, isNull);
    });

    test('kein data:-Präfix → null', () {
      final event = SseEvent.tryParse('{"type":"chunk","text":"x"}');
      expect(event, isNull);
    });

    test('leerer data-Body → null', () {
      final event = SseEvent.tryParse('data: ');
      expect(event, isNull);
    });

    test('ungültiges JSON → null', () {
      final event = SseEvent.tryParse('data: not-json');
      expect(event, isNull);
    });
  });
}
