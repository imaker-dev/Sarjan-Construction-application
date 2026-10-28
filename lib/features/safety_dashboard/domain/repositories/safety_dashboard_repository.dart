import 'package:sarjan_construction/features/safety_dashboard/domain/models/attendance_overview.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_alert.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_filter.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_metrics.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/today_activity.dart';

abstract class SafetyDashboardRepository {
  Future<SafetyMetrics> getMetrics(SafetyFilterState filter);
  Future<AttendanceOverview> getAttendanceOverview(SafetyFilterState filter);
  Future<List<SafetyAlert>> getAlerts(SafetyFilterState filter);
  Future<List<TodayActivity>> getTodayActivities(SafetyFilterState filter);
  Future<void> resolveAlert(String alertId);
  Future<void> toggleActivityCompletion(String activityId);
}
