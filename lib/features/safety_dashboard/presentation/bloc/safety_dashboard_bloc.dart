import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_filter.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/repositories/safety_dashboard_repository.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_event.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_state.dart';

class SafetyDashboardBloc
    extends Bloc<SafetyDashboardEvent, SafetyDashboardState> {
  final SafetyDashboardRepository _repository;

  SafetyDashboardBloc({required SafetyDashboardRepository repository})
      : _repository = repository,
        super(const SafetyDashboardState()) {
    on<LoadSafetyDashboard>(_onLoad);
    on<RefreshSafetyDashboard>(_onRefresh);
    on<SafetyFilterUpdated>(_onFilterUpdated);
    on<ResetSafetyFilters>(_onResetFilters);
    on<ResolveAlertEvent>(_onResolveAlert);
    on<ToggleActivityEvent>(_onToggleActivity);
  }

  Future<void> _onLoad(
    LoadSafetyDashboard event,
    Emitter<SafetyDashboardState> emit,
  ) async {
    emit(state.copyWith(status: SafetyDashboardStatus.loading));
    try {
      final metrics = await _repository.getMetrics(state.filter);
      final attendance = await _repository.getAttendanceOverview(state.filter);
      final alerts = await _repository.getAlerts(state.filter);
      final activities = await _repository.getTodayActivities(state.filter);

      emit(state.copyWith(
        status: SafetyDashboardStatus.success,
        metrics: metrics,
        attendanceOverview: attendance,
        alerts: alerts,
        activities: activities,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SafetyDashboardStatus.failure,
        errorMessage: 'Failed to load safety data: $e',
      ));
    }
  }

  Future<void> _onRefresh(
    RefreshSafetyDashboard event,
    Emitter<SafetyDashboardState> emit,
  ) async {
    try {
      final metrics = await _repository.getMetrics(state.filter);
      final attendance = await _repository.getAttendanceOverview(state.filter);
      final alerts = await _repository.getAlerts(state.filter);
      final activities = await _repository.getTodayActivities(state.filter);

      emit(state.copyWith(
        status: SafetyDashboardStatus.success,
        metrics: metrics,
        attendanceOverview: attendance,
        alerts: alerts,
        activities: activities,
        clearActionMessage: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Refresh error: $e',
      ));
    }
  }

  Future<void> _onFilterUpdated(
    SafetyFilterUpdated event,
    Emitter<SafetyDashboardState> emit,
  ) async {
    emit(state.copyWith(
      filter: event.filter,
      status: SafetyDashboardStatus.loading,
    ));
    try {
      final metrics = await _repository.getMetrics(event.filter);
      final attendance = await _repository.getAttendanceOverview(event.filter);
      final alerts = await _repository.getAlerts(event.filter);
      final activities = await _repository.getTodayActivities(event.filter);

      emit(state.copyWith(
        status: SafetyDashboardStatus.success,
        metrics: metrics,
        attendanceOverview: attendance,
        alerts: alerts,
        activities: activities,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SafetyDashboardStatus.failure,
        errorMessage: 'Filter error: $e',
      ));
    }
  }

  Future<void> _onResetFilters(
    ResetSafetyFilters event,
    Emitter<SafetyDashboardState> emit,
  ) async {
    final reset = SafetyFilterState(
      project: event.defaultProject,
      site: event.defaultSite,
      department: 'All',
      contractor: 'All',
      dateRange: 'Today',
      status: 'All',
      severity: 'All',
    );
    add(SafetyFilterUpdated(reset));
  }

  Future<void> _onResolveAlert(
    ResolveAlertEvent event,
    Emitter<SafetyDashboardState> emit,
  ) async {
    await _repository.resolveAlert(event.alertId);
    final alerts = await _repository.getAlerts(state.filter);
    emit(state.copyWith(
      alerts: alerts,
      actionSuccessMessage: 'Safety alert resolved and action logged.',
    ));
  }

  Future<void> _onToggleActivity(
    ToggleActivityEvent event,
    Emitter<SafetyDashboardState> emit,
  ) async {
    await _repository.toggleActivityCompletion(event.activityId);
    final activities = await _repository.getTodayActivities(state.filter);
    emit(state.copyWith(
      activities: activities,
    ));
  }
}
