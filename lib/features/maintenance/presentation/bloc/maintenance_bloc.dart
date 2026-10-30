import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_maintenance_dues_data_usecase.dart';
import '../../domain/usecases/send_payment_reminder_usecase.dart';
import 'maintenance_event.dart';
import 'maintenance_state.dart';

class MaintenanceBloc extends Bloc<MaintenanceEvent, MaintenanceState> {
  final GetMaintenanceDuesDataUseCase getMaintenanceDuesDataUseCase;
  final SendPaymentReminderUseCase sendPaymentReminderUseCase;

  String _activeSocietyId = '';

  MaintenanceBloc({
    required this.getMaintenanceDuesDataUseCase,
    required this.sendPaymentReminderUseCase,
  }) : super(MaintenanceInitialState()) {
    on<LoadMaintenanceDuesEvent>(_onLoadMaintenanceDues);
    on<ChangeMonthEvent>(_onChangeMonth);
    on<SendReminderEvent>(_onSendReminder);
  }

  Future<void> _onLoadMaintenanceDues(
    LoadMaintenanceDuesEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    _activeSocietyId = event.societyId;
    emit(MaintenanceLoadingState());

    final result = await getMaintenanceDuesDataUseCase(
      GetMaintenanceDuesParams(
        societyId: event.societyId,
        month: event.month,
        year: event.year,
      ),
    );

    result.fold(
      (failure) => emit(MaintenanceErrorState(failure.message)),
      (data) => emit(
        MaintenanceLoadedState(
          data: data,
          selectedMonth: event.month,
          selectedYear: event.year,
        ),
      ),
    );
  }

  Future<void> _onChangeMonth(
    ChangeMonthEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoadingState());

    final result = await getMaintenanceDuesDataUseCase(
      GetMaintenanceDuesParams(
        societyId: _activeSocietyId.isEmpty ? 'soc_01' : _activeSocietyId,
        month: event.month,
        year: event.year,
      ),
    );

    result.fold(
      (failure) => emit(MaintenanceErrorState(failure.message)),
      (data) => emit(
        MaintenanceLoadedState(
          data: data,
          selectedMonth: event.month,
          selectedYear: event.year,
        ),
      ),
    );
  }

  Future<void> _onSendReminder(
    SendReminderEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    final currentState = state;
    if (currentState is MaintenanceLoadedState) {
      final result = await sendPaymentReminderUseCase(
        SendPaymentReminderParams(
          memberId: event.memberId,
          phoneNumber: event.phoneNumber,
        ),
      );

      result.fold(
        (failure) => emit(
          currentState.copyWith(
            notificationMessage: 'Failed to dispatch reminder: ${failure.message}',
          ),
        ),
        (_) => emit(
          currentState.copyWith(
            notificationMessage:
                'Reminder sent to ${event.ownerName} (+91 ${event.phoneNumber})',
          ),
        ),
      );
    }
  }
}
