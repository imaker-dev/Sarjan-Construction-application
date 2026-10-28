import 'package:flutter/material.dart';
import 'package:sarjan_construction/core/theme/app_color_scheme.dart';
import 'package:sarjan_construction/features/auth/domain/models/user.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_filter.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/widgets/emergency_alert_dialog.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/widgets/quick_action_dialogs.dart';

class QuickActionsSection extends StatelessWidget {
  final AuthUser user;
  final SafetyFilterState filter;

  const QuickActionsSection({
    super.key,
    required this.user,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final actions = [
      _ActionItem(
        title: 'Register Labour',
        icon: Icons.person_add_alt_1_rounded,
        color: const Color(0xFF2563EB),
        permissionKey: 'register_labour',
        requiredRole: 'Safety Officer / Supervisor',
        onTap: () {
          QuickActionDialogs.showActionDialog(
            context: context,
            actionTitle: 'Register New Labour',
            icon: Icons.person_add_alt_1_rounded,
            color: const Color(0xFF2563EB),
            defaultFieldLabel: 'Full Name of Worker',
            defaultFieldHint: 'e.g. Suresh Kumar',
            secondaryFieldLabel: 'Aadhaar / National ID & Trade',
            secondaryFieldHint: 'e.g. 4829-XXXX-XXXX | Carpenter',
            successMessage: 'Labour Registered successfully for onboarding review!',
          );
        },
      ),
      _ActionItem(
        title: 'Mark Attendance',
        icon: Icons.fingerprint_rounded,
        color: AppPalette.success,
        permissionKey: 'mark_attendance',
        requiredRole: 'Safety Officer / Supervisor',
        onTap: () {
          QuickActionDialogs.showActionDialog(
            context: context,
            actionTitle: 'Mark Site Attendance',
            icon: Icons.fingerprint_rounded,
            color: AppPalette.success,
            defaultFieldLabel: 'Worker Labour ID / Name',
            defaultFieldHint: 'e.g. LBR-4028 or Ramesh',
            secondaryFieldLabel: 'Shift & Gate',
            secondaryFieldHint: 'Morning Shift - Gate 1',
            successMessage: 'Attendance check-in logged successfully!',
          );
        },
      ),
      _ActionItem(
        title: 'Scan Labour QR',
        icon: Icons.qr_code_scanner_rounded,
        color: const Color(0xFF7C3AED),
        permissionKey: 'scan_qr',
        requiredRole: 'Safety Officer',
        onTap: () {
          QuickActionDialogs.showQrScanSimulator(context);
        },
      ),
      _ActionItem(
        title: 'Report Hazard',
        icon: Icons.warning_amber_rounded,
        color: Colors.deepOrange,
        permissionKey: 'report_hazard',
        requiredRole: 'Safety Officer / Engineer',
        onTap: () {
          QuickActionDialogs.showActionDialog(
            context: context,
            actionTitle: 'Report New Safety Hazard',
            icon: Icons.warning_amber_rounded,
            color: Colors.deepOrange,
            defaultFieldLabel: 'Hazard Description',
            defaultFieldHint: 'e.g. Missing safety net under cantilever scaffold',
            secondaryFieldLabel: 'Specific Location & Severity',
            secondaryFieldHint: 'e.g. Block B Level 4 - Critical',
            successMessage: 'Hazard reported! Corrective action ticket created.',
          );
        },
      ),
      _ActionItem(
        title: 'Report Incident',
        icon: Icons.report_problem_rounded,
        color: AppPalette.danger,
        permissionKey: 'report_incident',
        requiredRole: 'Safety Officer / Manager',
        onTap: () {
          QuickActionDialogs.showActionDialog(
            context: context,
            actionTitle: 'Report Safety Incident',
            icon: Icons.report_problem_rounded,
            color: AppPalette.danger,
            defaultFieldLabel: 'Incident Brief & Time',
            defaultFieldHint: 'e.g. Material slip during crane lift at 11:20 AM',
            secondaryFieldLabel: 'Persons Involved & Injury Status',
            secondaryFieldHint: 'e.g. 1 worker minor scratch - First aid given',
            successMessage: 'Incident logged. Escalated to Safety Manager & PI.',
          );
        },
      ),
      _ActionItem(
        title: 'Start Inspection',
        icon: Icons.playlist_add_check_rounded,
        color: const Color(0xFF0D9488),
        permissionKey: 'start_inspection',
        requiredRole: 'Safety Officer / Supervisor',
        onTap: () {
          QuickActionDialogs.showActionDialog(
            context: context,
            actionTitle: 'Start Safety Inspection',
            icon: Icons.playlist_add_check_rounded,
            color: const Color(0xFF0D9488),
            defaultFieldLabel: 'Inspection Checklist Type',
            defaultFieldHint: 'e.g. Daily Scaffolding & Fall Arrest Checklist',
            secondaryFieldLabel: 'Zone / Equipment Number',
            secondaryFieldHint: 'e.g. Tower A - Hoist #2',
            successMessage: 'Inspection session started! Checklist loaded.',
          );
        },
      ),
      _ActionItem(
        title: 'Issue PPE',
        icon: Icons.shield_outlined,
        color: const Color(0xFF4338CA),
        permissionKey: 'issue_ppe',
        requiredRole: 'Safety Officer',
        onTap: () {
          QuickActionDialogs.showActionDialog(
            context: context,
            actionTitle: 'Issue PPE Equipment',
            icon: Icons.shield_outlined,
            color: const Color(0xFF4338CA),
            defaultFieldLabel: 'Labour ID / Name',
            defaultFieldHint: 'e.g. LBR-3108 Vikram Singh',
            secondaryFieldLabel: 'PPE Items Issued',
            secondaryFieldHint: 'e.g. Safety Helmet + Double Lanyard Harness',
            successMessage: 'PPE issue record logged and acknowledgment filed!',
          );
        },
      ),
      _ActionItem(
        title: 'Create Task',
        icon: Icons.add_task_rounded,
        color: const Color(0xFF0284C7),
        permissionKey: 'create_task',
        requiredRole: 'Supervisor / Manager / Engineer',
        onTap: () {
          QuickActionDialogs.showActionDialog(
            context: context,
            actionTitle: 'Create Assigned Safety Task',
            icon: Icons.add_task_rounded,
            color: const Color(0xFF0284C7),
            defaultFieldLabel: 'Task Title & Corrective Action',
            defaultFieldHint: 'e.g. Replace frayed wire rope on Winch 3',
            secondaryFieldLabel: 'Assignee & Due Date',
            secondaryFieldHint: 'e.g. Kunal Dave (Site Eng) - Today 5 PM',
            successMessage: 'Safety Task assigned and tracked in Tasks tab!',
          );
        },
      ),
      _ActionItem(
        title: 'Request Material',
        icon: Icons.inventory_2_outlined,
        color: const Color(0xFFB45309),
        permissionKey: 'request_material',
        requiredRole: 'Safety Manager / Engineer',
        onTap: () {
          QuickActionDialogs.showActionDialog(
            context: context,
            actionTitle: 'Request Safety Store Material',
            icon: Icons.inventory_2_outlined,
            color: const Color(0xFFB45309),
            defaultFieldLabel: 'Material / Safety Gear Name & Qty',
            defaultFieldHint: 'e.g. 50x High-visibility vests, 20x Full body harness',
            secondaryFieldLabel: 'Site Zone & Justification',
            secondaryFieldHint: 'e.g. Tower B Night shift deployment',
            successMessage: 'Store requisition submitted to Storekeeper!',
          );
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with SOS Alert Chip
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              // Emergency SOS Alert Button
              InkWell(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) => EmergencyAlertDialog(
                      projectName: filter.project,
                      siteName: filter.site,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppPalette.danger.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppPalette.danger.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_rounded, color: AppPalette.danger, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Raise SOS Alert',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppPalette.danger,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Quick Actions in a clean 3-column Grid View
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final item = actions[index];
              final hasPerm = user.hasPermission(item.permissionKey);

              return InkWell(
                onTap: () {
                  if (hasPerm) {
                    item.onTap();
                  } else {
                    QuickActionDialogs.showPermissionNotice(
                      context: context,
                      actionName: item.title,
                      requiredRole: item.requiredRole,
                    );
                  }
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: hasPerm
                          ? item.color.withValues(alpha: 0.25)
                          : theme.colorScheme.outline.withValues(alpha: 0.15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: item.color.withValues(alpha: hasPerm ? 0.12 : 0.06),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item.icon,
                              size: 20,
                              color: hasPerm
                                  ? item.color
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                          if (!hasPerm)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: AppPalette.warning,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.lock_rounded,
                                  size: 9,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: hasPerm
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActionItem {
  final String title;
  final IconData icon;
  final Color color;
  final String permissionKey;
  final String requiredRole;
  final VoidCallback onTap;

  const _ActionItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.permissionKey,
    required this.requiredRole,
    required this.onTap,
  });
}
