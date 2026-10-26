import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/core/widgets/dokan_logo.dart';
import 'package:flutter_application_5/services/auth_service.dart';
import 'package:flutter_application_5/services/order_service.dart';
import 'package:flutter_application_5/models/order.dart';
import 'package:flutter_application_5/models/user.dart';
import 'package:flutter_application_5/features/restaurant/screens/order_detail_screen.dart';
import 'package:flutter_application_5/features/customer/navigation/customer_nav.dart';
import 'package:flutter_application_5/features/driver/navigation/driver_nav.dart';
import 'package:flutter_application_5/features/auth/screens/role_selection_screen.dart';

/// Screen: Professional Restaurant Management Dashboard (Unified Emerald & Outline Styling)
class RestaurantDashboardScreen extends StatefulWidget {
  const RestaurantDashboardScreen({super.key});

  @override
  State<RestaurantDashboardScreen> createState() => _RestaurantDashboardScreenState();
}

class _RestaurantDashboardScreenState extends State<RestaurantDashboardScreen> {
  bool _isOpen = true;
  String _selectedFilter = 'all'; // 'all', 'pending', 'preparing', 'ready'

  void _showRoleSwitcher(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'تبديل نوع الحساب',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDark),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'اختر الحساب الذي تريد الانتقال إليه لتجربة التطبيق:',
                style: TextStyle(fontSize: 13, color: kGrey),
              ),
              const SizedBox(height: 16),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: kEmeraldGreen, width: 1.2),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kEmeraldGreen),
                  ),
                  child: const Icon(Icons.person_outline_rounded, color: kEmeraldGreen),
                ),
                title: const Text('حساب العميل (DOKAN)', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('تصفح المطاعم، الطلب، السلة والعروض', style: TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () async {
                  Navigator.pop(ctx);
                  await context.read<AuthService>().switchRole(UserRole.customer);
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const CustomerNav()),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: kEmeraldGreen, width: 1.2),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kEmeraldGreen),
                  ),
                  child: const Icon(Icons.delivery_dining_outlined, color: kEmeraldGreen),
                ),
                title: const Text('حساب المندوب (الكابتن)', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('استلام طلبات التوصيل، متابعة الأرباح وخط السير', style: TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () async {
                  Navigator.pop(ctx);
                  await context.read<AuthService>().switchRole(UserRole.driver);
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const DriverNav()),
                    );
                  }
                },
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await context.read<AuthService>().logout();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Color(0xFFFCA5A5), width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('تسجيل الخروج والرجوع لاختيار الحساب'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    final restaurantId = user?.restaurantId ?? 'rest1';

    return Consumer<OrderService>(
      builder: (context, orderService, _) {
        final allOrders = orderService.getOrdersByRestaurant(restaurantId);
        final todayCount = orderService.getTodayOrderCount(restaurantId);
        final todaySales = orderService.getTodaySales(restaurantId);
        final preparingCount = allOrders.where((o) => o.status == OrderStatus.preparing || o.status == OrderStatus.accepted).length;

        // Filter orders
        final filteredOrders = allOrders.where((o) {
          if (_selectedFilter == 'pending') return o.status == OrderStatus.pending;
          if (_selectedFilter == 'preparing') return o.status == OrderStatus.preparing || o.status == OrderStatus.accepted;
          if (_selectedFilter == 'ready') return o.status == OrderStatus.ready;
          return true;
        }).toList();

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            title: Row(
              children: [
                // Prominent Dokan Logo
                const DokanLogo(size: 48),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kEmeraldGreen, width: 1.2),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.storefront_outlined, color: kEmeraldGreen, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'لوحة المطعم',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kEmeraldGreen),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              // Outline role switch button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: OutlinedButton.icon(
                  onPressed: () => _showRoleSwitcher(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kEmeraldGreen,
                    side: const BorderSide(color: kEmeraldGreen, width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                  icon: const Icon(Icons.swap_horiz, size: 16),
                  label: const Text(
                    'تبديل الحساب',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Restaurant Status Outline Banner
                _buildStoreStatusOutlineBanner(),

                const SizedBox(height: 16),

                // 2. Metrics Grid in Outline Style (2x2)
                Row(
                  children: [
                    _buildMetricOutlineCard(
                      title: 'طلبات اليوم',
                      value: '$todayCount طلب',
                      icon: Icons.receipt_long_outlined,
                    ),
                    const SizedBox(width: 12),
                    _buildMetricOutlineCard(
                      title: 'إجمالي المبيعات',
                      value: '${todaySales.toStringAsFixed(0)} ج.م',
                      icon: Icons.monetization_on_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildMetricOutlineCard(
                      title: 'قيد التحضير الآن',
                      value: '$preparingCount طلب',
                      icon: Icons.soup_kitchen_outlined,
                    ),
                    const SizedBox(width: 12),
                    _buildMetricOutlineCard(
                      title: 'تقييم المطعم',
                      value: '4.8 ★',
                      icon: Icons.star_outline_rounded,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 3. Section Title + Filter Chips (Outline)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'الطلبات الواردة للمطعم',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: kDark),
                    ),
                    Text(
                      '${allOrders.length} طلب إجمالي',
                      style: const TextStyle(color: kGrey, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Filter Outline chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildFilterOutlineChip('all', 'الكل (${allOrders.length})'),
                      const SizedBox(width: 8),
                      _buildFilterOutlineChip('pending', 'جديدة'),
                      const SizedBox(width: 8),
                      _buildFilterOutlineChip('preparing', 'قيد التحضير ($preparingCount)'),
                      const SizedBox(width: 8),
                      _buildFilterOutlineChip('ready', 'جاهزة للتوصيل'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Orders Outline List
                if (filteredOrders.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(36),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kEmeraldGreen, width: 1.2),
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.inbox_outlined, size: 48, color: kEmeraldGreen),
                        SizedBox(height: 12),
                        Text(
                          'لا توجد طلبات في هذا التصنيف حالياً',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kDark),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ستظهر أي طلبات جديدة يقوم العملاء بطلبها هنا فوراً',
                          style: TextStyle(color: kGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                else
                  ...filteredOrders.map((order) => _buildRestaurantOrderOutlineCard(context, order, orderService)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------------------
  // STORE STATUS OUTLINE BANNER
  // ----------------------------------------------------------------------
  Widget _buildStoreStatusOutlineBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _isOpen ? kEmeraldGreen : Colors.red, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _isOpen ? kEmeraldGreen : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isOpen ? 'المطعم يستقبل الطلبات الآن' : 'المطعم مغلق حالياً',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: _isOpen ? kEmeraldGreen : Colors.red,
                    ),
                  ),
                  Text(
                    _isOpen ? 'العملاء قادرون على الطلب والدفع' : 'العملاء لن يتمكنوا من إرسال طلبات',
                    style: const TextStyle(fontSize: 11, color: kGrey),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: _isOpen,
            activeColor: kEmeraldGreen,
            activeTrackColor: kEmeraldLight,
            onChanged: (val) => setState(() => _isOpen = val),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // METRIC OUTLINE CARD
  // ----------------------------------------------------------------------
  Widget _buildMetricOutlineCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kEmeraldGreen, width: 1.3),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kEmeraldGreen, width: 1.2),
              ),
              child: Icon(icon, color: kEmeraldGreen, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: kDark),
                  ),
                  Text(
                    title,
                    style: const TextStyle(color: kGrey, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // FILTER OUTLINE CHIP
  // ----------------------------------------------------------------------
  Widget _buildFilterOutlineChip(String filterKey, String label) {
    final isSelected = _selectedFilter == filterKey;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filterKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? kEmeraldLight.withAlpha(100) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? kEmeraldGreen : kCardBorder,
            width: isSelected ? 1.8 : 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? kEmeraldGreen : kDark,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // RESTAURANT ORDER OUTLINE CARD
  // ----------------------------------------------------------------------
  Widget _buildRestaurantOrderOutlineCard(BuildContext context, Order order, OrderService orderService) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kEmeraldGreen, width: 1.4),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'طلب #${order.shortId}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: kDark),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• ${order.items.length} أصناف',
                    style: const TextStyle(color: kGrey, fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: order.status.color, width: 1.2),
                ),
                child: Text(
                  order.status.arabicName,
                  style: TextStyle(
                    color: order.status.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'العميل: ${order.customerName}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: kDark),
          ),
          const SizedBox(height: 8),
          // Items Preview in Outline Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kCardBorder, width: 1),
            ),
            child: Column(
              children: order.items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.quantity}x ${item.productName}',
                            style: const TextStyle(fontSize: 12, color: kDark),
                          ),
                          Text(
                            '${item.total.toStringAsFixed(0)} ج.م',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kDark),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المجموع: ${order.total.toStringAsFixed(0)} ج.م',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: kEmeraldGreen),
              ),
              Text(
                order.paymentMethod,
                style: const TextStyle(fontSize: 11, color: kGrey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: kCardBorder),
          const SizedBox(height: 10),

          // Interactive Workflow Buttons in OUTLINE style
          if (order.status == OrderStatus.pending) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await orderService.updateOrderStatus(order.id, OrderStatus.preparing);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم قبول الطلب #${order.shortId} وبدء التحضير 🍳')),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: kEmeraldGreen,
                  side: const BorderSide(color: kEmeraldGreen, width: 2.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                icon: const Icon(Icons.soup_kitchen_outlined, size: 18),
                label: const Text('قبول الطلب وبدء التحضير', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ] else if (order.status == OrderStatus.preparing || order.status == OrderStatus.accepted) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await orderService.updateOrderStatus(order.id, OrderStatus.ready);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('الطلب #${order.shortId} جاهز وأصبح متاحاً للمناديب للاستلام 🛵'),
                        backgroundColor: kEmeraldGreen,
                      ),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: kEmeraldGreen,
                  side: const BorderSide(color: kEmeraldGreen, width: 2.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                label: const Text('تم الانتهاء - جاهز للتوصيل', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ] else if (order.status == OrderStatus.ready) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kEmeraldGreen, width: 1.2),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.two_wheeler_outlined, size: 16, color: kEmeraldGreen),
                  SizedBox(width: 6),
                  Text(
                    'الطلب جاهز بانتظار استلام المندوب',
                    style: TextStyle(color: kEmeraldGreen, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
          ] else ...[
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RestaurantOrderDetailScreen(order: order)),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: kDark,
                side: const BorderSide(color: kCardBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Center(child: Text('عرض تفاصيل الطلب الكاملة', style: TextStyle(fontSize: 12))),
            ),
          ],
        ],
      ),
    );
  }
}