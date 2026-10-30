import 'package:equatable/equatable.dart';

enum SocietyRoleType {
  adhyaksha,
  upaadhyaksha,
  sachiv,
  khajandar,
  committeeMember,
  owner,
  tenant,
}

extension SocietyRoleTypeExtension on SocietyRoleType {
  String get displayName {
    switch (this) {
      case SocietyRoleType.adhyaksha:
        return 'Adhyaksha (President)';
      case SocietyRoleType.upaadhyaksha:
        return 'Upaadhyaksha (Vice President)';
      case SocietyRoleType.sachiv:
        return 'Sachiv (Secretary)';
      case SocietyRoleType.khajandar:
        return 'Khajandar (Treasurer)';
      case SocietyRoleType.committeeMember:
        return 'Committee Member';
      case SocietyRoleType.owner:
        return 'Flat Owner';
      case SocietyRoleType.tenant:
        return 'Tenant Resident';
    }
  }

  bool get isAdmin {
    return this == SocietyRoleType.adhyaksha ||
        this == SocietyRoleType.upaadhyaksha ||
        this == SocietyRoleType.sachiv ||
        this == SocietyRoleType.khajandar ||
        this == SocietyRoleType.committeeMember;
  }
}

class SocietyRoleEntity extends Equatable {
  final String membershipId;
  final String societyId;
  final String societyName;
  final String wing;
  final String flatNumber;
  final SocietyRoleType role;
  final bool isApproved;

  const SocietyRoleEntity({
    required this.membershipId,
    required this.societyId,
    required this.societyName,
    required this.wing,
    required this.flatNumber,
    required this.role,
    this.isApproved = true,
  });

  @override
  List<Object?> get props => [
        membershipId,
        societyId,
        societyName,
        wing,
        flatNumber,
        role,
        isApproved,
      ];
}
