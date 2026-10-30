import 'package:equatable/equatable.dart';
import '../../domain/entities/work_order_entity.dart';

abstract class WorkOrderState extends Equatable {
  const WorkOrderState();

  @override
  List<Object?> get props => [];
}

class WorkOrderInitialState extends WorkOrderState {}

class WorkOrderLoadingState extends WorkOrderState {}

class WorkOrderLoadedState extends WorkOrderState {
  final List<WorkOrderEntity> allWorkOrders;
  final String? toastMessage;

  const WorkOrderLoadedState({
    required this.allWorkOrders,
    this.toastMessage,
  });

  List<WorkOrderEntity> get pendingApprovalOrders =>
      allWorkOrders.where((w) => w.status == WorkOrderStatus.pendingApproval).toList();

  List<WorkOrderEntity> get activeOrders => allWorkOrders
      .where((w) =>
          w.status == WorkOrderStatus.assigned ||
          w.status == WorkOrderStatus.inProgress)
      .toList();

  List<WorkOrderEntity> get completedOrders =>
      allWorkOrders.where((w) => w.status == WorkOrderStatus.completed).toList();

  WorkOrderLoadedState copyWith({
    List<WorkOrderEntity>? allWorkOrders,
    String? toastMessage,
  }) {
    return WorkOrderLoadedState(
      allWorkOrders: allWorkOrders ?? this.allWorkOrders,
      toastMessage: toastMessage,
    );
  }

  @override
  List<Object?> get props => [allWorkOrders, toastMessage];
}

class WorkOrderErrorState extends WorkOrderState {
  final String message;

  const WorkOrderErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
