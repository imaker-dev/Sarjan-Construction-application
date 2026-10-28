import 'package:equatable/equatable.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/attendance_overview.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_alert.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_filter.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_metrics.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/today_activity.dart';

enum SafetyDashboardStatus { initial, loading, success, failure }

class SafetyDashboardState extends Equatable {
  final SafetyDashboardStatus status;
  final SafetyMetrics? metrics;
  final AttendanceOverview? attendanceOverview;
  final List<SafetyAlert> alerts;
  final List<TodayActivity> activities;
  final SafetyFilterState filter;
  final String? errorMessage;
  final String? actionSuccessMessage;

  const SafetyDashboardState({
    this.status = SafetyDashboardStatus.initial,
    this.metrics,
    this.attendanceOverview,
    this.alerts = const [],
    this.activities = const [],
    this.filter = const SafetyFilterState(),
    this.errorMessage,
    this.actionSuccessMessage,
  });

  bool get isLoading => status == SafetyDashboardStatus.loading;
  bool get isSuccess => status == SafetyDashboardStatus.success;

  SafetyDashboardState copyWith({
    SafetyDashboardStatus? status,
    SafetyMetrics? metrics,
    AttendanceOverview? attendanceOverview,
    List<SafetyAlert>? alerts,
    List<TodayActivity>? activities,
    SafetyFilterState? filter,
    String? errorMessage,
    String? actionSuccessMessage,
    bool clearActionMessage = false,
  }) {
    return SafetyDashboardState(
      status: status ?? this.status,
      metrics: metrics ?? this.metrics,
      attendanceOverview: attendanceOverview ?? this.attendanceOverview,
      alerts: alerts ?? this.alerts,
      activities: activities ?? this.activities,
      filter: filter ?? this.filter,
      errorMessage: errorMessage,
      actionSuccessMessage:
          clearActionMessage ? null : (actionSuccessMessage ?? this.actionSuccessMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        metrics,
        attendanceOverview,
        alerts,
        activities,
        filter,
        errorMessage,
        actionSuccessMessage,
      ];
}
