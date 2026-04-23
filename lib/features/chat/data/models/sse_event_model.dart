import 'dart:convert';

sealed class SseEvent {
  const SseEvent();

  static SseEvent? tryParse(String dataLine) {
    final jsonStr = dataLine.startsWith('data:')
        ? dataLine.substring(5).trim()
        : null;
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return switch (json['type'] as String?) {
        'status' => SseStatusEvent(json['message'] as String? ?? ''),
        'result' => SseResultEvent(
            response: (json['data'] as Map<String, dynamic>?)?['response']
                    as String? ??
                '',
            deepLink: (json['data'] as Map<String, dynamic>?)?['deep_link']
                as String?,
          ),
        'done' => SseDoneEvent(json['input_id'] as int? ?? 0),
        'error' => SseErrorEvent(json['message'] as String? ?? 'Unbekannter Fehler.'),
        _ => null,
      };
    } catch (_) {
      return null;
    }
  }
}

final class SseStatusEvent extends SseEvent {
  const SseStatusEvent(this.message);
  final String message;
}

final class SseResultEvent extends SseEvent {
  const SseResultEvent({required this.response, this.deepLink});
  final String response;
  final String? deepLink;
}

final class SseDoneEvent extends SseEvent {
  const SseDoneEvent(this.inputId);
  final int inputId;
}

final class SseErrorEvent extends SseEvent {
  const SseErrorEvent(this.message);
  final String message;
}
