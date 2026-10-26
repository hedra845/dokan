import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/features/customer/screens/order_tracking_screen.dart';
import 'package:flutter_application_5/features/customer/screens/cart_screen.dart';
import 'package:flutter_application_5/services/order_service.dart';
import 'package:flutter_application_5/models/order.dart';

/// Screen 12: My Orders & Order History matching Dokan Emerald Style
class CustomerOrdersScreen extends StatefulWidget {
  const CustomerOrdersScreen({super.key});

  @override
  State<CustomerOrdersScreen> createState() => _CustomerOrdersScreenState();
}

class _CustomerOrdersScreenState extends State<CustomerOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _sampleOrders = [
    {
      'id': '#DK-8492',
      'restaurant': 'شاورما البلد',
      'items': '2 شاورما لحم عربي + بطاطس + ثومية',
      'status': 'جاري التوصيل 🛵',
      'isLive': true,
      'date': 'اليوم 05:20 م',
      'total': '160 ج.م',
      'imageUrl': 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=200',
    },
    {
      'id': '#DK-7921',
      'restaurant': 'كشري التحرير',
      'items': '1 كشري ميجا سوبر + صوص دقة إضافي',
      'status': 'تم التوصيل بنجاح ✅',
      'isLive': false,
      'date': 'أمس 08:30 م',
      'total': '65 ج.م',
      'imageUrl': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200',
    },
    {
      'id': '#DK-6310',
      'restaurant': 'بيتزا روما الإيطالية',
      'items': '1 بيتزا بيبروني وسط + بيبسي كانز',
      'status': 'تم التوصيل بنجاح ✅',
      'isLive': false,
      'date': '12 أكتوبر 02:15 م',
      'total': '210 ج.م',
      'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _buildDisplayOrders(List<Order> serviceOrders) {
    final List<Map<String, dynamic>> list = [];
    
    // Add real orders from service first
    for (final o in serviceOrders) {
      final itemsSummary = o.items.map((i) => '${i.quantity} ${i.productName}').join(' + ');
      list.add({
        'id': o.shortId,
        'restaurant': o.restaurantName,
        'items': itemsSummary.isNotEmpty ? itemsSummary : 'وجبة متنوعة',
        'status': '${o.status.arabicName} ${o.status.isActive ? "🛵" : "✅"}',
        'isLive': o.status.isActive,
        'date': 'منذ قليل',
        'total': '${o.total.toInt()} ج.م',
        'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200',
      });
    }

    // Add sample orders
    list.addAll(_sampleOrders);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final orderService = context.watch<OrderService>();
    final allOrders = _buildDisplayOrders(orderService.orders);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('طلباتي 📦', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kDark)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF64748B),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: kEmeraldGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              tabs: const [
                Tab(text: 'الكل'),
                Tab(text: 'الطلبات الحالية'),
                Tab(text: 'المكتملة'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(allOrders),
          _buildOrdersList(allOrders.where((o) => o['isLive'] == true).toList()),
          _buildOrdersList(allOrders.where((o) => o['isLive'] == false).toList()),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kEmeraldLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.receipt_long_outlined, size: 50, color: kEmeraldGreen),
            ),
            const SizedBox(height: 16),
            const Text('لا توجد طلبات هنا حالياً', style: TextStyle(color: kDark, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            const Text('ابدأ بطلب وجبتك المفضلة واستمتع بتوصيل سريع', style: TextStyle(color: kGrey, fontSize: 12)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final order = orders[index];
        final bool isLive = order['isLive'] == true;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isLive ? kEmeraldGreen : const Color(0xFFE2E8F0),
              width: isLive ? 1.5 : 1.0,
            ),
            boxShadow: AppShadows.soft,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isLive ? kEmeraldLight : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isLive ? Icons.delivery_dining : Icons.check_circle_outline,
                          color: isLive ? kEmeraldGreen : const Color(0xFF64748B),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order['id'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: kDark,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isLive ? kEmeraldLight : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isLive ? const Color(0xFFD1FAE5) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Text(
                      order['status'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isLive ? kEmeraldGreen : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),

              // Order content row
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      order['imageUrl'],
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['restaurant'],
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kDark),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          order['items'] ?? '',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order['date'],
                              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                            ),
                            Text(
                              order['total'],
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: kEmeraldGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Action buttons row
              Row(
                children: [
                  if (isLive) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderTrackingScreen(orderId: order['id']),
                            ),
                          );
                        },
                        icon: const Icon(Icons.navigation_outlined, size: 16),
                        label: const Text('تتبع الطلب والخريطة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kEmeraldGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تمت إعادة طلب "${order['restaurant']}" وإضافته للسلة! 🛒'),
                              backgroundColor: kEmeraldGreen,
                              action: SnackBarAction(
                                label: 'عرض السلة',
                                textColor: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const CartScreen()),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.replay, size: 15),
                        label: const Text('إعادة الطلب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kEmeraldGreen,
                          side: const BorderSide(color: Color(0xFFD1FAE5), width: 1.2),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
