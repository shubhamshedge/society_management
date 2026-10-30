import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart' as di;
import '../../../auth/domain/entities/society_role_entity.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/widgets/role_badge.dart';
import '../../../maintenance/presentation/bloc/maintenance_bloc.dart';
import '../../../maintenance/presentation/pages/maintenance_dues_page.dart';
import '../../../notice/presentation/bloc/notice_bloc.dart';
import '../../../notice/presentation/pages/publish_notice_page.dart';
import '../../../work_order/presentation/bloc/work_order_bloc.dart';
import '../../../work_order/presentation/pages/work_order_list_page.dart';

class AdminDashboardPage extends StatelessWidget {
  final UserEntity user;
  final SocietyRoleEntity activeRole;

  const AdminDashboardPage({
    super.key,
    required this.user,
    required this.activeRole,
  });

  void _openMaintenancePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => di.sl<MaintenanceBloc>(),
          child: MaintenanceDuesPage(
            societyId: activeRole.societyId,
            societyName: activeRole.societyName,
          ),
        ),
      ),
    );
  }

  void _openWorkOrdersPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => di.sl<WorkOrderBloc>(),
          child: WorkOrderListPage(
            societyId: activeRole.societyId,
            societyName: activeRole.societyName,
            userRoleName: '${activeRole.role.displayName} (${user.fullName})',
          ),
        ),
      ),
    );
  }

  void _openPublishNoticePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => di.sl<NoticeBloc>(),
          child: PublishNoticePage(
            societyId: activeRole.societyId,
            societyName: activeRole.societyName,
            chairmanName: user.fullName,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isChairman = activeRole.role == SocietyRoleType.adhyaksha;

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

            // --- CHAIRMAN ONLY EXCLUSIVE NOTICE BROADCAST SECTION ---
            if (isChairman) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6D28D9), AppColors.adhyakshaColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.adhyakshaColor.withValues(alpha: 0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.military_tech_rounded, size: 14, color: AppColors.accent),
                              SizedBox(width: 4),
                              Text(
                                'Chairman Exclusive Power',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.campaign_rounded, color: Colors.white, size: 26),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Broadcast Notice to Every Owner',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Draft and publish circulars, AGM announcements & urgent alerts directly to all 40 flat owners via WhatsApp & mobile push notification.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.adhyakshaColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.send_rounded, size: 18),
                        label: const Text(
                          'Add Notice & Send to Owners (सूचना भेजें)',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                        onPressed: () => _openPublishNoticePage(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],

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
                    subtitle: '78% Collected • View Details',
                    color: AppColors.khajandarColor,
                    icon: Icons.account_balance_wallet_rounded,
                    onTap: () => _openMaintenancePage(context),
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
                    onTap: () => _openWorkOrdersPage(context),
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
              description: 'View Paid & Remaining members, Defaulter list (3+ mos), Cheque approvals',
              onTap: () => _openMaintenancePage(context),
            ),
            const SizedBox(height: 10),
            _buildActionTile(
              context: context,
              icon: Icons.construction_rounded,
              iconColor: AppColors.sachivColor,
              title: 'Work Orders & Repairs (कार्यादेश)',
              description: 'Assign vendors, review photographic proofs, approve repair orders',
              onTap: () => _openWorkOrdersPage(context),
            ),
            if (isChairman) ...[
              const SizedBox(height: 10),
              _buildActionTile(
                context: context,
                icon: Icons.campaign_rounded,
                iconColor: AppColors.adhyakshaColor,
                title: 'Official Notice Board (सूचना फलक)',
                description: 'Issue official circulars & broadcast to all flat owners',
                onTap: () => _openPublishNoticePage(context),
              ),
            ],
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
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
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
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
      ),
    );
  }
}
