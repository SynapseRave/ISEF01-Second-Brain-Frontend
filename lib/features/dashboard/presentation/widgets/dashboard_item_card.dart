import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_item.dart';

/// Karte fuer einen Dashboard-Eintrag — empfaengt Domain-Entity, kein JSON.
class DashboardItemCard extends StatelessWidget {
  const DashboardItemCard({super.key, required this.item});
  final DashboardItem item;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          title: Text(item.title),
          subtitle: Text(item.sourceService),
        ),
      );
}
