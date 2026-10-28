import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarjan_construction/core/theme/app_color_scheme.dart';
import 'package:sarjan_construction/features/auth/domain/models/user.dart';
import 'package:sarjan_construction/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sarjan_construction/features/auth/presentation/bloc/auth_state.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_bloc.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_event.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_state.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/screens/safety_alerts_screen.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/screens/today_activities_screen.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/widgets/attendance_overview_section.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/widgets/quick_actions_section.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/widgets/safety_filter_bar_widget.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/widgets/safety_filter_bottom_sheet.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/widgets/safety_header_widget.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/widgets/summary_cards_grid.dart';

class SafetyDashboardScreen extends StatefulWidget {
  const SafetyDashboardScreen({super.key});

  @override
  State<SafetyDashboardScreen> createState() => _SafetyDashboardScreenState();
}

class _SafetyDashboardScreenState extends State<SafetyDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch initial load if not already loaded
    final bloc = context.read<SafetyDashboardBloc>();
    if (bloc.state.status == SafetyDashboardStatus.initial) {
      bloc.add(const LoadSafetyDashboard());
    }
  }

  void _openFilterSheet(BuildContext context, AuthUser user, SafetyDashboardState state) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafetyFilterBottomSheet(
        user: user,
        currentFilter: state.filter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final user = authState.user ?? AuthUser.forRole(UserRole.safetyOfficer);

            return BlocConsumer<SafetyDashboardBloc, SafetyDashboardState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: AppPalette.danger,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return RefreshIndicator(
                  color: theme.colorScheme.primary,
                  onRefresh: () async {
                    context.read<SafetyDashboardBloc>().add(const RefreshSafetyDashboard());
                  },
                  child: CustomScrollView(
                    slivers: [
                      // Header Section
                      SliverToBoxAdapter(
                        child: SafetyHeaderWidget(
                          user: user,
                          filter: state.filter,
                          onOpenFilter: () => _openFilterSheet(context, user, state),
                        ),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 12)),

                      // Horizontal Quick Filters Bar
                      SliverToBoxAdapter(
                        child: SafetyFilterBarWidget(
                          user: user,
                          filter: state.filter,
                        ),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 16)),

                      // Main Content Area
                      if (state.isLoading && state.metrics == null)
                        const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else ...[
                        // Summary Cards Grid (10 Metrics)
                        if (state.metrics != null)
                          SliverToBoxAdapter(
                            child: SummaryCardsGrid(
                              metrics: state.metrics!,
                              onCardTap: (title, details) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('$title: $details'),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                          ),

                        const SliverToBoxAdapter(child: SizedBox(height: 20)),

                        // Section D: Quick actions
                        SliverToBoxAdapter(
                          child: QuickActionsSection(
                            user: user,
                            filter: state.filter,
                          ),
                        ),

                        const SliverToBoxAdapter(child: SizedBox(height: 24)),

                        // Section A: Attendance overview
                        if (state.attendanceOverview != null)
                          SliverToBoxAdapter(
                            child: AttendanceOverviewSection(
                              attendance: state.attendanceOverview!,
                            ),
                          ),

                        const SliverToBoxAdapter(child: SizedBox(height: 24)),

                        // Section: Site Safety & Daily Operations (Entry to Separate Screens)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Safety & Site Operations',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Safety Alerts Tile -> Pushes SafetyAlertsScreen
                                _SeparateScreenTile(
                                  title: 'Safety Alerts & Incidents',
                                  subtitle: '${state.alerts.length} active site items requiring review',
                                  badgeText: '${state.alerts.length} Active',
                                  badgeColor: AppPalette.danger,
                                  icon: Icons.warning_amber_rounded,
                                  iconColor: AppPalette.danger,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => const SafetyAlertsScreen(),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 10),

                                // Today's Activities Tile -> Pushes TodayActivitiesScreen
                                _SeparateScreenTile(
                                  title: "Today's Schedule & Activities",
                                  subtitle: '${state.activities.length} planned toolbox talks, audits & permits',
                                  badgeText:
                                      '${state.activities.where((a) => a.isCompleted).length}/${state.activities.length} Done',
                                  badgeColor: theme.colorScheme.primary,
                                  icon: Icons.event_note_rounded,
                                  iconColor: theme.colorScheme.primary,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => const TodayActivitiesScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SliverToBoxAdapter(child: SizedBox(height: 32)),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SeparateScreenTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SeparateScreenTile({
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: badgeColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: badgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Arrow
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
