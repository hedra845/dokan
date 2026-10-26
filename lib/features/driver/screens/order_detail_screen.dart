import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/models/order.dart';
import 'package:flutter_application_5/services/order_service.dart';
import 'package:flutter_application_5/data/mock_data.dart';
import 'package:flutter_application_5/features/driver/screens/delivery_confirm_screen.dart';
import 'package:flutter_application_5/widgets/route_map_view.dart';
import 'package:latlong2/latlong.dart';

class DriverOrderDetailScreen extends StatelessWidget {
  final Order order;
  const DriverOrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderService>(
      builder: (context, orderService, _) {
        final currentOrder = orderService.getOrderById(order.id) ?? order;

        return Scaffold(
          appBar: AppBar(title: Text('تفاصيل طلب التوصيل ${currentOrder.shortId}')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant Location Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: kOrangeLight, borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.store, color: kOrange),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('من المطعم:', style: TextStyle(color: kGrey, fontSize: 12)),
                                  Text(currentOrder.restaurantName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'العنوان: ${currentOrder.restaurantAddress}',
                          style: const TextStyle(color: kGrey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Customer Destination Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: kEmeraldGreen, width: 1.2),
                              ),
                              child: const Icon(Icons.home_outlined, color: kEmeraldGreen),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('إلى العميل:', style: TextStyle(color: kGrey, fontSize: 12)),
                                  Text(currentOrder.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.phone_outlined, color: kEmeraldGreen),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('الاتصال بالعميل: ${currentOrder.customerPhone}')),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(currentOrder.deliveryAddress.fullAddress, style: const TextStyle(color: kGrey, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Real Interactive Map Route Box (From Restaurant to Customer)
                RouteMapView(
                  fromPoint: LatLng(currentOrder.restaurantLat, currentOrder.restaurantLng),
                  toPoint: LatLng(
                    currentOrder.deliveryAddress.lat,
                    currentOrder.deliveryAddress.lng,
                  ),
                  fromLabel: currentOrder.restaurantName,
                  toLabel: 'مكان العميل: ${currentOrder.customerName}',
                  height: 220,
                ),
                const SizedBox(height: 14),

                // Delivery route specs pill (Outline)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kEmeraldGreen, width: 1.2),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.navigation_outlined, color: kEmeraldGreen, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'مسار التوصيل: 2.4 كم (10-15 دقيقة تقريباً)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: kEmeraldGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Earning Box (Outline)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kEmeraldGreen, width: 1.5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('أرباح التوصيل الخاصة بك:', style: TextStyle(fontWeight: FontWeight.bold, color: kEmeraldGreen)),
                      Text('25 ج.م', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kEmeraldGreen)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Dynamic Status Transitions for Driver (Outline Style)
                if (currentOrder.status == OrderStatus.ready || currentOrder.status == OrderStatus.accepted || currentOrder.status == OrderStatus.preparing)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kEmeraldGreen,
                        side: const BorderSide(color: kEmeraldGreen, width: 2.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        orderService.updateOrderStatus(
                          currentOrder.id,
                          OrderStatus.driverAssigned,
                          driverId: MockData.mockDriver.id,
                          driverName: MockData.mockDriver.name,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم قبول مهمة التوصيل! توجه الآن للمطعم')),
                        );
                      },
                      child: const Text('قبول مهمة التوصيل والتوجه للمطعم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                else if (currentOrder.status == OrderStatus.driverAssigned)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kEmeraldGreen,
                        side: const BorderSide(color: kEmeraldGreen, width: 2.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        orderService.updateOrderStatus(currentOrder.id, OrderStatus.pickedUp);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم استلام الوجبة من المطعم! انطلق للعميل')),
                        );
                      },
                      child: const Text('✓ تم استلام الطلب من المطعم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                else if (currentOrder.status == OrderStatus.pickedUp)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kEmeraldGreen,
                        side: const BorderSide(color: kEmeraldGreen, width: 2.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        orderService.updateOrderStatus(currentOrder.id, OrderStatus.onTheWay);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('أنت الآن في الطريق للعميل')),
                        );
                      },
                      child: const Text('بدء التوجه للعميل (في الطريق)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                else if (currentOrder.status == OrderStatus.onTheWay)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kEmeraldGreen,
                        side: const BorderSide(color: kEmeraldGreen, width: 2.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        orderService.updateOrderStatus(currentOrder.id, OrderStatus.delivered);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => DeliveryConfirmScreen(order: currentOrder)),
                        );
                      },
                      child: const Text('تأكيد تسليم الطلب للعميل ✓', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text('تم تسليم الطلب بنجاح', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}