import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/models/user.dart';
import 'package:flutter_application_5/services/auth_service.dart';

class RoleSwitcherBanner extends StatelessWidget {
  const RoleSwitcherBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final currentRole = auth.currentUser?.role ?? UserRole.customer;

    return Container(
      color: const Color(0xFF222831),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: SafeArea(
        bottom: false,
        top: false,
        child: Row(
          children: [
            const Icon(Icons.swap_horiz, color: Colors.white70, size: 18),
            const SizedBox(width: 6),
            const Text(
              'تبديل الحساب:',
              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            _RoleButton(
              title: 'العميل',
              icon: Icons.person,
              isSelected: currentRole == UserRole.customer,
              onTap: () => auth.switchRole(UserRole.customer),
            ),
            const SizedBox(width: 6),
            _RoleButton(
              title: 'المطعم',
              icon: Icons.restaurant,
              isSelected: currentRole == UserRole.restaurant,
              onTap: () => auth.switchRole(UserRole.restaurant),
            ),
            const SizedBox(width: 6),
            _RoleButton(
              title: 'المندوب',
              icon: Icons.delivery_dining,
              isSelected: currentRole == UserRole.driver,
              onTap: () => auth.switchRole(UserRole.driver),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? kEmeraldGreen : Colors.white24,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: isSelected ? kEmeraldGreen : Colors.white70),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? kEmeraldGreen : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
