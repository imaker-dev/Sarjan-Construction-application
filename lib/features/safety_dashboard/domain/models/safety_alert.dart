import 'package:equatable/equatable.dart';

enum SafetyAlertCategory {
  criticalHazard('Critical Open Hazards'),
  recentIncident('Recent Incidents'),
  overdueAction('Overdue Corrective Actions'),
  expiredEquipment('Expired Equipment Certs'),
  missingDocument('Missing Labour Documents'),
  attendanceReview('Attendance Review Needed');

  final String label;
  const SafetyAlertCategory(this.label);
}

enum AlertSeverity {
  critical('Critical'),
  high('High'),
  medium('Medium'),
  low('Low');

  final String label;
  const AlertSeverity(this.label);
}

class SafetyAlert extends Equatable {
  final String id;
  final SafetyAlertCategory category;
  final String title;
  final String description;
  final String location;
  final AlertSeverity severity;
  final String timeAgo;
  final String? assignee;
  final String? dueDate;
  final String status;
  final String actionLabel;

  const SafetyAlert({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.location,
    required this.severity,
    required this.timeAgo,
    this.assignee,
    this.dueDate,
    required this.status,
    required this.actionLabel,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        title,
        description,
        location,
        severity,
        timeAgo,
        assignee,
        dueDate,
        status,
        actionLabel,
      ];
}
