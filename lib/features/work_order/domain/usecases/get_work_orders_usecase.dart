import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/work_order_entity.dart';
import '../repositories/work_order_repository.dart';

class GetWorkOrdersParams extends Equatable {
  final String societyId;
  final WorkOrderStatus? statusFilter;

  const GetWorkOrdersParams({required this.societyId, this.statusFilter});

  @override
  List<Object?> get props => [societyId, statusFilter];
}

class GetWorkOrdersUseCase
    implements UseCase<List<WorkOrderEntity>, GetWorkOrdersParams> {
  final WorkOrderRepository repository;

  GetWorkOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<WorkOrderEntity>>> call(
      GetWorkOrdersParams params) async {
    return await repository.getWorkOrders(
      societyId: params.societyId,
      statusFilter: params.statusFilter,
    );
  }
}
