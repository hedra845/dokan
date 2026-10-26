import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/features/customer/navigation/customer_nav.dart';
import 'package:flutter_application_5/features/restaurant/navigation/restaurant_nav.dart';
import 'package:flutter_application_5/features/driver/navigation/driver_nav.dart';
import 'package:flutter_application_5/models/user.dart';

class EmailVerificationScreen extends StatefulWidget {
  final User user;
  const EmailVerificationScreen({super.key, required this.user});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isChecking = false;

  void _navigateToMain(UserRole role) {
    switch (role) {
      case UserRole.customer:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const CustomerNav()),
          (route) => false,
        );
      case UserRole.restaurant:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const RestaurantNav()),
          (route) => false,
        );
      case UserRole.driver:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DriverNav()),
          (route) => false,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1E2432),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: kEmeraldGreen.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.email_outlined,
                          size: 48,
                          color: kEmeraldGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'تحقق من بريدك الإلكتروني',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'لقد أرسلنا رابط التحقق إلى بريدك الإلكتروني:\n${widget.user.email}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9CA3AF),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'انقر على الرابط لتفعيل حسابك ثم استمتع بالتجربة',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed:
                            _isChecking
                                ? null
                                : () {
                                  setState(() => _isChecking = true);
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () {
                                      if (!mounted) return;
                                      setState(() => _isChecking = false);
                                      _navigateToMain(widget.user.role);
                                    },
                                  );
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kEmeraldGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child:
                            _isChecking
                                ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Text(
                                  'تحقق من التفعيل',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'لم تتلقي البريد؟ ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9CA3AF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم إرسال رابط التحقق مرة أخرى'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: const Text(
                            'إعادة إرسال',
                            style: TextStyle(
                              fontSize: 14,
                              color: kEmeraldGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
