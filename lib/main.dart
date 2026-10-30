import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/entities/society_role_entity.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart'; 
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/otp_verification_page.dart';
import 'features/auth/presentation/pages/role_selection_page.dart';
import 'features/home/presentation/pages/admin_dashboard_page.dart';
import 'features/home/presentation/pages/member_dashboard_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const SocietyApp());
}

class SocietyApp extends StatelessWidget {
  const SocietyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
      child: MaterialApp(
        title: 'Society Connect CHS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthFlowCoordinator(),
      ),
    );
  }
}

class AuthFlowCoordinator extends StatelessWidget {
  const AuthFlowCoordinator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitialState) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state is OtpSentState) {
          return OtpVerificationPage(phoneNumber: state.phoneNumber);
        }

        if (state is RoleSelectionRequiredState) {
          return RoleSelectionPage(user: state.user);
        }

        if (state is AuthenticatedState) {
          // Dynamic role routing:
          // Committee Admins (Adhyaksha, Upaadhyaksha, Sachiv, Khajandar) get AdminDashboard
          // General Flat Owners and Tenants get MemberDashboard
          if (state.activeRole.role.isAdmin) {
            return AdminDashboardPage(
              user: state.user,
              activeRole: state.activeRole,
            );
          } else {
            return MemberDashboardPage(
              user: state.user,
              activeRole: state.activeRole,
            );
          }
        }

        // Default: Unauthenticated or AuthErrorState returns to LoginPage
        return const LoginPage();
      },
    );
  }
}
