import '../../domain/entities/society_role_entity.dart';

class SocietyRoleModel extends SocietyRoleEntity {
  const SocietyRoleModel({
    required super.membershipId,
    required super.societyId,
    required super.societyName,
    required super.wing,
    required super.flatNumber,
    required super.role,
    super.isApproved = true,
  });

  factory SocietyRoleModel.fromJson(Map<String, dynamic> json) {
    return SocietyRoleModel(
      membershipId: json['membership_id'] ?? json['id'] ?? '',
      societyId: json['society_id'] ?? '',
      societyName: json['society_name'] ?? 'Society',
      wing: json['wing'] ?? '',
      flatNumber: json['flat_number'] ?? '',
      role: _parseRole(json['role']),
      isApproved: json['is_approved'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'membership_id': membershipId,
      'society_id': societyId,
      'society_name': societyName,
      'wing': wing,
      'flat_number': flatNumber,
      'role': role.name.toUpperCase(),
      'is_approved': isApproved,
    };
  }

  static SocietyRoleType _parseRole(dynamic role) {
    if (role == null) return SocietyRoleType.owner;
    final r = role.toString().toUpperCase();
    if (r.contains('ADHYAKSHA') && !r.contains('UPA')) return SocietyRoleType.adhyaksha;
    if (r.contains('UPA') || r.contains('VICE')) return SocietyRoleType.upaadhyaksha;
    if (r.contains('SACHIV') || r.contains('SECRETARY')) return SocietyRoleType.sachiv;
    if (r.contains('KHAJANDAR') || r.contains('TREASURER')) return SocietyRoleType.khajandar;
    if (r.contains('COMMITTEE')) return SocietyRoleType.committeeMember;
    if (r.contains('TENANT')) return SocietyRoleType.tenant;
    return SocietyRoleType.owner;
  }
}
