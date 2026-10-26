import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/core/widgets/dokan_logo.dart';
import 'package:flutter_application_5/models/user.dart';
import 'package:flutter_application_5/services/auth_service.dart';
import 'package:flutter_application_5/features/customer/navigation/customer_nav.dart';
import 'package:flutter_application_5/features/restaurant/navigation/restaurant_nav.dart';
import 'package:flutter_application_5/features/driver/navigation/driver_nav.dart';
import 'package:flutter_application_5/features/auth/screens/role_selection_screen.dart';
import 'package:flutter_application_5/features/auth/screens/sign_up_screen.dart';
import 'package:flutter_application_5/features/auth/screens/forgot_password_screen.dart';

/// Screen 2: Highly Professional, Unified Emerald Outline Login Screen
class LoginScreen extends StatefulWidget {
  final UserRole? initialRole;
  const LoginScreen({super.key, this.initialRole});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late UserRole _currentRole;
  final _phoneOrEmailController = TextEditingController();
  final _passwordController = TextEditingController(text: '123456');
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentRole = widget.initialRole ?? UserRole.customer;
    _populateDefaultPhone();
  }

  void _populateDefaultPhone() {
    if (_currentRole == UserRole.driver) {
      _phoneOrEmailController.text = '01022222222';
    } else if (_currentRole == UserRole.restaurant) {
      _phoneOrEmailController.text = '01033333333';
    } else {
      _phoneOrEmailController.text = '01011111111';
    }
  }

  @override
  void dispose() {
    _phoneOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _roleTitle {
    switch (_currentRole) {
      case UserRole.driver:
        return 'المندوب';
      case UserRole.restaurant:
        return 'المطعم';
      case UserRole.customer:
        return 'العميل';
    }
  }

  IconData get _roleIcon {
    switch (_currentRole) {
      case UserRole.driver:
        return Icons.delivery_dining_outlined;
      case UserRole.restaurant:
        return Icons.storefront_outlined;
      case UserRole.customer:
        return Icons.person_outline_rounded;
    }
  }

  String get _rolePlaceholder {
    switch (_currentRole) {
      case UserRole.driver:
        return 'رقم هاتف المندوب أو كود الكابتن';
      case UserRole.restaurant:
        return 'رقم هاتف المطعم أو بريد المدير';
      case UserRole.customer:
        return 'رقم الموبايل أو البريد الإلكتروني';
    }
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    final auth = context.read<AuthService>();
    await auth.switchRole(_currentRole);

    if (!mounted) return;
    setState(() => _isLoading = false);

    Widget destination;
    if (_currentRole == UserRole.driver) {
      destination = const DriverNav();
    } else if (_currentRole == UserRole.restaurant) {
      destination = const RestaurantNav();
    } else {
      destination = const CustomerNav();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Outline Back Button to Role Selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: kEmeraldGreen,
                side: const BorderSide(color: kEmeraldGreen, width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
              icon: const Icon(Icons.swap_horiz_rounded, size: 16),
              label: const Text(
                'تغيير الحساب',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // 1. Dokan Official Brand Logo & Tagline
              const DokanLogo(
                size: 85,
                isWhite: false,
                showTagline: true,
              ),

              const SizedBox(height: 24),

              // 2. Active Role Outline Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kEmeraldGreen, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_roleIcon, color: kEmeraldGreen, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'تسجيل دخول $_roleTitle',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: kEmeraldGreen,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 3. Outline Inputs
              // Phone / Email field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kEmeraldGreen, width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Row(
                  children: [
                    Icon(Icons.phone_android_outlined, color: kEmeraldGreen, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _phoneOrEmailController,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(fontSize: 14, color: kDark, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: _rolePlaceholder,
                          hintStyle: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Password field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kEmeraldGreen, width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline_rounded, color: kEmeraldGreen, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(fontSize: 14, color: kDark, fontWeight: FontWeight.w600),
                        decoration: const InputDecoration(
                          hintText: 'كلمة المرور',
                          hintStyle: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: const Color(0xFF94A3B8),
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Remember me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: kEmeraldGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          side: const BorderSide(color: kEmeraldGreen, width: 1.5),
                          onChanged: (val) => setState(() => _rememberMe = val ?? true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'تذكرني',
                        style: TextStyle(color: kDark, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                      );
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      'نسيت كلمة المرور؟',
                      style: TextStyle(
                        color: kEmeraldGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 4. Primary OUTLINE Login Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kEmeraldGreen,
                    side: const BorderSide(color: kEmeraldGreen, width: 2.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(color: kEmeraldGreen, strokeWidth: 2.2),
                        )
                      : Text(
                          'دخول كـ $_roleTitle',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // 5. Quick 1-Tap Demo Switcher (Pure Outline)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kCardBorder, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.bolt_outlined, color: kEmeraldGreen, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'دخول تجريبي سريع بضغطة زر:',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _quickOutlineButton(
                            title: 'العميل 👤',
                            role: UserRole.customer,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _quickOutlineButton(
                            title: 'المندوب 🛵',
                            role: UserRole.driver,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _quickOutlineButton(
                            title: 'المطعم 🏪',
                            role: UserRole.restaurant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 6. "أو" Divider
              Row(
                children: const [
                  Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(
                      'أو متابعة عبر',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                ],
              ),

              const SizedBox(height: 18),

              // 7. Outline Social Logins
              Row(
                children: [
                  Expanded(
                    child: _SocialOutlineButton(
                      iconWidget: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png',
                        width: 20,
                        height: 20,
                        errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, color: Colors.blue, size: 24),
                      ),
                      label: 'Google',
                      onTap: _handleLogin,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SocialOutlineButton(
                      iconWidget: const Icon(Icons.apple, color: Colors.black, size: 22),
                      label: 'Apple',
                      onTap: _handleLogin,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // 8. Register Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ليس لديك حساب بعد؟ ',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SignUpScreen(role: _currentRole),
                        ),
                      );
                    },
                    child: const Text(
                      'أنشئ حسابك الآن',
                      style: TextStyle(
                        color: kEmeraldGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickOutlineButton({
    required String title,
    required UserRole role,
  }) {
    final isSelected = _currentRole == role;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _currentRole = role;
          _populateDefaultPhone();
        });
        _handleLogin();
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? kEmeraldGreen : kDark,
        side: BorderSide(
          color: isSelected ? kEmeraldGreen : kCardBorder,
          width: isSelected ? 1.8 : 1.0,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
    );
  }
}

class _SocialOutlineButton extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final VoidCallback onTap;

  const _SocialOutlineButton({
    required this.iconWidget,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: kCardBorder, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: kDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
