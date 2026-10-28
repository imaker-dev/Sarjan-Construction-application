import 'package:equatable/equatable.dart';

class SafetyMetrics extends Equatable {
  final int totalLabour;
  final int labourPresent;
  final int labourAbsent;
  final int pendingOnboarding;
  final int safetyIncidents;
  final int openHazards;
  final int pendingInspections;
  final double ppeCompliance;
  final int expiredDocuments;
  final int pendingActions;

  const SafetyMetrics({
    required this.totalLabour,
    required this.labourPresent,
    required this.labourAbsent,
    required this.pendingOnboarding,
    required this.safetyIncidents,
    required this.openHazards,
    required this.pendingInspections,
    required this.ppeCompliance,
    required this.expiredDocuments,
    required this.pendingActions,
  });

  double get attendancePercentage =>
      totalLabour > 0 ? (labourPresent / totalLabour) * 100 : 0.0;

  @override
  List<Object?> get props => [
        totalLabour,
        labourPresent,
        labourAbsent,
        pendingOnboarding,
        safetyIncidents,
        openHazards,
        pendingInspections,
        ppeCompliance,
        expiredDocuments,
        pendingActions,
      ];
}
