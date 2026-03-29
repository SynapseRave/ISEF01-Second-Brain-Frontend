/// Basis-Klasse fuer alle Dashboard-Eintraege.
/// Reines Dart — kein Flutter, kein HTTP, kein JSON.
sealed class DashboardItem {
  const DashboardItem({
    required this.id,
    required this.title,
    required this.sourceService,
  });
  final String id;
  final String title;
  final String sourceService;
}

final class NoteItem extends DashboardItem {
  const NoteItem({
    required super.id,
    required super.title,
    required super.sourceService,
  });
}

final class TodoItem extends DashboardItem {
  const TodoItem({
    required super.id,
    required super.title,
    required super.sourceService,
    required this.isDone,
  });
  final bool isDone;
}

final class CalendarEventItem extends DashboardItem {
  const CalendarEventItem({
    required super.id,
    required super.title,
    required super.sourceService,
    required this.startTime,
  });
  final DateTime startTime;
}
