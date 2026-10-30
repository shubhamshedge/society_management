import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/work_order_entity.dart';
import '../../domain/repositories/work_order_repository.dart';
import '../datasources/work_order_remote_data_source.dart';

class WorkOrderRepositoryImpl implements WorkOrderRepository {
  final WorkOrderRemoteDataSource remoteDataSource;

  WorkOrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<WorkOrderEntity>>> getWorkOrders({
    required String societyId,
    WorkOrderStatus? statusFilter,
  }) async {
    try {
      final list = await remoteDataSource.getWorkOrders(
        societyId: societyId,
        statusFilter: statusFilter,
      );
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkOrderEntity>> approveWorkOrder({
    required String workOrderId,
    required String approverName,
  }) async {
    try {
      final updated = await remoteDataSource.approveWorkOrder(
        workOrderId: workOrderId,
        approverName: approverName,
      );
      return Right(updated);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkOrderEntity>> createWorkOrder({
    required String societyId,
    required WorkOrderEntity workOrder,
  }) async {
    try {
      final created = await remoteDataSource.createWorkOrder(
        societyId: societyId,
        workOrder: workOrder,
      );
      return Right(created);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
