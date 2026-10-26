import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/models/order.dart';
import 'package:flutter_application_5/services/order_service.dart';
import 'package:flutter_application_5/services/auth_service.dart';
import 'package:flutter_application_5/features/restaurant/screens/order_detail_screen.dart';

class RestaurantOrdersScreen extends StatefulWidget {
  const RestaurantOrdersScreen({super.key});

  @override
  State<RestaurantOrdersScreen> createState() => _RestaurantOrdersScreenState();
}

class _RestaurantOrdersScreenState extends State<RestaurantOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    final restaurantId = user?.restaurantId ?? 'rest1';
    final orderService = context.watch<OrderService>();
    final allOrders = orderService.getOrdersByRestaurant(restaurantId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الطلبات'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: kOrange,
          unselectedLabelColor: kGrey,
          indicatorColor: kOrange,
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'جديد'),
            Tab(text: 'قيد التحضير'),
            Tab(text: 'جاهز'),
            Tab(text: 'مسلّم'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(allOrders),
          _buildOrderList(allOrders.where((o) => o.status.name == 'pending').toList()),
          _buildOrderList(allOrders.where((o) => o.status.name == 'preparing' || o.status.name == 'accepted').toList()),
          _buildOrderList(allOrders.where((o) => o.status.name == 'ready').toList()),
          _buildOrderList(allOrders.where((o) => o.status.name == 'delivered').toList()),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('لا توجد طلبات في هذا القسم', style: TextStyle(color: kGrey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, i) {
        final order = orders[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(14),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('طلب ${order.shortId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: order.status.color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                  child: Text(order.status.arabicName, style: TextStyle(color: order.status.color, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text('العميل: ${order.customerName}'),
                Text('${order.items.length} أصناف • ${order.total.toStringAsFixed(0)} ج.م', style: const TextStyle(color: kOrange, fontWeight: FontWeight.bold)),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kGrey),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantOrderDetailScreen(order: order))),
          ),
        );
      },
    );
  }
}