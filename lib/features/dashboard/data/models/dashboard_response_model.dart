import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_item.dart';

class DashboardEventModel {
  const DashboardEventModel({
    required this.id,
    required this.title,
    required this.startTime,
    required this.sourceService,
  });

  factory DashboardEventModel.fromJson(Map<String, dynamic> json) =>
      DashboardEventModel(
        id: json['id'] as String,
        title: json['title'] as String,
        startTime: DateTime.parse(json['start_time'] as String),
        sourceService: json['source_service'] as String,
      );

  final String id;
  final String title;
  final DateTime startTime;
  final String sourceService;

  CalendarEventItem toEntity() => CalendarEventItem(
    id: id,
    title: title,
    sourceService: sourceService,
    startTime: startTime,
  );
}

class DashboardTodoModel {
  const DashboardTodoModel({
    required this.id,
    required this.title,
    required this.sourceService,
  });

  factory DashboardTodoModel.fromJson(Map<String, dynamic> json) =>
      DashboardTodoModel(
        id: json['id'] as String,
        title: json['title'] as String,
        sourceService: json['source_service'] as String,
      );

  final String id;
  final String title;
  final String sourceService;

  TodoItem toEntity() => TodoItem(
    id: id,
    title: title,
    sourceService: sourceService,
    isDone: false,
  );
}

class DashboardNoteModel {
  const DashboardNoteModel({
    required this.id,
    required this.title,
    required this.url,
    required this.sourceService,
  });

  factory DashboardNoteModel.fromJson(Map<String, dynamic> json) =>
      DashboardNoteModel(
        id: json['id'] as String,
        title: json['title'] as String,
        url: json['url'] as String,
        sourceService: json['source_service'] as String,
      );

  final String id;
  final String title;
  final String url;
  final String sourceService;

  NoteItem toEntity() =>
      NoteItem(id: id, title: title, sourceService: sourceService);
}

class DashboardResponseModel {
  const DashboardResponseModel({
    this.nextEvent,
    required this.todos,
    this.lastNote,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) =>
      DashboardResponseModel(
        nextEvent: json['next_event'] != null
            ? DashboardEventModel.fromJson(
                json['next_event'] as Map<String, dynamic>,
              )
            : null,
        todos: (json['todos'] as List<dynamic>)
            .map((e) => DashboardTodoModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        lastNote: json['last_note'] != null
            ? DashboardNoteModel.fromJson(
                json['last_note'] as Map<String, dynamic>,
              )
            : null,
      );

  final DashboardEventModel? nextEvent;
  final List<DashboardTodoModel> todos;
  final DashboardNoteModel? lastNote;
}
