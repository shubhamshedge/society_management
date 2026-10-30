import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/domain/entities/society_role_entity.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/widgets/role_badge.dart';

class AdminDashboardPage extends StatelessWidget {
  final UserEntity user;
  final SocietyRoleEntity activeRole;

  const AdminDashboardPage({
    super.key,
    required this.user,
    required this.activeRole,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activeRole.societyName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${activeRole.wing} • Unit ${activeRole.flatNumber}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          if (user.societyMemberships.length > 1)
            TextButton.icon(
              icon: const Icon(Icons.swap_horiz_rounded, size: 18),
              label: const Text('Switch'),
              onPressed: () {
                context.read<AuthBloc>().add(SwitchRoleRequestedEvent());
              },
            ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Committee Profile Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoleBadge(role: activeRole.role),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.verified_rounded, size: 14, color: AppColors.accent),
                            SizedBox(width: 4),
                            Text(
                              'Verified Committee',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Administrative Authority: ${activeRole.role.displayName}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Key Metrics Grid
            const Text(
              'Society Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'Maintenance Dues',
                    value: '₹3,45,000',
                    subtitle: '78% Collected',
                    color: AppColors.khajandarColor,
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'Work Orders',
                    value: '4 Active',
                    subtitle: '2 Awaiting Approval',
                    color: AppColors.sachivColor,
                    icon: Icons.handyman_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildMetricCard(
              title: 'Next Development Plan: Solar Grid Project',
              value: 'AGM Voting: 64% YES',
              subtitle: 'Resolution Voting open till 15 Nov 2026',
              color: AppColors.adhyakshaColor,
              icon: Icons.wb_sunny_rounded,
              isFullWidth: true,
            ),

            const SizedBox(height: 28),

            // Operational Module Actions
            const Text(
              'Administrative Workflows',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            _buildActionTile(
              context: context,
              icon: Icons.receipt_long_rounded,
              iconColor: AppColors.khajandarColor,
              title: 'Society Maintenance & Billing',
              description: 'Generate monthly bills, review ledger, verify offline cheque payments',
            ),
            const SizedBox(height: 10),
            _buildActionTile(
              context: context,
              icon: Icons.construction_rounded,
              iconColor: AppColors.sachivColor,
              title: 'Work Done & Repair Orders',
              description: 'Assign vendors, review photographic proofs, sign-off completed tasks',
            ),
            const SizedBox(height: 10),
            _buildActionTile(
              context: context,
              icon: Icons.lightbulb_circle_rounded,
              iconColor: AppColors.adhyakshaColor,
              title: 'Next Development Plan & AGM',
              description: 'Publish project proposals, tenders, track live voting & sinking fund',
            ),
            const SizedBox(height: 10),
            _buildActionTile(
              context: context,
              icon: Icons.people_outline_rounded,
              iconColor: AppColors.primary,
              title: 'Member Directory & Wing Roster',
              description: 'Approve new residents, manage flat registry & tenant documents',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
