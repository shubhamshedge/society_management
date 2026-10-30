import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/defaulter_member_entity.dart';
import '../../domain/entities/maintenance_member_entity.dart';
import '../../domain/entities/monthly_maintenance_summary_entity.dart';
import '../../domain/repositories/maintenance_repository.dart';
import '../datasources/maintenance_remote_data_source.dart';

class MaintenanceRepositoryImpl implements MaintenanceRepository {
  final MaintenanceRemoteDataSource remoteDataSource;

  MaintenanceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MonthlyMaintenanceSummaryEntity>> getMonthlySummary({
    required String societyId,
    required int month,
    required int year,
  }) async {
    try {
      final summary = await remoteDataSource.getMonthlySummary(
        societyId: societyId,
        month: month,
        year: year,
      );
      return Right(summary);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MaintenanceMemberEntity>>> getMonthlyRecords({
    required String societyId,
    required int month,
    required int year,
    MaintenancePaymentStatus? filterStatus,
  }) async {
    try {
      final records = await remoteDataSource.getMonthlyRecords(
        societyId: societyId,
        month: month,
        year: year,
      );

      if (filterStatus != null) {
        return Right(records.where((r) => r.status == filterStatus).toList());
      }
      return Right(records);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DefaulterMemberEntity>>> getDefaultersList({
    required String societyId,
  }) async {
    try {
      final defaulters = await remoteDataSource.getDefaultersList(
        societyId: societyId,
      );
      return Right(defaulters);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendPaymentReminder({
    required String memberId,
    required String phoneNumber,
  }) async {
    try {
      final result = await remoteDataSource.sendPaymentReminder(
        memberId: memberId,
        phoneNumber: phoneNumber,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
