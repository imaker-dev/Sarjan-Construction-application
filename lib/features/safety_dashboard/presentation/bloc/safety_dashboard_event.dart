import 'package:equatable/equatable.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_filter.dart';

abstract class SafetyDashboardEvent extends Equatable {
  const SafetyDashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadSafetyDashboard extends SafetyDashboardEvent {
  const LoadSafetyDashboard();
}

class RefreshSafetyDashboard extends SafetyDashboardEvent {
  const RefreshSafetyDashboard();
}

class SafetyFilterUpdated extends SafetyDashboardEvent {
  final SafetyFilterState filter;

  const SafetyFilterUpdated(this.filter);

  @override
  List<Object?> get props => [filter];
}

class ResetSafetyFilters extends SafetyDashboardEvent {
  final String defaultProject;
  final String defaultSite;

  const ResetSafetyFilters({
    required this.defaultProject,
    required this.defaultSite,
  });

  @override
  List<Object?> get props => [defaultProject, defaultSite];
}

class ResolveAlertEvent extends SafetyDashboardEvent {
  final String alertId;

  const ResolveAlertEvent(this.alertId);

  @override
  List<Object?> get props => [alertId];
}

class ToggleActivityEvent extends SafetyDashboardEvent {
  final String activityId;

  const ToggleActivityEvent(this.activityId);

  @override
  List<Object?> get props => [activityId];
}
