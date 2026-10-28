import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarjan_construction/core/theme/app_color_scheme.dart';
import 'package:sarjan_construction/features/auth/domain/models/user.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_filter.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_bloc.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_event.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/widgets/safety_filter_bottom_sheet.dart';

class SafetyFilterBarWidget extends StatelessWidget {
  final AuthUser user;
  final SafetyFilterState filter;

  const SafetyFilterBarWidget({
    super.key,
    required this.user,
    required this.filter,
  });

  void _openFilterModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafetyFilterBottomSheet(
        user: user,
        currentFilter: filter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeCount = filter.activeFiltersCount;

    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Filter Button with Badge
          InkWell(
            onTap: () => _openFilterModal(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: activeCount > 0
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: activeCount > 0
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 15,
                    color: activeCount > 0
                        ? Colors.white
                        : theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: activeCount > 0
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (activeCount > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$activeCount',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Date Range Chip
          _FilterChipItem(
            label: filter.dateRange,
            icon: Icons.calendar_today_rounded,
            isActive: filter.dateRange != 'Today',
            onTap: () => _openFilterModal(context),
          ),

          const SizedBox(width: 8),

          // Severity Chip
          if (filter.severity != 'All') ...[
            _FilterChipItem(
              label: 'Severity: ${filter.severity}',
              icon: Icons.warning_amber_rounded,
              isActive: true,
              color: AppPalette.danger,
              onClear: () {
                context.read<SafetyDashboardBloc>().add(
                      SafetyFilterUpdated(filter.copyWith(severity: 'All')),
                    );
              },
              onTap: () => _openFilterModal(context),
            ),
            const SizedBox(width: 8),
          ],

          // Department Chip
          if (filter.department != 'All') ...[
            _FilterChipItem(
              label: filter.department,
              icon: Icons.groups_rounded,
              isActive: true,
              onClear: () {
                context.read<SafetyDashboardBloc>().add(
                      SafetyFilterUpdated(filter.copyWith(department: 'All')),
                    );
              },
              onTap: () => _openFilterModal(context),
            ),
            const SizedBox(width: 8),
          ],

          // Contractor Chip
          if (filter.contractor != 'All') ...[
            _FilterChipItem(
              label: filter.contractor,
              icon: Icons.handshake_rounded,
              isActive: true,
              onClear: () {
                context.read<SafetyDashboardBloc>().add(
                      SafetyFilterUpdated(filter.copyWith(contractor: 'All')),
                    );
              },
              onTap: () => _openFilterModal(context),
            ),
            const SizedBox(width: 8),
          ],

          // Status Chip
          if (filter.status != 'All') ...[
            _FilterChipItem(
              label: 'Status: ${filter.status}',
              icon: Icons.check_circle_outline_rounded,
              isActive: true,
              onClear: () {
                context.read<SafetyDashboardBloc>().add(
                      SafetyFilterUpdated(filter.copyWith(status: 'All')),
                    );
              },
              onTap: () => _openFilterModal(context),
            ),
            const SizedBox(width: 8),
          ],

          // Clear All Filters button if any custom filters are applied
          if (filter.hasActiveCustomFilters)
            ActionChip(
              avatar: const Icon(Icons.close_rounded, size: 14),
              label: const Text('Clear', style: TextStyle(fontSize: 11)),
              onPressed: () {
                context.read<SafetyDashboardBloc>().add(
                      ResetSafetyFilters(
                        defaultProject: filter.project,
                        defaultSite: filter.site,
                      ),
                    );
              },
            ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final Color? color;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _FilterChipItem({
    required this.label,
    required this.icon,
    required this.isActive,
    this.color,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? effectiveColor.withValues(alpha: 0.12)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? effectiveColor
                : theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isActive ? effectiveColor : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? effectiveColor : theme.colorScheme.onSurface,
              ),
            ),
            if (onClear != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: effectiveColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
