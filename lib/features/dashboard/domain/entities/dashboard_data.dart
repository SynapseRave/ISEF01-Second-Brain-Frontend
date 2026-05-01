import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_item.dart';

class DashboardData {
  const DashboardData({this.nextEvent, required this.todos, this.lastNote});

  final CalendarEventItem? nextEvent;
  final List<TodoItem> todos;
  final NoteItem? lastNote;
}
