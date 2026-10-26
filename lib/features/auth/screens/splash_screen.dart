import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/services/auth_service.dart';
import 'package:flutter_application_5/features/auth/screens/login_screen.dart';
import 'package:flutter_application_5/features/auth/screens/role_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    final auth = context.read<AuthService>();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final target =
        auth.isLoggedIn ? const RoleSelectionScreen() : const LoginScreen();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => target,
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
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
      backgroundColor: kDark,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [kOrange.withOpacity(0.25), kOrange.withOpacity(0)],
                  radius: 1.5,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [kOrange.withOpacity(0.15), kOrange.withOpacity(0)],
                  radius: 1.5,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomPaint(
                  size: const Size(140, 120),
                  painter: _PhoenixWingsPainter(),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Phoenix Systems',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your Partner in Digital Solutions',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white60,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: kOrange,
                    strokeWidth: 2.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'جاري التحميل',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoenixWingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = kOrange
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;

    final pathLeft = Path();
    pathLeft.moveTo(size.width * 0.45, size.height * 0.9);
    pathLeft.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.7,
      0,
      size.height * 0.2,
    );
    pathLeft.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.35,
      size.width * 0.38,
      size.height * 0.55,
    );
    pathLeft.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.05,
      size.width * 0.15,
      0,
    );
    pathLeft.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.15,
      size.width * 0.48,
      size.height * 0.4,
    );
    pathLeft.close();
    canvas.drawPath(pathLeft, paint);

    final pathRight = Path();
    pathRight.moveTo(size.width * 0.55, size.height * 0.9);
    pathRight.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.7,
      size.width,
      size.height * 0.2,
    );
    pathRight.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.35,
      size.width * 0.62,
      size.height * 0.55,
    );
    pathRight.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.05,
      size.width * 0.85,
      0,
    );
    pathRight.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.15,
      size.width * 0.52,
      size.height * 0.4,
    );
    pathRight.close();
    canvas.drawPath(pathRight, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
