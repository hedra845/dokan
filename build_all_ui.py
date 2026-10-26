import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content.strip())
    print("Wrote:", path)

# ==============================================================================
# CORE & WIDGETS
# ==============================================================================

write_file(r'd:\flutter_application_5\lib\core\theme\app_theme.dart', '''
import 'package:flutter/material.dart';

const Color kOrange = Color(0xFFFF5722);
const Color kOrangeDark = Color(0xFFE64A19);
const Color kOrangeLight = Color(0xFFFFF3E0);
const Color kDark = Color(0xFF1E2022);
const Color kGrey = Color(0xFF7F8C8D);
const Color kLightGrey = Color(0xFFF5F6FA);
const Color kWhite = Colors.white;
const Color kGreen = Color(0xFF27AE60);
const Color kRed = Color(0xFFE74C3C);

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kLightGrey,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kOrange,
          primary: kOrange,
          secondary: kOrangeDark,
          surface: kWhite,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kWhite,
          foregroundColor: kDark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: kDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: kDark),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kOrange,
            foregroundColor: kWhite,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        cardTheme: CardThemeData(
          color: kWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: kWhite,
          selectedItemColor: kOrange,
          unselectedItemColor: kGrey,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: TextStyle(fontSize: 11),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      );
}
''')

write_file(r'd:\flutter_application_5\lib\core\widgets\phoenix_logo.dart', '''
import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';

class PhoenixLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isWhiteText;

  const PhoenixLogo({
    super.key,
    this.size = 50,
    this.showText = true,
    this.isWhiteText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(size, size * 0.85),
          painter: _PhoenixWingsPainter(),
        ),
        if (showText) ...[
          const SizedBox(height: 6),
          Text(
            'Phoenix Systems',
            style: TextStyle(
              fontSize: size * 0.35,
              fontWeight: FontWeight.bold,
              color: isWhiteText ? Colors.white : kDark,
              letterSpacing: 0.8,
            ),
          ),
          Text(
            'Your Partner in Digital Solutions',
            style: TextStyle(
              fontSize: size * 0.16,
              color: isWhiteText ? Colors.white70 : kGrey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}

class _PhoenixWingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kOrange
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Wing Left
    final pathLeft = Path();
    pathLeft.moveTo(size.width * 0.45, size.height * 0.9);
    pathLeft.quadraticBezierTo(size.width * 0.1, size.height * 0.7, 0, size.height * 0.2);
    pathLeft.quadraticBezierTo(size.width * 0.25, size.height * 0.35, size.width * 0.38, size.height * 0.55);
    pathLeft.quadraticBezierTo(size.width * 0.2, size.height * 0.05, size.width * 0.15, 0);
    pathLeft.quadraticBezierTo(size.width * 0.4, size.height * 0.15, size.width * 0.48, size.height * 0.4);
    pathLeft.close();
    canvas.drawPath(pathLeft, paint);

    // Wing Right
    final pathRight = Path();
    pathRight.moveTo(size.width * 0.55, size.height * 0.9);
    pathRight.quadraticBezierTo(size.width * 0.9, size.height * 0.7, size.width, size.height * 0.2);
    pathRight.quadraticBezierTo(size.width * 0.75, size.height * 0.35, size.width * 0.62, size.height * 0.55);
    pathRight.quadraticBezierTo(size.width * 0.8, size.height * 0.05, size.width * 0.85, 0);
    pathRight.quadraticBezierTo(size.width * 0.6, size.height * 0.15, size.width * 0.52, size.height * 0.4);
    pathRight.close();
    canvas.drawPath(pathRight, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
''')

write_file(r'd:\flutter_application_5\lib\core\widgets\simulated_map.dart', '''
import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';

class SimulatedMap extends StatelessWidget {
  final double height;
  final String startLabel;
  final String endLabel;
  final String? timeLabel;
  final bool showBike;
  final IconData startIcon;
  final IconData endIcon;

  const SimulatedMap({
    super.key,
    this.height = 180,
    this.startLabel = 'ماكدونالدز',
    this.endLabel = 'العميل',
    this.timeLabel,
    this.showBike = true,
    this.startIcon = Icons.store,
    this.endIcon = Icons.home,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E9F0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // Road Network Grid Background
            CustomPaint(
              size: Size(double.infinity, height),
              painter: _MapRoadPainter(),
            ),

            // Start Location Pin (e.g. Restaurant)
            Positioned(
              top: height * 0.2,
              right: 40,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: Icon(startIcon, color: Colors.white, size: 16),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                    child: Text(startLabel, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // End Location Pin (e.g. Customer)
            Positioned(
              bottom: height * 0.15,
              left: 40,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: Icon(endIcon, color: Colors.white, size: 16),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                    child: Text(endLabel, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // Moving Courier/Driver marker
            if (showBike)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (timeLabel != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        ),
                        child: Text(timeLabel!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kDark)),
                      ),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        color: kOrange,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 6)],
                      ),
                      child: const Icon(Icons.delivery_dining, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MapRoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE9ECEF);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final roadBorder = Paint()
      ..color = const Color(0xFFD0D7DE)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    // Draw grid roads
    final roads = [
      Path()..moveTo(0, size.height * 0.35)..lineTo(size.width, size.height * 0.35),
      Path()..moveTo(0, size.height * 0.7)..lineTo(size.width, size.height * 0.7),
      Path()..moveTo(size.width * 0.3, 0)..lineTo(size.width * 0.3, size.height),
      Path()..moveTo(size.width * 0.7, 0)..lineTo(size.width * 0.7, size.height),
    ];

    for (var r in roads) {
      canvas.drawPath(r, roadBorder);
      canvas.drawPath(r, roadPaint);
    }

    // Active Route Path in Blue
    final routeBorder = Paint()
      ..color = Colors.blue.shade300
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final routePaint = Paint()
      ..color = const Color(0xFF1E88E5)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final route = Path();
    route.moveTo(size.width - 60, size.height * 0.35);
    route.lineTo(size.width * 0.5, size.height * 0.35);
    route.lineTo(size.width * 0.5, size.height * 0.7);
    route.lineTo(60, size.height * 0.7);

    canvas.drawPath(route, routeBorder);
    canvas.drawPath(route, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
''')

write_file(r'd:\flutter_application_5\lib\core\widgets\role_switcher_banner.dart', '''
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
      color: const Color(0xFF1E2022),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SafeArea(
        bottom: false,
        top: false,
        child: Row(
          children: [
            InkWell(
              onTap: () => auth.logout(),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.swap_horiz, color: Colors.orangeAccent, size: 13),
                    SizedBox(width: 4),
                    Text('تغيير الواجهة', style: TextStyle(color: Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            _RolePill(
              title: 'العميل',
              icon: Icons.person,
              isSelected: currentRole == UserRole.customer,
              onTap: () => auth.switchRole(UserRole.customer),
            ),
            const SizedBox(width: 4),
            _RolePill(
              title: 'المطعم',
              icon: Icons.restaurant,
              isSelected: currentRole == UserRole.restaurant,
              onTap: () => auth.switchRole(UserRole.restaurant),
            ),
            const SizedBox(width: 4),
            _RolePill(
              title: 'السائق',
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

class _RolePill extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RolePill({
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? kOrange : Colors.white12,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: Colors.white),
            const SizedBox(width: 3),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
''')

print("Core and Widgets generated successfully!")
''')

