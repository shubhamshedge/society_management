import 'package:equatable/equatable.dart';
import '../../domain/entities/society_role_entity.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {
  final String? message;

  const AuthLoadingState({this.message});

  @override
  List<Object?> get props => [message];
}

class OtpSentState extends AuthState {
  final String phoneNumber;

  const OtpSentState(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class RoleSelectionRequiredState extends AuthState {
  final UserEntity user;

  const RoleSelectionRequiredState(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthenticatedState extends AuthState {
  final UserEntity user;
  final SocietyRoleEntity activeRole;

  const AuthenticatedState({required this.user, required this.activeRole});

  @override
  List<Object?> get props => [user, activeRole];
}

class UnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
