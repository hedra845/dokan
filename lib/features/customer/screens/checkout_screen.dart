import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/features/customer/screens/order_tracking_screen.dart';
import 'package:flutter_application_5/models/order.dart';
import 'package:flutter_application_5/models/order_item.dart';
import 'package:flutter_application_5/models/address.dart';
import 'package:flutter_application_5/services/order_service.dart';
import 'package:flutter_application_5/services/auth_service.dart';
import 'package:flutter_application_5/services/cart_service.dart';

/// Screen 8: Checkout & Payment with Wallet, Split Pay, Tip Courier, and Unified Outline Styling
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPaymentMethod = 0; // 0: كارت بنكي, 1: محفظة إلكترونية (فودافون كاش / إنستاباي), 2: كاش عند الاستلام, 3: محفظة دكان DOKAN Pay
  int _selectedTip = 10; // 0, 5, 10, 15, 20 EGP tip for courier
  bool _useDokanWalletBalance = false;
  final double _walletBalance = 85.0; // EGP in Dokan wallet

  final double _subtotal = 140.0;
  final double _deliveryFee = 15.0;

  double get _total {
    double t = _subtotal + _deliveryFee + _selectedTip;
    if (_useDokanWalletBalance) {
      t = (t - _walletBalance).clamp(0.0, 9999.0);
    }
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('إتمام الدفع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kDark)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kDark, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Delivery Address Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kEmeraldLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on, color: kEmeraldGreen, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('عنوان التوصيل الرئيسي', style: TextStyle(fontSize: 11, color: kGrey)),
                        SizedBox(height: 2),
                        Text(
                          'المنزل - عمارة 15 شارع عباس العقاد، مدينة نصر',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kDark),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kEmeraldGreen,
                      side: const BorderSide(color: kEmeraldGreen, width: 1.2),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('تغيير', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. Feature: DOKAN Wallet Cashback balance apply
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _useDokanWalletBalance ? kEmeraldLight : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _useDokanWalletBalance ? kEmeraldGreen : const Color(0xFFD1FAE5),
                  width: 1.2,
                ),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kEmeraldGreen, width: 1),
                    ),
                    child: const Icon(Icons.account_balance_wallet_outlined, color: kEmeraldGreen, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'رصيد محفظة دكان (Dokan Pay)',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kDark),
                        ),
                        Text(
                          'متاح لديك: ${_walletBalance.toInt()} ج.م كاش باك',
                          style: const TextStyle(fontSize: 11, color: kEmeraldGreen, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _useDokanWalletBalance,
                    activeColor: kEmeraldGreen,
                    onChanged: (val) => setState(() => _useDokanWalletBalance = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // 3. Payment Methods
            const Text(
              'اختر وسيلة الدفع',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kDark),
            ),
            const SizedBox(height: 12),

            _buildPaymentOption(
              index: 0,
              title: 'بطاقة بنكية (فيزا / ماستركارد / ميزة)',
              subtitle: 'دفع آمن وفوري 100%',
              icon: Icons.credit_card_outlined,
            ),
            const SizedBox(height: 10),

            _buildPaymentOption(
              index: 1,
              title: 'محفظة إلكترونية (InstaPay / فودافون كاش)',
              subtitle: 'تحويل لحظي وسريع',
              icon: Icons.phone_android_outlined,
            ),
            const SizedBox(height: 10),

            _buildPaymentOption(
              index: 2,
              title: 'الدفع عند الاستلام (كاش للمندوب)',
              subtitle: 'الدفع نقداً عند باب البيت',
              icon: Icons.payments_outlined,
            ),

            const SizedBox(height: 22),

            // 4. Feature: Tip the Delivery Hero (إكرامية للمندوب)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.volunteer_activism_outlined, color: kEmeraldGreen, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'إكرامية لكابتن التوصيل (اختياري)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'تذهب بالكامل مباشرة إلى كابتن التوصيل تقديراً لجهوده:',
                    style: TextStyle(fontSize: 11, color: kGrey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildTipChip(0, 'بدون'),
                      const SizedBox(width: 8),
                      _buildTipChip(5, '5 ج.م'),
                      const SizedBox(width: 8),
                      _buildTipChip(10, '10 ج.م'),
                      const SizedBox(width: 8),
                      _buildTipChip(15, '15 ج.م'),
                      const SizedBox(width: 8),
                      _buildTipChip(20, '20 ج.م'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('المبلغ المطلوب دفعه', style: TextStyle(fontSize: 13, color: kGrey, fontWeight: FontWeight.w600)),
                  Text(
                    '${_total.toInt()} ج.م',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: kEmeraldGreen),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () async {
                    final user = context.read<AuthService>().currentUser;
                    final cart = context.read<CartService>().cart;
                    final orderId = '${DateTime.now().millisecondsSinceEpoch % 100000}';

                    final restaurantName = cart?.restaurantName.isNotEmpty == true
                        ? cart!.restaurantName
                        : 'شاورما البلد';
                    final restaurantId = cart?.restaurantId.isNotEmpty == true
                        ? cart!.restaurantId
                        : 'rest1';
                    final restaurantAddress = cart?.restaurantAddress ?? 'شارع عباس العقاد، مدينة نصر، القاهرة';
                    final restaurantLat = cart?.restaurantLat ?? 30.0560;
                    final restaurantLng = cart?.restaurantLng ?? 31.3300;

                    final List<OrderItem> items = (cart?.items.isNotEmpty == true)
                        ? cart!.items.map((ci) => OrderItem(
                              productId: ci.product.id,
                              productName: ci.product.name,
                              price: ci.unitPrice,
                              quantity: ci.quantity,
                            )).toList()
                        : [
                            OrderItem(
                              productId: 'p1',
                              productName: 'بيج ماك دوبل فاخر',
                              price: 95.0,
                              quantity: 1,
                            ),
                          ];

                    final newOrder = Order(
                      id: orderId,
                      customerId: user?.id ?? 'c1',
                      customerName: user?.name.isNotEmpty == true ? user!.name : 'أحمد محمد',
                      customerPhone: user?.phone.isNotEmpty == true ? user!.phone : '01011111111',
                      restaurantId: restaurantId,
                      restaurantName: restaurantName,
                      restaurantAddress: restaurantAddress,
                      restaurantLat: restaurantLat,
                      restaurantLng: restaurantLng,
                      items: items,
                      status: OrderStatus.pending,
                      deliveryAddress: const Address(
                        id: 'addr_1',
                        label: 'المنزل',
                        governorate: 'القاهرة',
                        area: 'مدينة نصر',
                        street: 'شارع عباس العقاد',
                        buildingNumber: '15',
                        lat: 30.0444,
                        lng: 31.2357,
                      ),
                      paymentMethod: _selectedPaymentMethod == 0
                          ? 'كارت بنكي'
                          : (_selectedPaymentMethod == 1
                              ? 'محفظة إلكترونية'
                              : (_selectedPaymentMethod == 2
                                  ? 'الدفع عند الاستلام'
                                  : 'محفظة دكان DOKAN Pay')),
                      subtotal: _subtotal,
                      deliveryFee: _deliveryFee,
                      createdAt: DateTime.now(),
                    );

                    await context.read<OrderService>().createOrder(newOrder);
                    if (context.mounted) {
                      context.read<CartService>().clearCart();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderTrackingScreen(orderId: '#$orderId'),
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kEmeraldGreen,
                    side: const BorderSide(color: kEmeraldGreen, width: 2.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('تأكيد الطلب وبدء التحضير ✓', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipChip(int amount, String label) {
    final isSelected = _selectedTip == amount;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTip = amount),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? kEmeraldLight : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? kEmeraldGreen : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? kEmeraldGreen : kDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = index),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? kEmeraldGreen : const Color(0xFFD1FAE5),
            width: isSelected ? 1.8 : 1.1,
          ),
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? kEmeraldGreen : const Color(0xFF94A3B8),
              size: 20,
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: kEmeraldLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: kEmeraldGreen, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: kDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: kGrey),
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
