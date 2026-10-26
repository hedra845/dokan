import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/services/auth_service.dart';
import 'package:flutter_application_5/models/user.dart';

import 'package:flutter_application_5/features/customer/navigation/customer_nav.dart';
import 'package:flutter_application_5/features/driver/navigation/driver_nav.dart';
import 'package:flutter_application_5/features/auth/screens/role_selection_screen.dart';

class RestaurantSettingsScreen extends StatelessWidget {
  const RestaurantSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات المطعم')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 46,
                    backgroundColor: kOrange,
                    child: Icon(Icons.restaurant, size: 45, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(user?.name ?? 'مطعم أبو خالد', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const Text('resto@phoenix.com', style: TextStyle(color: kGrey)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20)),
                    child: const Text('حساب مطعم شريك مفعّل', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _settingTile(Icons.info_outline, 'معلومات وبيانات المطعم'),
            _settingTile(Icons.access_time, 'مواعيد وساعات العمل'),
            _settingTile(Icons.delivery_dining, 'مناطق ورسوم التوصيل'),
            _settingTile(Icons.payment, 'الحسابات البنكية والأرباح'),
            _settingTile(Icons.notifications_outlined, 'إشعارات الطلبات الجديدة'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: kOrange, side: const BorderSide(color: kOrange)),
                icon: const Icon(Icons.swap_horiz),
                label: const Text('التبديل إلى حساب العميل أو المندوب'),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('اختر الحساب للتجربة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.person, color: kOrange),
                            title: const Text('تطبيق العميل (أحمد محمد)'),
                            onTap: () async {
                              Navigator.pop(context);
                              await auth.switchRole(UserRole.customer);
                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => const CustomerNav()),
                                  (route) => false,
                                );
                              }
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.delivery_dining, color: Colors.blue),
                            title: const Text('تطبيق المندوب / السائق (محمد خالد)'),
                            onTap: () async {
                              Navigator.pop(context);
                              await auth.switchRole(UserRole.driver);
                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => const DriverNav()),
                                  (route) => false,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await auth.logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                      (route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('تسجيل الخروج'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEBEE),
                  foregroundColor: kRed,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _settingTile(IconData icon, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: kOrange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kGrey),
      ),
    );
  }
}