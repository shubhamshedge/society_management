import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_maintenance_dues_data_usecase.dart';

abstract class MaintenanceState extends Equatable {
  const MaintenanceState();

  @override
  List<Object?> get props => [];
}

class MaintenanceInitialState extends MaintenanceState {}

class MaintenanceLoadingState extends MaintenanceState {}

class MaintenanceLoadedState extends MaintenanceState {
  final MaintenanceDuesData data;
  final int selectedMonth;
  final int selectedYear;
  final String? notificationMessage;

  const MaintenanceLoadedState({
    required this.data,
    required this.selectedMonth,
    required this.selectedYear,
    this.notificationMessage,
  });

  MaintenanceLoadedState copyWith({
    MaintenanceDuesData? data,
    int? selectedMonth,
    int? selectedYear,
    String? notificationMessage,
  }) {
    return MaintenanceLoadedState(
      data: data ?? this.data,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      notificationMessage: notificationMessage,
    );
  }

  @override
  List<Object?> get props => [
        data,
        selectedMonth,
        selectedYear,
        notificationMessage,
      ];
}

class MaintenanceErrorState extends MaintenanceState {
  final String message;

  const MaintenanceErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
