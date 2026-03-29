import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_item.dart';

/// DTO: kennt JSON, gibt Domain-Entities zurueck.
class DashboardItemModel {
  const DashboardItemModel({
    required this.id,
    required this.title,
    required this.type,
    required this.sourceService,
  });

  factory DashboardItemModel.fromJson(Map<String, dynamic> json) =>
      DashboardItemModel(
        id: json['id'] as String,
        title: json['title'] as String,
        type: json['type'] as String,
        sourceService: json['source_service'] as String,
      );

  final String id;
  final String title;
  final String type;
  final String sourceService;

  DashboardItem toEntity() => switch (type) {
        'todo' => TodoItem(
            id: id,
            title: title,
            sourceService: sourceService,
            isDone: false,
          ),
        'event' => CalendarEventItem(
            id: id,
            title: title,
            sourceService: sourceService,
            startTime: DateTime.now(),
          ),
        _ => NoteItem(id: id, title: title, sourceService: sourceService),
      };
}
