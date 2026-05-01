import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_item.dart';

sealed class DashboardState {
  const DashboardState();
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardLoaded extends DashboardState {
  const DashboardLoaded({this.nextEvent, required this.todos, this.lastNote});

  final CalendarEventItem? nextEvent;
  final List<TodoItem> todos;
  final NoteItem? lastNote;
}

final class DashboardError extends DashboardState {
  const DashboardError(this.message);

  final String message;
}
