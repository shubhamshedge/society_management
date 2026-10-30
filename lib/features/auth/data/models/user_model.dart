import '../../domain/entities/user_entity.dart';
import 'society_role_model.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.phoneNumber,
    super.email,
    super.avatarUrl,
    required super.societyMemberships,
    super.activeMembership,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var rawMemberships = json['society_memberships'] as List<dynamic>? ?? [];
    List<SocietyRoleModel> memberships = rawMemberships
        .map((m) => SocietyRoleModel.fromJson(m as Map<String, dynamic>))
        .toList();

    SocietyRoleModel? active;
    if (json['active_membership'] != null) {
      active = SocietyRoleModel.fromJson(json['active_membership'] as Map<String, dynamic>);
    } else if (memberships.isNotEmpty) {
      active = memberships.first;
    }

    return UserModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? json['phone'] ?? '',
      email: json['email'],
      avatarUrl: json['avatar_url'],
      societyMemberships: memberships,
      activeMembership: active,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'email': email,
      'avatar_url': avatarUrl,
      'society_memberships': societyMemberships
          .map((m) => (m is SocietyRoleModel) ? m.toJson() : SocietyRoleModel(
                membershipId: m.membershipId,
                societyId: m.societyId,
                societyName: m.societyName,
                wing: m.wing,
                flatNumber: m.flatNumber,
                role: m.role,
                isApproved: m.isApproved,
              ).toJson())
          .toList(),
      'active_membership': activeMembership != null
          ? ((activeMembership is SocietyRoleModel)
              ? (activeMembership as SocietyRoleModel).toJson()
              : SocietyRoleModel(
                  membershipId: activeMembership!.membershipId,
                  societyId: activeMembership!.societyId,
                  societyName: activeMembership!.societyName,
                  wing: activeMembership!.wing,
                  flatNumber: activeMembership!.flatNumber,
                  role: activeMembership!.role,
                  isApproved: activeMembership!.isApproved,
                ).toJson())
          : null,
    };
  }
}
