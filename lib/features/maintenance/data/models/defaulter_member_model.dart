import '../../domain/entities/defaulter_member_entity.dart';

class DefaulterMemberModel extends DefaulterMemberEntity {
  const DefaulterMemberModel({
    required super.id,
    required super.unitNumber,
    required super.wing,
    required super.ownerName,
    required super.phoneNumber,
    required super.unpaidMonthsCount,
    required super.unpaidMonths,
    required super.principalDue,
    required super.interestPenalty,
    required super.totalDue,
    super.lastNoticeSentAt,
  });

  factory DefaulterMemberModel.fromJson(Map<String, dynamic> json) {
    return DefaulterMemberModel(
      id: json['id'] ?? '',
      unitNumber: json['unit_number'] ?? '',
      wing: json['wing'] ?? '',
      ownerName: json['owner_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      unpaidMonthsCount: json['unpaid_months_count'] ?? 0,
      unpaidMonths: (json['unpaid_months'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      principalDue: (json['principal_due'] as num?)?.toDouble() ?? 0.0,
      interestPenalty: (json['interest_penalty'] as num?)?.toDouble() ?? 0.0,
      totalDue: (json['total_due'] as num?)?.toDouble() ?? 0.0,
      lastNoticeSentAt: json['last_notice_sent_at'] != null
          ? DateTime.tryParse(json['last_notice_sent_at'])
          : null,
    );
  }
}
