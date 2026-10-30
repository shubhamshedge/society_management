import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/work_order_entity.dart';
import '../repositories/work_order_repository.dart';

class ApproveWorkOrderParams extends Equatable {
  final String workOrderId;
  final String approverName;

  const ApproveWorkOrderParams({
    required this.workOrderId,
    required this.approverName,
  });

  @override
  List<Object?> get props => [workOrderId, approverName];
}

class ApproveWorkOrderUseCase
    implements UseCase<WorkOrderEntity, ApproveWorkOrderParams> {
  final WorkOrderRepository repository;

  ApproveWorkOrderUseCase(this.repository);

  @override
  Future<Either<Failure, WorkOrderEntity>> call(
      ApproveWorkOrderParams params) async {
    return await repository.approveWorkOrder(
      workOrderId: params.workOrderId,
      approverName: params.approverName,
    );
  }
}
