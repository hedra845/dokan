import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/features/customer/navigation/customer_nav.dart';
import 'package:flutter_application_5/services/order_service.dart';
import 'package:flutter_application_5/models/order.dart';
import 'package:flutter_application_5/models/address.dart';
import 'package:flutter_application_5/widgets/route_map_view.dart';

/// Screen 9: Live Order Tracking with In-App Driver Chat & Calling, Timeline, and Outline Theme
class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    this.orderId = '#45872',
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final List<Map<String, String>> _messages = [
    {'sender': 'driver', 'text': 'مرحباً! استلمت وجبتك من المطعم وأنا في الطريق إليك الآن 🛵'},
    {'sender': 'me', 'text': 'شكراً جزيلاً! العمارة بجوار صيدلية العزبي'},
  ];
  final TextEditingController _chatController = TextEditingController();

  void _showChatBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SizedBox(
            height: 440,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: kEmeraldLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.chat_bubble_outline_rounded, color: kEmeraldGreen, size: 20),
                        ),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('محادثة مع كابتن التوصيل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kDark)),
                            Text('أحمد محمد • أونلاين الآن', style: TextStyle(fontSize: 11, color: kEmeraldGreen, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: kGrey),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const Divider(height: 20, color: Color(0xFFF1F5F9)),
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, i) {
                      final m = _messages[i];
                      final isMe = m['sender'] == 'me';
                      return Align(
                        alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            color: isMe ? kEmeraldGreen : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            m['text']!,
                            style: TextStyle(
                              color: isMe ? Colors.white : kDark,
                              fontSize: 13,
                              fontWeight: isMe ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            controller: _chatController,
                            decoration: const InputDecoration(
                              hintText: 'اكتب رسالة للكابتن...',
                              hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          if (_chatController.text.trim().isEmpty) return;
                          setSheetState(() {
                            _messages.add({'sender': 'me', 'text': _chatController.text.trim()});
                            _chatController.clear();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: kEmeraldGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cleanId = widget.orderId.replaceAll('#', '');
    final orderService = context.watch<OrderService>();
    final order = orderService.getOrderById(cleanId) ??
        orderService.orders.firstWhere(
          (o) => o.shortId == widget.orderId || o.id == cleanId,
          orElse: () => orderService.orders.isNotEmpty
              ? orderService.orders.first
              : Order(
                  id: cleanId,
                  customerId: 'cust_1',
                  customerName: 'أنت',
                  customerPhone: '01012345678',
                  restaurantId: 'rest_1',
                  restaurantName: 'مطعم البرجر الشهي',
                  restaurantAddress: 'مدينة نصر، القاهرة',
                  restaurantLat: 30.0560,
                  restaurantLng: 31.3300,
                  deliveryAddress: const Address(
                    id: 'addr_1',
                    label: 'المنزل',
                    governorate: 'القاهرة',
                    area: 'المعادي',
                    street: 'شارع النصر',
                    buildingNumber: '12',
                    lat: 30.0444,
                    lng: 31.2357,
                  ),
                  items: [],
                  subtotal: 0,
                  deliveryFee: 15,
                  paymentMethod: 'الدفع عند الاستلام',
                  status: OrderStatus.onTheWay,
                  createdAt: DateTime.now(),
                  driverName: 'أحمد محمد',
                ),
        );

    final bool hasDriver = order.driverId != null || order.driverName != null;
    final String driverName = order.driverName ?? (hasDriver ? 'كابتن التوصيل' : 'جاري تعيين كابتن...');
    const String driverPhone = '01012345678';

    // Status step flags
    final bool step1Done = true; // Confirmed
    final bool step2Done = order.status != OrderStatus.pending; // Preparing or higher
    final bool step3Done = order.status == OrderStatus.onTheWay || order.status == OrderStatus.delivered; // On the way
    final bool step4Done = order.status == OrderStatus.delivered;

    // Estimated delivery label
    final String etaText = order.status == OrderStatus.delivered
        ? 'تم تسليم الطلب بنجاح 🎉'
        : order.status == OrderStatus.onTheWay
            ? 'الكابتن في الطريق إليك 🛵 (خلال 12 دقيقة)'
            : 'جاري تحضير طلبك في المطعم 🍳';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('متابعة الطلب والتوصيل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: kDark)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kDark, size: 18),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const CustomerNav(initialIndex: 2)),
              (route) => false,
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: kEmeraldLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD1FAE5)),
                ),
                child: Text(
                  widget.orderId,
                  style: const TextStyle(fontWeight: FontWeight.w800, color: kEmeraldGreen, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. Live Interactive Route Map (OpenStreetMap)
            RouteMapView(
              fromPoint: LatLng(order.restaurantLat, order.restaurantLng),
              toPoint: LatLng(order.deliveryAddress.lat, order.deliveryAddress.lng),
              fromLabel: order.restaurantName,
              toLabel: 'موقع التوصيل: ${order.customerName}',
              driverPoint: step3Done
                  ? LatLng(
                      (order.restaurantLat + order.deliveryAddress.lat) / 2,
                      (order.restaurantLng + order.deliveryAddress.lng) / 2,
                    )
                  : null,
              height: 250,
            ),

            // 2. Delivery Status & Driver Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // ETA Header
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('⚡ ', style: TextStyle(fontSize: 16)),
                                  Expanded(
                                    child: Text(
                                      etaText,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: kDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'المطعم: ${order.restaurantName} • ${order.restaurantAddress}',
                                style: const TextStyle(fontSize: 11, color: kGrey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: kEmeraldLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFD1FAE5)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.radar, size: 14, color: kEmeraldGreen),
                              SizedBox(width: 4),
                              Text(
                                'تتبع مباشر',
                                style: TextStyle(fontSize: 11, color: kEmeraldGreen, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Courier / Driver Info Card with Call & Chat buttons
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: kEmeraldGreen, width: 1.2),
                          ),
                          child: const ClipOval(
                            child: Image(
                              image: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hasDriver ? '$driverName (الكابتن)' : 'جاري البحث عن كابتن...',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kDark),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.two_wheeler_outlined, size: 14, color: kEmeraldGreen),
                                  const SizedBox(width: 4),
                                  Text(
                                    hasDriver ? 'موتوسيكل • أ ب ج 1234' : 'سيصلك إشعار فور الاستلام',
                                    style: const TextStyle(fontSize: 11, color: kGrey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (hasDriver) ...[
                          // Chat Button
                          IconButton(
                            onPressed: () => _showChatBottomSheet(context),
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: kEmeraldLight,
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFD1FAE5)),
                              ),
                              child: const Icon(Icons.chat_bubble_outline_rounded, color: kEmeraldGreen, size: 18),
                            ),
                          ),
                          // Call Button
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('جاري الاتصال بكابتن التوصيل: $driverPhone'),
                                  backgroundColor: kEmeraldGreen,
                                ),
                              );
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: kEmeraldGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.phone_rounded, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Order Timeline Stepper
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'مراحل تحضير وتوصيل الوجبة',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kDark),
                        ),
                        const SizedBox(height: 14),
                        _buildTimelineStep(
                          title: 'تم تأكيد الطلب وقبوله في المطعم',
                          subtitle: 'تم الاستلام بنجاح',
                          isDone: step1Done,
                          isLast: false,
                        ),
                        _buildTimelineStep(
                          title: 'جاري تحضير الوجبة الطازجة بالمطعم',
                          subtitle: order.status == OrderStatus.preparing ? 'يتم التجهيز الآن 🍳' : 'جاهز للاستلام',
                          isDone: step2Done,
                          isLast: false,
                        ),
                        _buildTimelineStep(
                          title: hasDriver
                              ? 'الكابتن ($driverName) استلم الطلب وهو في الطريق لك'
                              : 'في انتظار استلام أقرب كابتن توصيل',
                          subtitle: step3Done ? 'جاري التوصيل 🛵' : 'قيد الانتظار',
                          isDone: step3Done,
                          isLast: false,
                        ),
                        _buildTimelineStep(
                          title: 'الوصول والتسليم لباب البيت',
                          subtitle: step4Done ? 'تم التسليم بنجاح' : 'في انتظار الوصول',
                          isDone: step4Done,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isDone,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? kEmeraldGreen : Colors.white,
                border: Border.all(
                  color: isDone ? kEmeraldGreen : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 34,
                color: isDone ? kEmeraldGreen : const Color(0xFFE5E7EB),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                  color: isDone ? kDark : kGrey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: kGrey),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
