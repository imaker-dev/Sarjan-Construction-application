import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarjan_construction/core/theme/app_color_scheme.dart';
import 'package:sarjan_construction/core/widgets/app_button.dart';
import 'package:sarjan_construction/features/auth/domain/models/user.dart';
import 'package:sarjan_construction/features/safety_dashboard/domain/models/safety_filter.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_bloc.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_event.dart';

class SafetyFilterBottomSheet extends StatefulWidget {
  final AuthUser user;
  final SafetyFilterState currentFilter;

  const SafetyFilterBottomSheet({
    super.key,
    required this.user,
    required this.currentFilter,
  });

  @override
  State<SafetyFilterBottomSheet> createState() => _SafetyFilterBottomSheetState();
}

class _SafetyFilterBottomSheetState extends State<SafetyFilterBottomSheet> {
  late String _selectedProject;
  late String _selectedSite;
  late String _selectedDepartment;
  late String _selectedContractor;
  late String _selectedDateRange;
  late String _selectedStatus;
  late String _selectedSeverity;

  final List<String> _departments = const [
    'All',
    'Civil & RCC',
    'Rebar & Shuttering',
    'Electrical & MEP',
    'Scaffolding & Rigging',
    'Heavy Machinery',
  ];

  final List<String> _contractors = const [
    'All',
    'Apex Infra Corp',
    'BuildPro Contracting',
    'Vertex MEP',
    'L&T Civil Infra',
  ];

  final List<String> _dateRanges = const [
    'Today',
    'Yesterday',
    'Last 7 Days',
    'Month to Date',
  ];

  final List<String> _statuses = const [
    'All',
    'Open',
    'In Progress',
    'Overdue',
    'Closed',
  ];

  final List<String> _severities = const [
    'All',
    'Critical',
    'High',
    'Medium',
    'Low',
  ];

  @override
  void initState() {
    super.initState();
    _selectedProject = widget.currentFilter.project;
    _selectedSite = widget.currentFilter.site;
    _selectedDepartment = widget.currentFilter.department;
    _selectedContractor = widget.currentFilter.contractor;
    _selectedDateRange = widget.currentFilter.dateRange;
    _selectedStatus = widget.currentFilter.status;
    _selectedSeverity = widget.currentFilter.severity;

    // Ensure initial project/site are authorized
    final authorizedProjects = widget.user.authorizedProjects;
    if (authorizedProjects.isNotEmpty && !authorizedProjects.contains(_selectedProject)) {
      _selectedProject = authorizedProjects.first;
      final sites = widget.user.sitesForProject(_selectedProject);
      _selectedSite = sites.isNotEmpty ? sites.first : 'Main Site';
    }
  }

  void _onProjectChanged(String? newProject) {
    if (newProject == null) return;
    setState(() {
      _selectedProject = newProject;
      final availableSites = widget.user.sitesForProject(newProject);
      _selectedSite = availableSites.isNotEmpty ? availableSites.first : 'Main Site';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final authorizedProjects = widget.user.authorizedProjects;
    final availableSites = widget.user.sitesForProject(_selectedProject);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.filter_list_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filter Safety Dashboard',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Scoped to authorized site credentials',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final defaultProj = authorizedProjects.isNotEmpty
                        ? authorizedProjects.first
                        : 'Sarjan Sky Tower';
                    final defaultS = widget.user.sitesForProject(defaultProj).isNotEmpty
                        ? widget.user.sitesForProject(defaultProj).first
                        : 'Main Site';

                    context.read<SafetyDashboardBloc>().add(
                          ResetSafetyFilters(
                            defaultProject: defaultProj,
                            defaultSite: defaultS,
                          ),
                        );
                    Navigator.pop(context);
                  },
                  child: const Text('Reset All'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Filter content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // 1. Project (Authorized scope only)
                _buildSectionTitle(
                  context,
                  title: 'Project Scope',
                  subtitle: 'Authorized projects for your user role',
                  icon: Icons.business_rounded,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.25),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: authorizedProjects.contains(_selectedProject)
                          ? _selectedProject
                          : authorizedProjects.firstOrNull,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                      items: authorizedProjects.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text(
                            p,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        );
                      }).toList(),
                      onChanged: _onProjectChanged,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 2. Site Scope (Authorized sites for chosen project)
                _buildSectionTitle(
                  context,
                  title: 'Site Zone',
                  subtitle: 'Zones under $_selectedProject',
                  icon: Icons.place_rounded,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.25),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: availableSites.contains(_selectedSite)
                          ? _selectedSite
                          : (availableSites.isNotEmpty ? availableSites.first : null),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                      items: availableSites.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(
                            s,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedSite = val);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 3. Department
                _buildSectionTitle(
                  context,
                  title: 'Department',
                  subtitle: 'Filter metrics by work division',
                  icon: Icons.groups_rounded,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _departments.map((dept) {
                    final isSelected = _selectedDepartment == dept;
                    return ChoiceChip(
                      label: Text(dept),
                      selected: isSelected,
                      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                      side: BorderSide(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedDepartment = dept);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // 4. Contractor
                _buildSectionTitle(
                  context,
                  title: 'Contractor / Agency',
                  subtitle: 'Subcontractor agency filtering',
                  icon: Icons.handshake_rounded,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _contractors.map((c) {
                    final isSelected = _selectedContractor == c;
                    return ChoiceChip(
                      label: Text(c),
                      selected: isSelected,
                      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                      side: BorderSide(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedContractor = c);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // 5. Date Range
                _buildSectionTitle(
                  context,
                  title: 'Date Range',
                  subtitle: 'Timeframe for incidents & activities',
                  icon: Icons.date_range_rounded,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _dateRanges.map((dr) {
                    final isSelected = _selectedDateRange == dr;
                    return ChoiceChip(
                      label: Text(dr),
                      selected: isSelected,
                      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                      side: BorderSide(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedDateRange = dr);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // 6. Severity
                _buildSectionTitle(
                  context,
                  title: 'Severity Level',
                  subtitle: 'Alert and hazard severity threshold',
                  icon: Icons.warning_amber_rounded,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _severities.map((sev) {
                    final isSelected = _selectedSeverity == sev;
                    Color color = theme.colorScheme.primary;
                    if (sev == 'Critical') color = AppPalette.danger;
                    if (sev == 'High') color = Colors.deepOrange;
                    if (sev == 'Medium') color = AppPalette.warning;
                    if (sev == 'Low') color = AppPalette.success;

                    return FilterChip(
                      label: Text(sev),
                      selected: isSelected,
                      selectedColor: color.withValues(alpha: 0.2),
                      side: BorderSide(
                        color: isSelected
                            ? color
                            : theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedSeverity = sev);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // 7. Status
                _buildSectionTitle(
                  context,
                  title: 'Action Status',
                  subtitle: 'Filter by item completion state',
                  icon: Icons.check_circle_outline_rounded,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _statuses.map((st) {
                    final isSelected = _selectedStatus == st;
                    return ChoiceChip(
                      label: Text(st),
                      selected: isSelected,
                      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                      side: BorderSide(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedStatus = st);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Bottom Action
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.15),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Cancel',
                    isOutlined: true,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: AppButton(
                    text: 'Apply Filters',
                    icon: Icons.check_rounded,
                    onPressed: () {
                      final updated = widget.currentFilter.copyWith(
                        project: _selectedProject,
                        site: _selectedSite,
                        department: _selectedDepartment,
                        contractor: _selectedContractor,
                        dateRange: _selectedDateRange,
                        status: _selectedStatus,
                        severity: _selectedSeverity,
                      );
                      context
                          .read<SafetyDashboardBloc>()
                          .add(SafetyFilterUpdated(updated));
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
