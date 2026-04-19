import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';

class ServiceConnectionModel {
  const ServiceConnectionModel({required this.service, required this.status});

  factory ServiceConnectionModel.fromJson(Map<String, dynamic> json) =>
      ServiceConnectionModel(
        service: json['service'] as String,
        status: json['status'] as String,
      );

  final String service;
  final String status;

  ServiceConnection toEntity() => ServiceConnection(
    service: ServiceType.values.firstWhere((e) => e.name == service),
    status: ConnectionStatus.values.firstWhere((e) => e.name == status),
  );
}
