import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/core/widgets/dokan_logo.dart';
import 'package:flutter_application_5/models/order.dart';
import 'package:flutter_application_5/models/user.dart';
import 'package:flutter_application_5/services/auth_service.dart';
import 'package:flutter_application_5/services/order_service.dart';
import 'package:flutter_application_5/data/mock_data.dart';
import 'package:flutter_application_5/features/driver/screens/order_detail_screen.dart';
import 'package:flutter_application_5/features/customer/navigation/customer_nav.dart';
import 'package:flutter_application_5/features/restaurant/navigation/restaurant_nav.dart';
import 'package:flutter_application_5/features/auth/screens/role_selection_screen.dart';

/// Screen: Professional Driver / Courier Dashboard (Unified Emerald & Outline Styling)
class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isOnline = true;

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
                  child: const Icon(Icons.storefront_outlined, color: kEmeraldGreen),
                ),
                title: const Text('حساب المطعم (التاجر)', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('إدارة الطلبات الواردة والمبيعات وقائمة الأصناف', style: TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () async {
                  Navigator.pop(ctx);
                  await context.read<AuthService>().switchRole(UserRole.restaurant);
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const RestaurantNav()),
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
    final driver = MockData.mockDriver;

    return Consumer<OrderService>(
      builder: (context, orderService, _) {
        final availableOrders = orderService.getAvailableOrdersForDriver();
        final activeOrder = orderService.getActiveDriverOrder(driver.id);

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
                      Icon(Icons.two_wheeler_outlined, color: kEmeraldGreen, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'الكابتن',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kEmeraldGreen),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              // Outline switch role chip
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
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 400));
              setState(() {});
            },
            color: kEmeraldGreen,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Driver Profile Outline Card
                  _buildDriverOutlineHeader(driver),

                  const SizedBox(height: 16),

                  // 2. Metrics Row in Outline Style
                  Row(
                    children: [
                      _buildMetricOutlineCard(
                        title: 'أرباح اليوم',
                        value: '${driver.earnings.toStringAsFixed(0)} ج.م',
                        icon: Icons.account_balance_wallet_outlined,
                      ),
                      const SizedBox(width: 10),
                      _buildMetricOutlineCard(
                        title: 'تم توصيلها',
                        value: '${driver.totalDeliveries} طلب',
                        icon: Icons.task_alt_outlined,
                      ),
                      const SizedBox(width: 10),
                      _buildMetricOutlineCard(
                        title: 'التقييم العام',
                        value: '${driver.rating} ★',
                        icon: Icons.star_outline_rounded,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 3. Active Delivery Mission (if any)
                  if (activeOrder != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.navigation_outlined, color: kEmeraldGreen, size: 20),
                            SizedBox(width: 6),
                            Text(
                              'مهمة التوصيل الحالية 🛵',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: kDark),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: kEmeraldGreen, width: 1.2),
                          ),
                          child: const Text(
                            'نشطة الآن',
                            style: TextStyle(color: kEmeraldGreen, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildActiveOrderOutlineCard(context, activeOrder),
                    const SizedBox(height: 24),
                  ],

                  // 4. Section: Available Ready Orders Pool
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.radar_outlined, color: kEmeraldGreen, size: 20),
                          SizedBox(width: 6),
                          Text(
                            'طلبات جاهزة للاستلام',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: kDark),
                          ),
                        ],
                      ),
                      Text(
                        '${availableOrders.length} طلب متاح',
                        style: const TextStyle(color: kGrey, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (!_isOnline)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: kCardBorder, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: kCardBorder, width: 1.5),
                            ),
                            child: const Icon(Icons.cloud_off_outlined, color: kGrey, size: 36),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'أنت حالياً في وضع "غير متصل"',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: kDark),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'قم بتشغيل زر "متاح للعمل" في البطاقة بالأعلى لتصلك الطلبات فوراً.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kGrey, fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  else if (availableOrders.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: kEmeraldGreen, width: 1.2),
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.timer_outlined, color: kEmeraldGreen, size: 44),
                          SizedBox(height: 12),
                          Text(
                            'لا توجد طلبات معلقة حالياً في منطقتك',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: kDark),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'بمجرد تجهيز أي مطعم لوجبة، ستظهر لك هنا لتستلمها فوراً.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kGrey, fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  else
                    ...availableOrders.map((order) => _buildAvailableOrderOutlineCard(context, order, orderService, driver.id)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------------------
  // DRIVER OUTLINE HEADER
  // ----------------------------------------------------------------------
  Widget _buildDriverOutlineHeader(dynamic driver) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
        boxShadow: AppShadows.soft,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kEmeraldGreen, width: 1.8),
                ),
                child: const Icon(Icons.person_outline_rounded, color: kEmeraldGreen, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.name as String,
                      style: const TextStyle(
                        color: kDark,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.two_wheeler_outlined, color: kEmeraldGreen, size: 15),
                        const SizedBox(width: 4),
                        Text(
                          '${driver.vehicleType} • ${driver.vehiclePlate}',
                          style: const TextStyle(color: kGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: kCardBorder, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _isOnline ? kEmeraldGreen : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isOnline ? 'أنت متاح لاستقبال الطلبات' : 'غير متصل حالياً',
                    style: TextStyle(
                      color: _isOnline ? kEmeraldGreen : Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Switch(
                value: _isOnline,
                activeColor: kEmeraldGreen,
                activeTrackColor: kEmeraldLight,
                onChanged: (val) => setState(() => _isOnline = val),
              ),
            ],
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
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: kEmeraldLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: kEmeraldGreen, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: kDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                color: kGrey,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // ACTIVE ORDER OUTLINE CARD
  // ----------------------------------------------------------------------
  Widget _buildActiveOrderOutlineCard(BuildContext context, Order activeOrder) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kEmeraldGreen.withValues(alpha: 0.6), width: 1.4),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: kEmeraldGreen, width: 1),
                ),
                child: Text(
                  'طلب #${activeOrder.shortId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: kEmeraldGreen,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: activeOrder.status.color, width: 1),
                ),
                child: Text(
                  activeOrder.status.arabicName,
                  style: TextStyle(
                    color: activeOrder.status.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.storefront_outlined, size: 18, color: kEmeraldGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  activeOrder.restaurantName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 18, color: kEmeraldGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeOrder.customerName,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: kDark),
                    ),
                    Text(
                      activeOrder.deliveryAddress.fullAddress,
                      style: const TextStyle(color: kGrey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: kCardBorder),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: kEmeraldGreen,
                side: const BorderSide(color: kEmeraldGreen, width: 1.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.map_outlined, size: 18),
              label: const Text('متابعة خط السير وإكمال التسليم', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DriverOrderDetailScreen(order: activeOrder)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // AVAILABLE ORDER OUTLINE CARD
  // ----------------------------------------------------------------------
  Widget _buildAvailableOrderOutlineCard(
    BuildContext context,
    Order order,
    OrderService orderService,
    String driverId,
  ) {
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
              Text(
                'طلب #${order.shortId}',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: kDark),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kEmeraldGreen, width: 1.2),
                ),
                child: Text(
                  'أجرك: ${order.deliveryFee.toStringAsFixed(0)} ج.م',
                  style: const TextStyle(
                    color: kEmeraldGreen,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.storefront_outlined, size: 18, color: kEmeraldGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'استلام من: ${order.restaurantName}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.pin_drop_outlined, size: 18, color: kEmeraldGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'توصيل إلى: ${order.customerName}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: kDark),
                    ),
                    Text(
                      order.deliveryAddress.fullAddress,
                      style: const TextStyle(color: kGrey, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DriverOrderDetailScreen(order: order)),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kDark,
                    side: const BorderSide(color: kCardBorder, width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  child: const Text('التفاصيل', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await orderService.updateOrderStatus(
                      order.id,
                      OrderStatus.onTheWay,
                      driverId: driverId,
                      driverName: MockData.mockDriver.name,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تم قبول المهمة #${order.shortId}! فتح مسار المطعم والعميل 🛵'),
                          backgroundColor: kEmeraldGreen,
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DriverOrderDetailScreen(order: order),
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kEmeraldGreen,
                    side: const BorderSide(color: kEmeraldGreen, width: 2.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                  label: const Text('قبول واستلام', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}