import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/services/auth_service.dart';
import 'package:flutter_application_5/services/order_service.dart';
import 'package:flutter_application_5/features/restaurant/screens/dashboard_screen.dart';
import 'package:flutter_application_5/features/restaurant/screens/orders_screen.dart';
import 'package:flutter_application_5/features/restaurant/screens/products_screen.dart';
import 'package:flutter_application_5/features/restaurant/screens/reports_screen.dart';
import 'package:flutter_application_5/features/restaurant/screens/settings_screen.dart';

class RestaurantNav extends StatefulWidget {
  const RestaurantNav({super.key});

  @override
  State<RestaurantNav> createState() => _RestaurantNavState();
}

class _RestaurantNavState extends State<RestaurantNav> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    RestaurantDashboardScreen(),
    RestaurantOrdersScreen(),
    RestaurantProductsScreen(),
    RestaurantReportsScreen(),
    RestaurantSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    final restaurantId = user?.restaurantId ?? 'rest1';
    final pendingCount =
        context
            .watch<OrderService>()
            .getPendingOrdersForRestaurant(restaurantId)
            .length;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: pendingCount > 0,
              label: Text('$pendingCount'),
              child: const Icon(Icons.receipt_long_outlined),
            ),
            activeIcon: Badge(
              isLabelVisible: pendingCount > 0,
              label: Text('$pendingCount'),
              child: const Icon(Icons.receipt_long),
            ),
            label: 'الطلبات',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            activeIcon: Icon(Icons.restaurant_menu),
            label: 'المنتجات',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'التقارير',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}
