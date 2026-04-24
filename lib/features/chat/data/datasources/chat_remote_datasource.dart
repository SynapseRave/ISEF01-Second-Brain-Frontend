import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/core/auth/auth_repository.dart';
import 'package:isef01_second_brain_frontend/core/utils/app_config.dart';
import 'package:isef01_second_brain_frontend/features/chat/data/models/sse_event_model.dart';

abstract interface class ChatRemoteDatasource {
  Stream<SseEvent> sendMessage(String prompt, {String? conversationId});
}

@LazySingleton(as: ChatRemoteDatasource)
class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  const ChatRemoteDatasourceImpl(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Stream<SseEvent> sendMessage(String prompt, {String? conversationId}) async* {
    final token = await _authRepository.getAccessToken();
    if (token == null) {
      yield const SseErrorEvent('Nicht authentifiziert.');
      return;
    }

    final bodyMap = <String, dynamic>{'prompt': prompt};
    if (conversationId case final id?) bodyMap['conversation_id'] = id;
    final body = jsonEncode(bodyMap);

    final request =
        http.Request('POST', Uri.parse('${AppConfig.apiBaseUrl}/api/input/'))
          ..headers['Authorization'] = 'Bearer $token'
          ..headers['Content-Type'] = 'application/json'
          ..headers['Accept'] = 'text/event-stream'
          ..body = body;

    final client = http.Client();
    try {
      final streamed = await client.send(request);
      if (streamed.statusCode != 200) {
        yield SseErrorEvent('Serverfehler ${streamed.statusCode}.');
        return;
      }

      final buffer = StringBuffer();
      await for (final chunk in streamed.stream.transform(utf8.decoder)) {
        buffer.write(chunk);
        var content = buffer.toString();
        buffer.clear();

        while (content.contains('\n')) {
          final idx = content.indexOf('\n');
          final line = content.substring(0, idx).trim();
          content = content.substring(idx + 1);

          final event = SseEvent.tryParse(line);
          if (event != null) {
            yield event;
            if (event is SseDoneEvent) return;
          }
        }
        buffer.write(content);
      }
    } finally {
      client.close();
    }
  }
}
