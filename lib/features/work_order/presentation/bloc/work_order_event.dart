import 'package:equatable/equatable.dart';
import '../../domain/entities/work_order_entity.dart';

abstract class WorkOrderEvent extends Equatable {
  const WorkOrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadWorkOrdersEvent extends WorkOrderEvent {
  final String societyId;
  final WorkOrderStatus? statusFilter;

  const LoadWorkOrdersEvent({
    required this.societyId,
    this.statusFilter,
  });

  @override
  List<Object?> get props => [societyId, statusFilter];
}

class ApproveWorkOrderEvent extends WorkOrderEvent {
  final String workOrderId;
  final String approverName;

  const ApproveWorkOrderEvent({
    required this.workOrderId,
    required this.approverName,
  });

  @override
  List<Object?> get props => [workOrderId, approverName];
}
