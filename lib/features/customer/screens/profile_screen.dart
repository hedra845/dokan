import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/services/auth_service.dart';
import 'package:flutter_application_5/features/auth/screens/edit_profile_screen.dart';
import 'package:flutter_application_5/features/auth/screens/role_selection_screen.dart';
import 'package:flutter_application_5/features/customer/screens/delivery_location_screen.dart';
import 'package:flutter_application_5/features/customer/screens/favorites_screen.dart';
import 'package:flutter_application_5/features/customer/screens/notifications_screen.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProfile();
    });
  }

  Future<void> _refreshProfile() async {
    final auth = context.read<AuthService>();
    setState(() => _isRefreshing = true);
    await auth.fetchCustomerProfile();
    if (!mounted) return;
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          if (_isRefreshing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(
                user?.name ?? 'العميل',
                user?.email ?? '',
                user?.marketingOptIn ?? false,
              ),
              _buildMenuSection([
                {
                  'icon': Icons.person_outline,
                  'label': 'معلومات الحساب',
                  'color': const Color(0xFF2196F3),
                  'onTap':
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      ).then((_) => _refreshProfile()),
                },
                {
                  'icon': Icons.location_on_outlined,
                  'label': 'عناوين التوصيل',
                  'color': const Color(0xFF4CAF50),
                  'onTap':
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DeliveryLocationScreen(),
                        ),
                      ),
                },
                {
                  'icon': Icons.favorite_outline,
                  'label': 'المطاعم المفضلة',
                  'color': kRed,
                  'onTap':
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CustomerFavoritesScreen(),
                        ),
                      ),
                },
              ]),
              const SizedBox(height: 8),
              _buildMenuSection([
                {
                  'icon': Icons.notifications_outlined,
                  'label': 'الإشعارات',
                  'color': const Color(0xFFFF9800),
                  'onTap':
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      ),
                },
                {
                  'icon': Icons.lock_outline,
                  'label': 'الأمان وكلمة المرور',
                  'color': const Color(0xFF9C27B3),
                  'onTap':
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      ),
                },
              ]),
              const SizedBox(height: 8),
              _buildMenuSection([
                {
                  'icon': Icons.help_outline,
                  'label': 'المساعدة والدعم',
                  'color': const Color(0xFF607D8B),
                  'onTap': () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('المساعدة والدعم', textAlign: TextAlign.right),
                        content: const Text(
                          'فريق خدمة عملاء دكان جاهز لمساعدتك على مدار الساعة.\n\nالخط الساخن: 19888\nالبريد: support@dokan.app',
                          textAlign: TextAlign.right,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('إغلاق', style: TextStyle(color: kEmeraldGreen)),
                          ),
                        ],
                      ),
                    );
                  },
                },
                {
                  'icon': Icons.info_outline,
                  'label': 'عن التطبيق',
                  'color': const Color(0xFF607D8B),
                  'onTap': () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'دكان - DOKAN Food Delivery',
                      applicationVersion: '1.0.0',
                      applicationLegalese: 'جميع الحقوق محفوظة © 2026',
                    );
                  },
                },
              ]),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
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
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name, String email, bool marketingOptIn) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kOrange, kOrangeDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0] : 'ع',
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(email, style: const TextStyle(color: kGrey, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: kOrangeLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'عميل مميز ⭐',
                        style: TextStyle(
                          color: kOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              ).then((_) => _refreshProfile());
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.edit_outlined, color: kGrey, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(List<Map<String, dynamic>> items) {
    return Container(
      color: Colors.white,
      child: Column(
        children:
            items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: (item['color'] as Color).withAlpha(25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: item['color'] as Color,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item['label'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kDark,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: kGrey,
                    ),
                    onTap: item['onTap'] as VoidCallback?,
                  ),
                  if (i < items.length - 1)
                    const Divider(height: 1, indent: 70),
                ],
              );
            }).toList(),
      ),
    );
  }
}
