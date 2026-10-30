import 'package:equatable/equatable.dart';

class MonthlyMaintenanceSummaryEntity extends Equatable {
  final int month; // 1-12
  final int year;  // e.g. 2026
  final int totalUnits;
  final int paidUnitsCount;
  final int pendingUnitsCount;
  final double totalBilledAmount;
  final double totalCollectedAmount;
  final double totalPendingAmount;
  final int criticalDefaultersCount; // unpaid for >= 3 months

  const MonthlyMaintenanceSummaryEntity({
    required this.month,
    required this.year,
    required this.totalUnits,
    required this.paidUnitsCount,
    required this.pendingUnitsCount,
    required this.totalBilledAmount,
    required this.totalCollectedAmount,
    required this.totalPendingAmount,
    required this.criticalDefaultersCount,
  });

  double get collectionPercentage {
    if (totalBilledAmount == 0) return 0.0;
    return (totalCollectedAmount / totalBilledAmount) * 100;
  }

  @override
  List<Object?> get props => [
        month,
        year,
        totalUnits,
        paidUnitsCount,
        pendingUnitsCount,
        totalBilledAmount,
        totalCollectedAmount,
        totalPendingAmount,
        criticalDefaultersCount,
      ];
}
