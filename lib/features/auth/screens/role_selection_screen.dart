import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/core/widgets/dokan_logo.dart';
import 'package:flutter_application_5/models/user.dart';
import 'package:flutter_application_5/services/auth_service.dart';
import 'package:flutter_application_5/features/auth/screens/login_screen.dart';
import 'package:flutter_application_5/features/auth/screens/sign_up_screen.dart';

/// Screen: Role / Profile Selection BEFORE Login (Pure Outline & Unified Emerald Green Theme)
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole _selectedRole = UserRole.customer;

  final List<Map<String, dynamic>> _profiles = [
    {
      'role': UserRole.customer,
      'title': 'حساب العميل',
      'englishTitle': 'Customer Account',
      'icon': Icons.person_outline_rounded,
      'desc': 'تصفح المطاعم، استكشف القوائم والمنتجات واطلب توصيل سريع إلى بابك.',
      'features': ['طلب طعام وبقالة', 'تتبع حي لموقع الطلب', 'عروض وخصومات يومية'],
    },
    {
      'role': UserRole.driver,
      'title': 'حساب المندوب (الكابتن)',
      'englishTitle': 'Courier / Driver Account',
      'icon': Icons.delivery_dining_outlined,
      'desc': 'استلم طلبات التوصيل الجاهزة من المطاعم القريبة منك وحقق أرباحك بمرونة.',
      'features': ['أرباح فورية مجزية', 'حرية اختيار أوقات العمل', 'خرائط وملاحة ذكية'],
    },
    {
      'role': UserRole.restaurant,
      'title': 'حساب المطعم (التاجر)',
      'englishTitle': 'Merchant / Restaurant Account',
      'icon': Icons.storefront_outlined,
      'desc': 'إدارة الوجبات والمنتجات، متابعة الطلبات الواردة والتحكم بالمبيعات والأرباح.',
      'features': ['لوحة تحكم ذكية وشاملة', 'إشعار فوري بالطلبات الجديدة', 'تقارير أداء ومبيعات حية'],
    },
  ];

  void _proceedToLogin(UserRole role) {
    context.read<AuthService>().switchRole(role);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(initialRole: role),
      ),
    );
  }

  void _proceedToRegister(UserRole role) {
    context.read<AuthService>().switchRole(role);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignUpScreen(role: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'اختيار نوع الحساب',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kDark),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),

              // 1. Dokan Official Brand Logo & Slogan
              const DokanLogo(
                size: 85,
                isWhite: false,
                showTagline: true,
              ),

              const SizedBox(height: 24),

              // 2. Heading
              const Text(
                'مرحباً بك في دكان 👋',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: kDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'اختر الحساب المناسب لك للمتابعة إلى تسجيل الدخول:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: kGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),

              // 3. Profiles Outline Cards
              ..._profiles.map((profile) {
                final role = profile['role'] as UserRole;
                final isSelected = _selectedRole == role;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedRole = role);
                      _proceedToLogin(role);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isSelected ? kEmeraldLight.withAlpha(80) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        // OUTLINE STYLE: Crisp Outline Border
                        border: Border.all(
                          color: isSelected ? kEmeraldGreen : kCardBorder,
                          width: isSelected ? 2.0 : 1.2,
                        ),
                        boxShadow: isSelected ? AppShadows.soft : [],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Outline Icon Container
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected ? kEmeraldGreen : kCardBorder,
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  profile['icon'] as IconData,
                                  color: isSelected ? kEmeraldGreen : kDark,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile['title'] as String,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: isSelected ? kEmeraldGreen : kDark,
                                      ),
                                    ),
                                    Text(
                                      profile['englishTitle'] as String,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: kGrey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Outline Radio Check
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? kEmeraldGreen : const Color(0xFFCBD5E1),
                                    width: isSelected ? 6 : 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            profile['desc'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF475569),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Feature Chips in Outline style
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: (profile['features'] as List<String>)
                                .map(
                                  (f) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? kEmeraldGreen.withAlpha(120)
                                            : const Color(0xFFE2E8F0),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline,
                                          size: 13,
                                          color: isSelected ? kEmeraldGreen : kGrey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          f,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected ? kEmeraldGreen : kDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 12),

              // 4. Action Buttons: Login & Sign Up
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => _proceedToLogin(_selectedRole),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kEmeraldGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.login_rounded, size: 20),
                        label: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () => _proceedToRegister(_selectedRole),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kEmeraldGreen,
                          side: const BorderSide(color: kEmeraldGreen, width: 2.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.person_add_outlined, size: 20),
                        label: const Text(
                          'إنشاء حساب',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
