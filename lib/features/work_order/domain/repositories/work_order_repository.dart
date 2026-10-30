import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/work_order_entity.dart';

abstract class WorkOrderRepository {
  Future<Either<Failure, List<WorkOrderEntity>>> getWorkOrders({
    required String societyId,
    WorkOrderStatus? statusFilter,
  });

  Future<Either<Failure, WorkOrderEntity>> approveWorkOrder({
    required String workOrderId,
    required String approverName,
  });

  Future<Either<Failure, WorkOrderEntity>> createWorkOrder({
    required String societyId,
    required WorkOrderEntity workOrder,
  });
}
