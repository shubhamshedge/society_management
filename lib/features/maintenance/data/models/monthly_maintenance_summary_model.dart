import '../../domain/entities/monthly_maintenance_summary_entity.dart';

class MonthlyMaintenanceSummaryModel extends MonthlyMaintenanceSummaryEntity {
  const MonthlyMaintenanceSummaryModel({
    required super.month,
    required super.year,
    required super.totalUnits,
    required super.paidUnitsCount,
    required super.pendingUnitsCount,
    required super.totalBilledAmount,
    required super.totalCollectedAmount,
    required super.totalPendingAmount,
    required super.criticalDefaultersCount,
  });

  factory MonthlyMaintenanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return MonthlyMaintenanceSummaryModel(
      month: json['month'] ?? 10,
      year: json['year'] ?? 2026,
      totalUnits: json['total_units'] ?? 0,
      paidUnitsCount: json['paid_units_count'] ?? 0,
      pendingUnitsCount: json['pending_units_count'] ?? 0,
      totalBilledAmount: (json['total_billed_amount'] as num?)?.toDouble() ?? 0.0,
      totalCollectedAmount:
          (json['total_collected_amount'] as num?)?.toDouble() ?? 0.0,
      totalPendingAmount:
          (json['total_pending_amount'] as num?)?.toDouble() ?? 0.0,
      criticalDefaultersCount: json['critical_defaulters_count'] ?? 0,
    );
  }
}
