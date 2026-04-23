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
        // Live-Streaming: einzelne LLM-Tokens aufaddieren.
        'chunk' => SseChunkEvent(json['text'] as String? ?? ''),
        // Zwischenstatus (z. B. "LLM wird angefragt...").
        'status' => SseStatusEvent(json['message'] as String? ?? ''),
        // Tool-Aufruf-Benachrichtigung → als Status anzeigen.
        'tool_call' => SseStatusEvent(
            '${json['service'] ?? ''}: ${json['tool'] ?? ''}…',
          ),
        // Vollständige Antwort nach dem Streaming (Fallback & Deep-Link).
        // Wird im Cubit ignoriert wenn bereits Chunks empfangen wurden.
        'result' => SseResultEvent(
            response: (json['data'] as Map<String, dynamic>?)?['response']
                    as String? ??
                '',
            deepLink: (json['data'] as Map<String, dynamic>?)?['deep_link']
                as String?,
          ),
        // Stream abgeschlossen. input_id kann int oder UUID-String sein.
        'done' => SseDoneEvent(
            (json['input_id'] as num?)?.toInt() ??
                int.tryParse(json['input_id']?.toString() ?? '') ??
                0,
          ),
        'error' =>
          SseErrorEvent(json['message'] as String? ?? 'Unbekannter Fehler.'),
        _ => null,
      };
    } catch (_) {
      return null;
    }
  }
}

/// Ein einzelner gestreamter Token vom LLM.
final class SseChunkEvent extends SseEvent {
  const SseChunkEvent(this.text);
  final String text;
}

/// Zwischenstatus oder Tool-Call-Meldung.
final class SseStatusEvent extends SseEvent {
  const SseStatusEvent(this.message);
  final String message;
}

/// Abgeschlossene vollständige Antwort (nach Ende des Streamings).
/// Enthält optional einen Deep-Link zur Ressource.
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
