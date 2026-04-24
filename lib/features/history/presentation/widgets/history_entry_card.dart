import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/entities/history_entry.dart';

class HistoryEntryCard extends StatelessWidget {
  const HistoryEntryCard({super.key, required this.entry});
  final HistoryEntry entry;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: Text(entry.prompt, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(entry.createdAt.toLocal().toString()),
    ),
  );
}
