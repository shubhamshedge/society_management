import 'package:equatable/equatable.dart';
import 'society_role_entity.dart';

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? avatarUrl;
  final List<SocietyRoleEntity> societyMemberships;
  final SocietyRoleEntity? activeMembership;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.avatarUrl,
    required this.societyMemberships,
    this.activeMembership,
  });

  UserEntity copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? avatarUrl,
    List<SocietyRoleEntity>? societyMemberships,
    SocietyRoleEntity? activeMembership,
  }) {
    return UserEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      societyMemberships: societyMemberships ?? this.societyMemberships,
      activeMembership: activeMembership ?? this.activeMembership,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        phoneNumber,
        email,
        avatarUrl,
        societyMemberships,
        activeMembership,
      ];
}
