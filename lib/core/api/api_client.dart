// TODO(phase-3): Dio-Instanz konfigurieren.
// BaseURL und Timeouts kommen aus --dart-define.
// Interceptoren: Logging -> Auth -> Refresh -> Error-Mapping.
//
// Dio createApiClient() {
//   return Dio(BaseOptions(
//     baseUrl: const String.fromEnvironment("API_BASE_URL"),
//     connectTimeout: const Duration(seconds: 10),
//     receiveTimeout: const Duration(seconds: 30),
//   ));
// }
