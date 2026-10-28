import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarjan_construction/core/theme/app_color_scheme.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_alert.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_bloc.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_event.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_state.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/widgets/quick_action_dialogs.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/widgets/safety_alerts_section.dart';

class SafetyAlertsScreen extends StatelessWidget {
  const SafetyAlertsScreen({super.key});

  void _handleAlertAction(BuildContext context, SafetyAlert alert) {
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.shield_rounded, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Action Safety Alert', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              alert.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              alert.description,
              style: TextStyle(
                fontSize: 12.5,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      alert.location,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SafetyDashboardBloc>().add(ResolveAlertEvent(alert.id));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Action executed: ${alert.actionLabel} completed.'),
                  backgroundColor: AppPalette.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(alert.actionLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Alerts & Incidents'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert_rounded),
            tooltip: 'Report Hazard',
            onPressed: () {
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
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<SafetyDashboardBloc, SafetyDashboardState>(
          builder: (context, state) {
            if (state.isLoading && state.alerts.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              color: theme.colorScheme.primary,
              onRefresh: () async {
                context.read<SafetyDashboardBloc>().add(const RefreshSafetyDashboard());
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  SafetyAlertsSection(
                    alerts: state.alerts,
                    onAlertAction: (alert) => _handleAlertAction(context, alert),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
