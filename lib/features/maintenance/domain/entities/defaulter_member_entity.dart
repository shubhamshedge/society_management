import 'package:equatable/equatable.dart';

class DefaulterMemberEntity extends Equatable {
  final String id;
  final String unitNumber; // e.g. 'A-304'
  final String wing;       // e.g. 'Wing A'
  final String ownerName;
  final String phoneNumber;
  final int unpaidMonthsCount; // >= 3 months
  final List<String> unpaidMonths; // ['Aug 2026', 'Sep 2026', 'Oct 2026']
  final double principalDue;
  final double interestPenalty;
  final double totalDue;
  final DateTime? lastNoticeSentAt;

  const DefaulterMemberEntity({
    required this.id,
    required this.unitNumber,
    required this.wing,
    required this.ownerName,
    required this.phoneNumber,
    required this.unpaidMonthsCount,
    required this.unpaidMonths,
    required this.principalDue,
    required this.interestPenalty,
    required this.totalDue,
    this.lastNoticeSentAt,
  });

  @override
  List<Object?> get props => [
        id,
        unitNumber,
        wing,
        ownerName,
        phoneNumber,
        unpaidMonthsCount,
        unpaidMonths,
        principalDue,
        interestPenalty,
        totalDue,
        lastNoticeSentAt,
      ];
}
