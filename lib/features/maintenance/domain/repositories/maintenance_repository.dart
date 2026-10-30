import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/defaulter_member_entity.dart';
import '../entities/maintenance_member_entity.dart';
import '../entities/monthly_maintenance_summary_entity.dart';

abstract class MaintenanceRepository {
  Future<Either<Failure, MonthlyMaintenanceSummaryEntity>> getMonthlySummary({
    required String societyId,
    required int month,
    required int year,
  });

  Future<Either<Failure, List<MaintenanceMemberEntity>>> getMonthlyRecords({
    required String societyId,
    required int month,
    required int year,
    MaintenancePaymentStatus? filterStatus,
  });

  Future<Either<Failure, List<DefaulterMemberEntity>>> getDefaultersList({
    required String societyId,
  });

  Future<Either<Failure, bool>> sendPaymentReminder({
    required String memberId,
    required String phoneNumber,
  });
}
