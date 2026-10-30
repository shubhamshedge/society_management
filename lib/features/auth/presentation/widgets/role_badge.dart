import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/society_role_entity.dart';

class RoleBadge extends StatelessWidget {
  final SocietyRoleType role;
  final bool isSelected;

  const RoleBadge({
    super.key,
    required this.role,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    IconData iconData;

    switch (role) {
      case SocietyRoleType.adhyaksha:
        badgeColor = AppColors.adhyakshaColor;
        iconData = Icons.military_tech_rounded;
        break;
      case SocietyRoleType.upaadhyaksha:
        badgeColor = AppColors.upaadhyakshaColor;
        iconData = Icons.shield_rounded;
        break;
      case SocietyRoleType.sachiv:
        badgeColor = AppColors.sachivColor;
        iconData = Icons.assignment_turned_in_rounded;
        break;
      case SocietyRoleType.khajandar:
        badgeColor = AppColors.khajandarColor;
        iconData = Icons.account_balance_wallet_rounded;
        break;
      case SocietyRoleType.committeeMember:
        badgeColor = AppColors.accent;
        iconData = Icons.groups_rounded;
        break;
      case SocietyRoleType.owner:
        badgeColor = AppColors.memberColor;
        iconData = Icons.home_rounded;
        break;
      case SocietyRoleType.tenant:
        badgeColor = AppColors.textSecondary;
        iconData = Icons.key_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? badgeColor : badgeColor.withValues(alpha: 0.3),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 14, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            role.displayName,
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
