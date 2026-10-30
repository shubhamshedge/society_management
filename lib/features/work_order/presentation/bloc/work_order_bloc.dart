import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/approve_work_order_usecase.dart';
import '../../domain/usecases/get_work_orders_usecase.dart';
import 'work_order_event.dart';
import 'work_order_state.dart';

class WorkOrderBloc extends Bloc<WorkOrderEvent, WorkOrderState> {
  final GetWorkOrdersUseCase getWorkOrdersUseCase;
  final ApproveWorkOrderUseCase approveWorkOrderUseCase;

  WorkOrderBloc({
    required this.getWorkOrdersUseCase,
    required this.approveWorkOrderUseCase,
  }) : super(WorkOrderInitialState()) {
    on<LoadWorkOrdersEvent>(_onLoadWorkOrders);
    on<ApproveWorkOrderEvent>(_onApproveWorkOrder);
  }

  Future<void> _onLoadWorkOrders(
    LoadWorkOrdersEvent event,
    Emitter<WorkOrderState> emit,
  ) async {
    emit(WorkOrderLoadingState());

    final result = await getWorkOrdersUseCase(
      GetWorkOrdersParams(
        societyId: event.societyId,
        statusFilter: event.statusFilter,
      ),
    );

    result.fold(
      (failure) => emit(WorkOrderErrorState(failure.message)),
      (list) => emit(WorkOrderLoadedState(allWorkOrders: list)),
    );
  }

  Future<void> _onApproveWorkOrder(
    ApproveWorkOrderEvent event,
    Emitter<WorkOrderState> emit,
  ) async {
    final currentState = state;
    if (currentState is WorkOrderLoadedState) {
      final result = await approveWorkOrderUseCase(
        ApproveWorkOrderParams(
          workOrderId: event.workOrderId,
          approverName: event.approverName,
        ),
      );

      result.fold(
        (failure) => emit(
          currentState.copyWith(
            toastMessage: 'Approval failed: ${failure.message}',
          ),
        ),
        (updatedOrder) {
          final updatedList = currentState.allWorkOrders.map((w) {
            return w.id == updatedOrder.id ? updatedOrder : w;
          }).toList();

          emit(
            currentState.copyWith(
              allWorkOrders: updatedList,
              toastMessage:
                  'Work Order ${updatedOrder.workOrderNumber} approved successfully!',
            ),
          );
        },
      );
    }
  }
}
