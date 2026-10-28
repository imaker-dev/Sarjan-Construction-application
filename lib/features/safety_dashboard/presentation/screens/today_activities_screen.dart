import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_bloc.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_event.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_state.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/widgets/quick_action_dialogs.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/widgets/today_activities_section.dart';

class TodayActivitiesScreen extends StatelessWidget {
  const TodayActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Schedule & Activities"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task_rounded),
            tooltip: 'Create Task',
            onPressed: () {
              QuickActionDialogs.showActionDialog(
                context: context,
                actionTitle: 'Create Assigned Safety Task',
                icon: Icons.add_task_rounded,
                color: const Color(0xFF0284C7),
                defaultFieldLabel: 'Task Title & Corrective Action',
                defaultFieldHint: 'e.g. Inspect wire ropes on hoist #2',
                secondaryFieldLabel: 'Assignee & Due Time',
                secondaryFieldHint: 'e.g. Rajesh Kumar - Today 4 PM',
                successMessage: 'Safety Task added to today\'s schedule!',
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<SafetyDashboardBloc, SafetyDashboardState>(
          builder: (context, state) {
            if (state.isLoading && state.activities.isEmpty) {
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
                  TodayActivitiesSection(
                    activities: state.activities,
                    onToggleActivity: (act) {
                      context
                          .read<SafetyDashboardBloc>()
                          .add(ToggleActivityEvent(act.id));
                    },
                    onActivityTap: (act) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${act.title} - ${act.status}'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
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
