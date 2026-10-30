import 'package:equatable/equatable.dart';

abstract class MaintenanceEvent extends Equatable {
  const MaintenanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadMaintenanceDuesEvent extends MaintenanceEvent {
  final String societyId;
  final int month;
  final int year;

  const LoadMaintenanceDuesEvent({
    required this.societyId,
    required this.month,
    required this.year,
  });

  @override
  List<Object?> get props => [societyId, month, year];
}

class ChangeMonthEvent extends MaintenanceEvent {
  final int month;
  final int year;

  const ChangeMonthEvent({
    required this.month,
    required this.year,
  });

  @override
  List<Object?> get props => [month, year];
}

class SendReminderEvent extends MaintenanceEvent {
  final String memberId;
  final String phoneNumber;
  final String ownerName;

  const SendReminderEvent({
    required this.memberId,
    required this.phoneNumber,
    required this.ownerName,
  });

  @override
  List<Object?> get props => [memberId, phoneNumber, ownerName];
}
