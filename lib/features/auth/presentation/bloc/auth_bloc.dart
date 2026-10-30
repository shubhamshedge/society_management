import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/select_society_role_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final SelectSocietyRoleUseCase selectSocietyRoleUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.selectSocietyRoleUseCase,
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitialState()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<SelectSocietyRoleEvent>(_onSelectSocietyRole);
    on<SwitchRoleRequestedEvent>(_onSwitchRoleRequested);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onSwitchRoleRequested(
    SwitchRoleRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthenticatedState) {
      emit(RoleSelectionRequiredState(currentState.user));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState(message: 'Checking session...'));
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => emit(UnauthenticatedState()),
      (user) {
        if (user != null && user.activeMembership != null) {
          emit(AuthenticatedState(
            user: user,
            activeRole: user.activeMembership!,
          ));
        } else if (user != null && user.societyMemberships.isNotEmpty) {
          emit(RoleSelectionRequiredState(user));
        } else {
          emit(UnauthenticatedState());
        }
      },
    );
  }

  Future<void> _onSendOtp(
    SendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState(message: 'Sending verification code...'));
    final result = await sendOtpUseCase(event.phoneNumber);

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (_) => emit(OtpSentState(event.phoneNumber)),
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState(message: 'Verifying code...'));
    final result = await verifyOtpUseCase(
      VerifyOtpParams(phoneNumber: event.phoneNumber, otp: event.otp),
    );

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (user) {
        if (user.societyMemberships.length > 1) {
          // If the user has multiple roles (e.g., Adhyaksha in Soc A & Owner in Soc B),
          // let them choose their active role
          emit(RoleSelectionRequiredState(user));
        } else if (user.societyMemberships.isNotEmpty) {
          final activeRole = user.activeMembership ?? user.societyMemberships.first;
          emit(AuthenticatedState(user: user, activeRole: activeRole));
        } else {
          emit(const AuthErrorState('No approved society memberships found for this number'));
        }
      },
    );
  }

  Future<void> _onSelectSocietyRole(
    SelectSocietyRoleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState(message: 'Setting active profile...'));
    final result = await selectSocietyRoleUseCase(event.role);

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (user) => emit(AuthenticatedState(user: user, activeRole: event.role)),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState(message: 'Logging out...'));
    await logoutUseCase(NoParams());
    emit(UnauthenticatedState());
  }
}
