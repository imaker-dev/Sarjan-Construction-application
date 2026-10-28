import 'package:flutter/material.dart';
import 'package:sarjan_construction/core/theme/app_color_scheme.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/today_activity.dart';

class TodayActivitiesSection extends StatefulWidget {
  final List<TodayActivity> activities;
  final void Function(TodayActivity activity)? onToggleActivity;
  final void Function(TodayActivity activity)? onActivityTap;

  const TodayActivitiesSection({
    super.key,
    required this.activities,
    this.onToggleActivity,
    this.onActivityTap,
  });

  @override
  State<TodayActivitiesSection> createState() => _TodayActivitiesSectionState();
}

class _TodayActivitiesSectionState extends State<TodayActivitiesSection> {
  ActivityCategory? _activeTab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filtered = _activeTab == null
        ? widget.activities
        : widget.activities.where((a) => a.category == _activeTab).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Today's Safety Activities & Schedule",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                '${widget.activities.length} Events',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Categories horizontal filter
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildFilterTab(
                label: 'All (${widget.activities.length})',
                isSelected: _activeTab == null,
                onTap: () => setState(() => _activeTab = null),
              ),
              ...ActivityCategory.values.map((cat) {
                final count = widget.activities.where((a) => a.category == cat).length;
                return _buildFilterTab(
                  label: '${cat.label} ($count)',
                  isSelected: _activeTab == cat,
                  onTap: () => setState(() => _activeTab = cat),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // List of activities
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final act = filtered[index];
            return _ActivityCardItem(
              activity: act,
              isDark: isDark,
              onToggle: () {
                if (widget.onToggleActivity != null) {
                  widget.onToggleActivity!(act);
                }
              },
              onTap: () {
                if (widget.onActivityTap != null) {
                  widget.onActivityTap!(act);
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.secondary
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.outline.withValues(alpha: 0.25),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityCardItem extends StatelessWidget {
  final TodayActivity activity;
  final bool isDark;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const _ActivityCardItem({
    required this.activity,
    required this.isDark,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPermit = activity.category == ActivityCategory.permitExpiry;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPermit
                ? AppPalette.warning.withValues(alpha: 0.4)
                : (activity.isCompleted
                    ? AppPalette.success.withValues(alpha: 0.3)
                    : theme.colorScheme.outline.withValues(alpha: 0.15)),
            width: isPermit ? 1.4 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox or Category Icon
            if (activity.category == ActivityCategory.safetyTask ||
                activity.category == ActivityCategory.inspection)
              Checkbox(
                value: activity.isCompleted,
                onChanged: (_) => onToggle(),
                activeColor: AppPalette.success,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              )
            else
              Container(
                margin: const EdgeInsets.only(top: 2, right: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _activityColor(activity.category).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _activityIcon(activity.category),
                  size: 18,
                  color: _activityColor(activity.category),
                ),
              ),

            // Text Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          activity.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            decoration: activity.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: activity.isCompleted
                                ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _statusColor(activity.status).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          activity.status,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: _statusColor(activity.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    activity.subtitle,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 12,
                        color: isPermit
                            ? AppPalette.warning
                            : theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        activity.time,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isPermit
                              ? AppPalette.warning
                              : theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.place_outlined,
                        size: 12,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          activity.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      if (activity.attendeesCount != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${activity.attendeesCount} pax',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _activityColor(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.inspection:
        return AppPalette.info;
      case ActivityCategory.toolboxTalk:
        return AppPalette.success;
      case ActivityCategory.training:
        return const Color(0xFF8B5CF6);
      case ActivityCategory.permitExpiry:
        return AppPalette.warning;
      case ActivityCategory.safetyTask:
        return Colors.teal;
    }
  }

  IconData _activityIcon(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.inspection:
        return Icons.search_rounded;
      case ActivityCategory.toolboxTalk:
        return Icons.record_voice_over_rounded;
      case ActivityCategory.training:
        return Icons.school_rounded;
      case ActivityCategory.permitExpiry:
        return Icons.timer_outlined;
      case ActivityCategory.safetyTask:
        return Icons.task_alt_rounded;
    }
  }

  Color _statusColor(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('completed') || lower.contains('conducted')) {
      return AppPalette.success;
    }
    if (lower.contains('expir') || lower.contains('due') || lower.contains('action')) {
      return AppPalette.warning;
    }
    if (lower.contains('progress')) {
      return AppPalette.info;
    }
    return Colors.grey;
  }
}
