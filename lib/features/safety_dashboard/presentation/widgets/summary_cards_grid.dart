import 'package:flutter/material.dart';
import 'package:sarjan_construction/core/theme/app_color_scheme.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_metrics.dart';

class SummaryCardsGrid extends StatelessWidget {
  final SafetyMetrics metrics;
  final void Function(String title, String details)? onCardTap;

  const SummaryCardsGrid({
    super.key,
    required this.metrics,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final cardsData = [
      _CardModel(
        title: 'Total Labour',
        value: '${metrics.totalLabour}',
        subtitle: 'Registered workers',
        icon: Icons.groups_rounded,
        color: theme.colorScheme.primary,
      ),
      _CardModel(
        title: 'Labour Present',
        value: '${metrics.labourPresent}',
        subtitle: '${metrics.attendancePercentage.toStringAsFixed(0)}% checked in',
        icon: Icons.how_to_reg_rounded,
        color: AppPalette.success,
      ),
      _CardModel(
        title: 'Labour Absent',
        value: '${metrics.labourAbsent}',
        subtitle: 'Unreported',
        icon: Icons.person_off_rounded,
        color: AppPalette.warning,
      ),
      _CardModel(
        title: 'Pending Onboarding',
        value: '${metrics.pendingOnboarding}',
        subtitle: 'Induction due',
        icon: Icons.pending_actions_rounded,
        color: const Color(0xFF8B5CF6),
      ),
      _CardModel(
        title: 'Safety Incidents',
        value: '${metrics.safetyIncidents}',
        subtitle: 'Active this period',
        icon: Icons.crisis_alert_rounded,
        color: AppPalette.danger,
        isWarning: metrics.safetyIncidents > 0,
      ),
      _CardModel(
        title: 'Open Hazards',
        value: '${metrics.openHazards}',
        subtitle: 'Awaiting action',
        icon: Icons.warning_rounded,
        color: Colors.deepOrange,
        isWarning: metrics.openHazards > 0,
      ),
      _CardModel(
        title: 'Pending Inspections',
        value: '${metrics.pendingInspections}',
        subtitle: 'Due today',
        icon: Icons.fact_check_rounded,
        color: AppPalette.info,
      ),
      _CardModel(
        title: 'PPE Compliance',
        value: '${metrics.ppeCompliance.toStringAsFixed(1)}%',
        subtitle: 'Muster checks',
        icon: Icons.security_rounded,
        color: metrics.ppeCompliance >= 95 ? AppPalette.success : AppPalette.warning,
      ),
      _CardModel(
        title: 'Expired Documents',
        value: '${metrics.expiredDocuments}',
        subtitle: 'Certificates',
        icon: Icons.rule_folder_rounded,
        color: AppPalette.danger,
        isWarning: metrics.expiredDocuments > 0,
      ),
      _CardModel(
        title: 'Pending Actions',
        value: '${metrics.pendingActions}',
        subtitle: 'Corrective tasks',
        icon: Icons.assignment_late_rounded,
        color: const Color(0xFFD97706),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Key Site KPIs',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                'Scroll ➔',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Classic horizontal scrollable KPI rail
        SizedBox(
          height: 104,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cardsData.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final data = cardsData[index];
              return _MetricCardItem(
                data: data,
                onTap: () {
                  if (onCardTap != null) {
                    onCardTap!(data.title, '${data.value} (${data.subtitle})');
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CardModel {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isWarning;

  const _CardModel({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isWarning = false,
  });
}

class _MetricCardItem extends StatelessWidget {
  final _CardModel data;
  final VoidCallback onTap;

  const _MetricCardItem({
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 142,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: data.isWarning
                ? data.color.withValues(alpha: 0.35)
                : theme.colorScheme.outline.withValues(alpha: 0.15),
            width: data.isWarning ? 1.3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: data.color.withValues(alpha: isDark ? 0.08 : 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: data.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(data.icon, size: 16, color: data.color),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    data.value,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  data.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
