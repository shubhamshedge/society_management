import 'package:equatable/equatable.dart';

enum MaintenancePaymentStatus { paid, pending, partial }

class MaintenanceMemberEntity extends Equatable {
  final String id;
  final String unitNumber; // e.g. 'A-102'
  final String wing;       // e.g. 'Wing A'
  final String ownerName;
  final String phoneNumber;
  final double billedAmount;
  final double paidAmount;
  final MaintenancePaymentStatus status;
  final DateTime? paymentDate;
  final String? paymentMode;   // UPI, Cheque, Netbanking, Cash
  final String? receiptNumber; // e.g. 'REC-2026-1002'

  const MaintenanceMemberEntity({
    required this.id,
    required this.unitNumber,
    required this.wing,
    required this.ownerName,
    required this.phoneNumber,
    required this.billedAmount,
    this.paidAmount = 0.0,
    required this.status,
    this.paymentDate,
    this.paymentMode,
    this.receiptNumber,
  });

  @override
  List<Object?> get props => [
        id,
        unitNumber,
        wing,
        ownerName,
        phoneNumber,
        billedAmount,
        paidAmount,
        status,
        paymentDate,
        paymentMode,
        receiptNumber,
      ];
}
