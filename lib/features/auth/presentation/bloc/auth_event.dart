import 'package:equatable/equatable.dart';
import '../../domain/entities/society_role_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;

  const SendOtpEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String otp;

  const VerifyOtpEvent({required this.phoneNumber, required this.otp});

  @override
  List<Object?> get props => [phoneNumber, otp];
}

class SelectSocietyRoleEvent extends AuthEvent {
  final SocietyRoleEntity role;

  const SelectSocietyRoleEvent(this.role);

  @override
  List<Object?> get props => [role];
}

class SwitchRoleRequestedEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
