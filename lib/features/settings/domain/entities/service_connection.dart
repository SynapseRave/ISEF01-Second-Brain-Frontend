enum ServiceType { notion, todoist, obsidian, oneNote, googleCalendar }

enum ConnectionStatus { connected, disconnected, connecting, error }

class ServiceConnection {
  const ServiceConnection({
    required this.service,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  final ServiceType service;
  final ConnectionStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
