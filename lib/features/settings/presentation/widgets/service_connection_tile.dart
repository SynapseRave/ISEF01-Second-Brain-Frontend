import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';

/// Listeneintrag fuer einen verbindbaren Dienst (z.B. Notion, Todoist).
class ServiceConnectionTile extends StatelessWidget {
  const ServiceConnectionTile({
    super.key,
    required this.connection,
    required this.onConnect,
    required this.onDisconnect,
  });

  final ServiceConnection connection;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  @override
  Widget build(BuildContext context) {
    final isConnected = connection.status == ConnectionStatus.connected;
    return ListTile(
      title: Text(connection.service.name),
      trailing: TextButton(
        onPressed: isConnected ? onDisconnect : onConnect,
        child: Text(isConnected ? 'Trennen' : 'Verbinden'),
      ),
    );
  }
}
