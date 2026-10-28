import 'package:equatable/equatable.dart';

enum ActivityCategory {
  inspection('Scheduled Inspections'),
  toolboxTalk('Toolbox Talks'),
  training('Training Sessions'),
  permitExpiry('Permit Expirations'),
  safetyTask('Assigned Safety Tasks');

  final String label;
  const ActivityCategory(this.label);
}

class TodayActivity extends Equatable {
  final String id;
  final ActivityCategory category;
  final String title;
  final String subtitle;
  final String time;
  final String location;
  final String status;
  final int? attendeesCount;
  final bool isCompleted;

  const TodayActivity({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.location,
    required this.status,
    this.attendeesCount,
    this.isCompleted = false,
  });

  TodayActivity copyWith({
    String? id,
    ActivityCategory? category,
    String? title,
    String? subtitle,
    String? time,
    String? location,
    String? status,
    int? attendeesCount,
    bool? isCompleted,
  }) {
    return TodayActivity(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      time: time ?? this.time,
      location: location ?? this.location,
      status: status ?? this.status,
      attendeesCount: attendeesCount ?? this.attendeesCount,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        category,
        title,
        subtitle,
        time,
        location,
        status,
        attendeesCount,
        isCompleted,
      ];
}
