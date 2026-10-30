import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/defaulter_member_entity.dart';
import '../entities/maintenance_member_entity.dart';
import '../entities/monthly_maintenance_summary_entity.dart';
import '../repositories/maintenance_repository.dart';

class MaintenanceDuesData extends Equatable {
  final MonthlyMaintenanceSummaryEntity summary;
  final List<MaintenanceMemberEntity> paidMembers;
  final List<MaintenanceMemberEntity> remainingMembers;
  final List<DefaulterMemberEntity> defaulters;

  const MaintenanceDuesData({
    required this.summary,
    required this.paidMembers,
    required this.remainingMembers,
    required this.defaulters,
  });

  @override
  List<Object?> get props => [summary, paidMembers, remainingMembers, defaulters];
}

class GetMaintenanceDuesParams extends Equatable {
  final String societyId;
  final int month;
  final int year;

  const GetMaintenanceDuesParams({
    required this.societyId,
    required this.month,
    required this.year,
  });

  @override
  List<Object?> get props => [societyId, month, year];
}

class GetMaintenanceDuesDataUseCase
    implements UseCase<MaintenanceDuesData, GetMaintenanceDuesParams> {
  final MaintenanceRepository repository;

  GetMaintenanceDuesDataUseCase(this.repository);

  @override
  Future<Either<Failure, MaintenanceDuesData>> call(
      GetMaintenanceDuesParams params) async {
    final summaryResult = await repository.getMonthlySummary(
      societyId: params.societyId,
      month: params.month,
      year: params.year,
    );

    if (summaryResult.isLeft()) {
      return Left((summaryResult as Left<Failure, MonthlyMaintenanceSummaryEntity>).value);
    }

    final recordsResult = await repository.getMonthlyRecords(
      societyId: params.societyId,
      month: params.month,
      year: params.year,
    );

    if (recordsResult.isLeft()) {
      return Left((recordsResult as Left<Failure, List<MaintenanceMemberEntity>>).value);
    }

    final defaultersResult = await repository.getDefaultersList(
      societyId: params.societyId,
    );

    if (defaultersResult.isLeft()) {
      return Left((defaultersResult as Left<Failure, List<DefaulterMemberEntity>>).value);
    }

    final summary = summaryResult.getOrElse(() => throw Exception());
    final allRecords = recordsResult.getOrElse(() => []);
    final defaulters = defaultersResult.getOrElse(() => []);

    final paidMembers = allRecords
        .where((m) => m.status == MaintenancePaymentStatus.paid)
        .toList();

    final remainingMembers = allRecords
        .where((m) => m.status != MaintenancePaymentStatus.paid)
        .toList();

    return Right(
      MaintenanceDuesData(
        summary: summary,
        paidMembers: paidMembers,
        remainingMembers: remainingMembers,
        defaulters: defaulters,
      ),
    );
  }
}
