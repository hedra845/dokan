import 'package:flutter/material.dart';
import 'package:flutter_application_5/features/driver/screens/home_screen.dart';
import 'package:flutter_application_5/features/driver/screens/earnings_screen.dart';
import 'package:flutter_application_5/features/driver/screens/settings_screen.dart';

class DriverNav extends StatefulWidget {
  const DriverNav({super.key});

  @override
  State<DriverNav> createState() => _DriverNavState();
}

class _DriverNavState extends State<DriverNav> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DriverHomeScreen(),
    DriverEarningsScreen(),
    DriverSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'أرباحي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
