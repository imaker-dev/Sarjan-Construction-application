import 'package:sarjan_construction/features/safety_dashboard/domain/models/attendance_overview.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_alert.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_filter.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_metrics.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/today_activity.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/repositories/safety_dashboard_repository.dart';

class SafetyDashboardRepositoryImpl implements SafetyDashboardRepository {
  List<SafetyAlert>? _cachedAlerts;
  List<TodayActivity>? _cachedActivities;

  @override
  Future<SafetyMetrics> getMetrics(SafetyFilterState filter) async {
    final isMetro = filter.project.contains('Metro');
    final isRiverfront = filter.project.contains('Riverfront');

    final int total = isMetro ? 620 : (isRiverfront ? 340 : 480);
    final int present = (total * 0.86).round();
    final int absent = total - present;

    return SafetyMetrics(
      totalLabour: total,
      labourPresent: present,
      labourAbsent: absent,
      pendingOnboarding: isMetro ? 22 : 14,
      safetyIncidents: isRiverfront ? 0 : 2,
      openHazards: isMetro ? 14 : 9,
      pendingInspections: 5,
      ppeCompliance: isRiverfront ? 97.4 : 94.2,
      expiredDocuments: isMetro ? 11 : 7,
      pendingActions: isRiverfront ? 6 : 11,
    );
  }

  @override
  Future<AttendanceOverview> getAttendanceOverview(SafetyFilterState filter) async {
    final isMetro = filter.project.contains('Metro');
    final total = isMetro ? 620 : 480;
    final present = (total * 0.86).round();

    return AttendanceOverview(
      totalActiveLabour: total,
      attendanceCompleted: present,
      attendanceNotRecorded: total - present,
      currentSession: 'Morning General Shift (07:00 AM - 04:00 PM)',
      sessionStatus: 'In Progress (Active Muster)',
      missingCheckoutRecords: isMetro ? 28 : 19,
      departmentBreakdown: const {
        'Civil & RCC': 180,
        'Rebar & Shuttering': 110,
        'Electrical & MEP': 65,
      },
    );
  }

  @override
  Future<List<SafetyAlert>> getAlerts(SafetyFilterState filter) async {
    // Clean dataset of 4 representative alerts (3-5 range)
    _cachedAlerts ??= [
      const SafetyAlert(
        id: 'alt_01',
        category: SafetyAlertCategory.criticalHazard,
        title: 'Unprotected Floor Opening at 14th Floor Lift Shaft',
        description:
            'Edge guardrail dislodged during staging. Critical fall hazard of 42m height.',
        location: 'Tower A - 14th Floor Lift Core',
        severity: AlertSeverity.critical,
        timeAgo: '18m ago',
        status: 'Immediate Action',
        actionLabel: 'Barricade & Re-install',
      ),
      const SafetyAlert(
        id: 'alt_02',
        category: SafetyAlertCategory.recentIncident,
        title: 'Minor Hand Laceration during Rebar Tying',
        description:
            'Worker sustained 2cm laceration while handling untied 16mm rebar. First aid applied on site.',
        location: 'Tower B - Foundation Zone',
        severity: AlertSeverity.medium,
        timeAgo: '1h 20m ago',
        status: 'First Aid Administered',
        actionLabel: 'View Incident Log',
      ),
      const SafetyAlert(
        id: 'alt_03',
        category: SafetyAlertCategory.overdueAction,
        title: 'Repair Damaged Earth-Pit Grounding Cable',
        description:
            'Primary grounding cable for temporary distribution box #DB-4 has severed copper strand.',
        location: 'Batching Plant Substation',
        severity: AlertSeverity.high,
        timeAgo: 'Overdue by 1 day',
        assignee: 'P. Sharma (Apex MEP)',
        dueDate: '26 Oct 2026, 17:00',
        status: 'Overdue',
        actionLabel: 'Escalate to Vendor',
      ),
      const SafetyAlert(
        id: 'alt_04',
        category: SafetyAlertCategory.expiredEquipment,
        title: 'Tower Crane #TC-02 Load Cell Calibration Expired',
        description:
            'Third-party statutory inspection certificate expired. Auto-cut sensor recertification needed.',
        location: 'Tower A Central Core',
        severity: AlertSeverity.critical,
        timeAgo: 'Expired 2 days ago',
        status: 'Operation Prohibited',
        actionLabel: 'Request Audit',
      ),
    ];

    if (filter.severity != 'All') {
      return _cachedAlerts!
          .where((a) =>
              a.severity.label.toLowerCase() == filter.severity.toLowerCase())
          .toList();
    }
    return _cachedAlerts!;
  }

  @override
  Future<List<TodayActivity>> getTodayActivities(SafetyFilterState filter) async {
    // Clean dataset of 4 representative activities (3-5 range)
    _cachedActivities ??= [
      const TodayActivity(
        id: 'act_01',
        category: ActivityCategory.inspection,
        title: 'Tower Crane & Lifting Gear Daily Pre-use Check',
        subtitle: 'Brakes, limit switches, wire rope condition & wind gauge',
        time: '08:30 AM',
        location: 'Zone 1 Heavy Crane TC-01',
        status: 'Completed',
        isCompleted: true,
      ),
      const TodayActivity(
        id: 'act_02',
        category: ActivityCategory.toolboxTalk,
        title: 'Daily Safety Briefing: Fall Protection & 100% Tie-Off',
        subtitle: 'Conducted by Rajesh Patel with mandatory attendance log',
        time: '07:15 AM',
        location: 'Assembly Yard 1',
        status: 'Conducted',
        attendeesCount: 148,
        isCompleted: true,
      ),
      const TodayActivity(
        id: 'act_03',
        category: ActivityCategory.permitExpiry,
        title: 'Hot Work Permit #HWP-2026-088 (Oxy-acetylene cutting)',
        subtitle: 'Continuous gas monitoring & dedicated fire watcher active',
        time: 'Expires in 1h 25m',
        location: 'Structural Core Level 9',
        status: 'Expiring Soon',
        isCompleted: false,
      ),
      const TodayActivity(
        id: 'act_04',
        category: ActivityCategory.safetyTask,
        title: 'Sign off on Barricading Handover at Lift Core 3',
        subtitle: 'Verify double-rail installation and safety warning signage',
        time: 'Due by 12:00 PM',
        location: 'Tower B Core',
        status: 'Action Required',
        isCompleted: false,
      ),
    ];

    return _cachedActivities!;
  }

  @override
  Future<void> resolveAlert(String alertId) async {
    if (_cachedAlerts != null) {
      _cachedAlerts = _cachedAlerts!.where((a) => a.id != alertId).toList();
    }
  }

  @override
  Future<void> toggleActivityCompletion(String activityId) async {
    if (_cachedActivities != null) {
      _cachedActivities = _cachedActivities!.map((act) {
        if (act.id == activityId) {
          final newState = !act.isCompleted;
          return act.copyWith(
            isCompleted: newState,
            status: newState ? 'Completed' : 'In Progress',
          );
        }
        return act;
      }).toList();
    }
  }
}
