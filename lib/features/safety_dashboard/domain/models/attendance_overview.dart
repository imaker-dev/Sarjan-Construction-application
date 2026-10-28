import 'package:equatable/equatable.dart';

class AttendanceOverview extends Equatable {
  final int totalActiveLabour;
  final int attendanceCompleted;
  final int attendanceNotRecorded;
  final String currentSession;
  final String sessionStatus;
  final int missingCheckoutRecords;
  final Map<String, int> departmentBreakdown;

  const AttendanceOverview({
    required this.totalActiveLabour,
    required this.attendanceCompleted,
    required this.attendanceNotRecorded,
    required this.currentSession,
    required this.sessionStatus,
    required this.missingCheckoutRecords,
    required this.departmentBreakdown,
  });

  double get completionRate => totalActiveLabour > 0
      ? (attendanceCompleted / totalActiveLabour) * 100
      : 0.0;

  @override
  List<Object?> get props => [
        totalActiveLabour,
        attendanceCompleted,
        attendanceNotRecorded,
        currentSession,
        sessionStatus,
        missingCheckoutRecords,
        departmentBreakdown,
      ];
}
