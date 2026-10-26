import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/features/customer/screens/checkout_screen.dart';

/// Screen 7: Shopping Cart with New Features (Promo Codes, Delivery Timing, Special Notes, Outline Design)
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _appliedCoupon = '';
  double _couponDiscount = 0.0;
  String _deliveryTimePreference = 'الآن (أسرع وقت)';
  bool _includeCutlery = true;

  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': '1',
      'name': 'بيج ماك دوبل',
      'subtitle': 'لحم أنجوس مع صوص سري',
      'price': 95.0,
      'quantity': 1,
      'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200&auto=format&fit=crop&q=80',
    },
    {
      'id': '2',
      'name': 'كشري فاخر كينج',
      'subtitle': 'مع صوص الدقة والصلصة الحارة',
      'price': 45.0,
      'quantity': 1,
      'imageUrl': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200&auto=format&fit=crop&q=80',
    },
    {
      'id': '3',
      'name': 'مشروب غازي مثلج',
      'subtitle': 'علبة كانز 330 مل',
      'price': 15.0,
      'quantity': 2,
      'imageUrl': 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=200&auto=format&fit=crop&q=80',
    },
  ];

  double get subtotal => _cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  double get deliveryFee => 15.0;
  double get total => (subtotal + deliveryFee - _couponDiscount).clamp(0.0, 99999.0);

  @override
  void dispose() {
    _promoController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _promoController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    if (code == 'DOKAN' || code == 'DOKAN20' || code == 'خصم20') {
      setState(() {
        _appliedCoupon = code;
        _couponDiscount = 25.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 تم تطبيق الكوبون ($code) وخصم 25 ج.م!'),
          backgroundColor: kEmeraldGreen,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الكوبون غير صالح. جرب كود: DOKAN20'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('سلة المشتريات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kDark)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kDark, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_cartItems.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => _cartItems.clear()),
              child: const Text('مسح الكل', style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: _cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kEmeraldLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shopping_bag_outlined, size: 54, color: kEmeraldGreen),
                  ),
                  const SizedBox(height: 16),
                  const Text('السلة فارغة حالياً', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: kDark)),
                  const SizedBox(height: 6),
                  const Text('تصفح المطاعم واستمتع بأشهى الوجبات والعروض', style: TextStyle(fontSize: 13, color: kGrey)),
                ],
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Cart Items List Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                      boxShadow: AppShadows.soft,
                    ),
                    padding: const EdgeInsets.all(14),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _cartItems.length,
                      separatorBuilder: (_, __) => const Divider(color: Color(0xFFF1F5F9), height: 20),
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        return Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item['imageUrl'],
                                width: 68,
                                height: 68,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kDark),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['subtitle'],
                                    style: const TextStyle(color: kGrey, fontSize: 11),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${item['price'].toInt()} ج.م',
                                    style: const TextStyle(
                                      color: kEmeraldGreen,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Stepper
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (item['quantity'] > 1) {
                                        setState(() => item['quantity']--);
                                      } else {
                                        setState(() => _cartItems.removeAt(index));
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: kEmeraldLight,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.remove, size: 13, color: kEmeraldGreen),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      '${item['quantity']}',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kDark),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() => item['quantity']++),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: kEmeraldGreen,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.add, size: 13, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 2. Feature: Promo Code Voucher Input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                      boxShadow: AppShadows.soft,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.discount_outlined, color: kEmeraldGreen, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _promoController,
                            decoration: const InputDecoration(
                              hintText: 'أدخل كود الخصم (مثال: DOKAN20)',
                              hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              fillColor: Colors.transparent,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: _applyCoupon,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kEmeraldGreen,
                            side: const BorderSide(color: kEmeraldGreen, width: 1.2),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('تطبيق', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 3. Feature: Delivery Time Slot Selection
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                      boxShadow: AppShadows.soft,
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.schedule_outlined, color: kEmeraldGreen, size: 20),
                            SizedBox(width: 8),
                            Text('وقت التوصيل المفضل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kDark)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildTimeOption('الآن (أسرع وقت)'),
                            const SizedBox(width: 8),
                            _buildTimeOption('بعد ساعة'),
                            const SizedBox(width: 8),
                            _buildTimeOption('تحديد موعد'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 4. Feature: Cutlery & Delivery Notes
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                      boxShadow: AppShadows.soft,
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.flatware_outlined, color: kEmeraldGreen, size: 20),
                                SizedBox(width: 8),
                                Text('أدوات وملاعق بلاستيكية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kDark)),
                              ],
                            ),
                            Switch(
                              value: _includeCutlery,
                              activeColor: kEmeraldGreen,
                              activeTrackColor: kEmeraldLight,
                              onChanged: (val) => setState(() => _includeCutlery = val),
                            ),
                          ],
                        ),
                        const Divider(color: Color(0xFFF1F5F9)),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.note_alt_outlined, color: kEmeraldGreen, size: 20),
                            hintText: 'ملاحظات إضافية للمطعم أو كابتن التوصيل...',
                            hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            fillColor: Colors.transparent,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 5. Bill Summary Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow('المجموع الفرعي', '${subtotal.toInt()} ج.م'),
                        const SizedBox(height: 8),
                        _buildSummaryRow('رسوم التوصيل', '${deliveryFee.toInt()} ج.م'),
                        if (_couponDiscount > 0) ...[
                          const SizedBox(height: 8),
                          _buildSummaryRow('خصم الكوبون ($_appliedCoupon)', '-${_couponDiscount.toInt()} ج.م', isDiscount: true),
                        ],
                        const Divider(height: 22, color: Color(0xFFE2E8F0)),
                        _buildSummaryRow('المبلغ الإجمالي', '${total.toInt()} ج.م', isTotal: true),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: kEmeraldGreen,
                              side: const BorderSide(color: kEmeraldGreen, width: 2.0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('متابعة إلى تفاصيل الدفع ←', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
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

  Widget _buildTimeOption(String label) {
    final isSelected = _deliveryTimePreference == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _deliveryTimePreference = label),
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

  Widget _buildSummaryRow(String title, String val, {bool isDiscount = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 15 : 12,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? kDark : kGrey,
          ),
        ),
        Text(
          val,
          style: TextStyle(
            fontSize: isTotal ? 17 : 13,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
            color: isDiscount ? Colors.redAccent : (isTotal ? kEmeraldGreen : kDark),
          ),
        ),
      ],
    );
  }
}
