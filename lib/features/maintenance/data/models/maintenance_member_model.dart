import '../../domain/entities/maintenance_member_entity.dart';

class MaintenanceMemberModel extends MaintenanceMemberEntity {
  const MaintenanceMemberModel({
    required super.id,
    required super.unitNumber,
    required super.wing,
    required super.ownerName,
    required super.phoneNumber,
    required super.billedAmount,
    super.paidAmount = 0.0,
    required super.status,
    super.paymentDate,
    super.paymentMode,
    super.receiptNumber,
  });

  factory MaintenanceMemberModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceMemberModel(
      id: json['id'] ?? '',
      unitNumber: json['unit_number'] ?? '',
      wing: json['wing'] ?? '',
      ownerName: json['owner_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      billedAmount: (json['billed_amount'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0.0,
      status: _parseStatus(json['status']),
      paymentDate: json['payment_date'] != null
          ? DateTime.tryParse(json['payment_date'])
          : null,
      paymentMode: json['payment_mode'],
      receiptNumber: json['receipt_number'],
    );
  }

  static MaintenancePaymentStatus _parseStatus(dynamic status) {
    final s = status?.toString().toLowerCase() ?? '';
    if (s == 'paid') return MaintenancePaymentStatus.paid;
    if (s == 'partial') return MaintenancePaymentStatus.partial;
    return MaintenancePaymentStatus.pending;
  }
}
