import 'package:equatable/equatable.dart';

class SafetyFilterState extends Equatable {
  final String project;
  final String site;
  final String department;
  final String contractor;
  final String dateRange;
  final String status;
  final String severity;

  const SafetyFilterState({
    this.project = 'Sarjan Sky Tower',
    this.site = 'Tower A - High Rise Zone',
    this.department = 'All',
    this.contractor = 'All',
    this.dateRange = 'Today',
    this.status = 'All',
    this.severity = 'All',
  });

  bool get hasActiveCustomFilters =>
      department != 'All' ||
      contractor != 'All' ||
      dateRange != 'Today' ||
      status != 'All' ||
      severity != 'All';

  int get activeFiltersCount {
    int count = 0;
    if (department != 'All') count++;
    if (contractor != 'All') count++;
    if (dateRange != 'Today') count++;
    if (status != 'All') count++;
    if (severity != 'All') count++;
    return count;
  }

  SafetyFilterState copyWith({
    String? project,
    String? site,
    String? department,
    String? contractor,
    String? dateRange,
    String? status,
    String? severity,
  }) {
    return SafetyFilterState(
      project: project ?? this.project,
      site: site ?? this.site,
      department: department ?? this.department,
      contractor: contractor ?? this.contractor,
      dateRange: dateRange ?? this.dateRange,
      status: status ?? this.status,
      severity: severity ?? this.severity,
    );
  }

  @override
  List<Object?> get props => [
        project,
        site,
        department,
        contractor,
        dateRange,
        status,
        severity,
      ];
}
