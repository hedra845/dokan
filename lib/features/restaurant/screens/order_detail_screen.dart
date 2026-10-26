import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/models/order.dart';
import 'package:flutter_application_5/services/order_service.dart';

class RestaurantOrderDetailScreen extends StatelessWidget {
  final Order order;
  const RestaurantOrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderService>(
      builder: (context, orderService, _) {
        final currentOrder = orderService.getOrderById(order.id) ?? order;

        return Scaffold(
          appBar: AppBar(
            title: Text('طلب ${currentOrder.shortId}'),
            actions: [
              if (currentOrder.status == OrderStatus.pending || currentOrder.status == OrderStatus.accepted)
                TextButton(
                  onPressed: () {
                    orderService.updateOrderStatus(currentOrder.id, OrderStatus.cancelled);
                    Navigator.pop(context);
                  },
                  child: const Text('إلغاء الطلب', style: TextStyle(color: kRed)),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: currentOrder.status.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: currentOrder.status.color.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(currentOrder.status.icon, color: currentOrder.status.color, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(currentOrder.status.arabicName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: currentOrder.status.color)),
                            Text('طريقة الدفع: ${currentOrder.paymentMethod}', style: const TextStyle(color: kGrey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Customer Info
                const Text('بيانات العميل والتوصيل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person_outline, color: kOrange),
                            const SizedBox(width: 10),
                            Expanded(child: Text(currentOrder.customerName, style: const TextStyle(fontWeight: FontWeight.bold))),
                            IconButton(
                              icon: const Icon(Icons.phone, color: Colors.green),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('الاتصال بالعميل: ${currentOrder.customerPhone}')),
                                );
                              },
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: kOrange),
                            const SizedBox(width: 10),
                            Expanded(child: Text(currentOrder.deliveryAddress.fullAddress, style: const TextStyle(color: kGrey, fontSize: 13))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Items list
                const Text('محتويات الوجبة والطلب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ...currentOrder.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${item.quantity}x  ${item.productName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text('${item.total.toStringAsFixed(0)} ج.م', style: const TextStyle(color: kDark, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('المجموع الكلي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('${currentOrder.total.toStringAsFixed(0)} ج.م', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kOrange)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Action Button depending on status
                if (currentOrder.status == OrderStatus.pending)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        orderService.updateOrderStatus(currentOrder.id, OrderStatus.accepted);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم قبول الطلب! يمكنك الآن البدء بالتحضير')),
                        );
                      },
                      child: const Text('قبول الطلب وتأكيده', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                else if (currentOrder.status == OrderStatus.accepted)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: kOrange),
                      onPressed: () {
                        orderService.updateOrderStatus(currentOrder.id, OrderStatus.preparing);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم تحويل الحالة إلى جاري التحضير')),
                        );
                      },
                      child: const Text('بدء تحضير الوجبة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                else if (currentOrder.status == OrderStatus.preparing)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF27AE60)),
                      onPressed: () {
                        orderService.updateOrderStatus(currentOrder.id, OrderStatus.ready);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('الطلب جاهز الآن وبانتظار استلام المندوب!')),
                        );
                      },
                      child: const Text('تأكيد الجاهزية (الطلب جاهز للتسليم)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text('حالة الطلب الحالية: ${currentOrder.status.arabicName}', style: const TextStyle(fontWeight: FontWeight.bold, color: kDark)),
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