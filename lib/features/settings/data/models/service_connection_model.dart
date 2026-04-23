import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';

class ServiceConnectionModel {
  const ServiceConnectionModel({
    required this.service,
    required this.configured,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceConnectionModel.fromJson(Map<String, dynamic> json) =>
      ServiceConnectionModel(
        service: json['service'] as String,
        configured: json['configured'] as bool,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  final String service;
  final bool configured;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceConnection toEntity() => ServiceConnection(
    service: _serviceTypeFromString(service),
    status: configured ? ConnectionStatus.connected : ConnectionStatus.disconnected,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

ServiceType _serviceTypeFromString(String value) => switch (value) {
  'notion' => ServiceType.notion,
  'todoist' => ServiceType.todoist,
  'obsidian' => ServiceType.obsidian,
  'onenote' => ServiceType.oneNote,
  'google_calendar' => ServiceType.googleCalendar,
  _ => throw ArgumentError('Unknown service type: $value'),
};

String serviceTypeToString(ServiceType service) => switch (service) {
  ServiceType.notion => 'notion',
  ServiceType.todoist => 'todoist',
  ServiceType.obsidian => 'obsidian',
  ServiceType.oneNote => 'onenote',
  ServiceType.googleCalendar => 'google_calendar',
};
