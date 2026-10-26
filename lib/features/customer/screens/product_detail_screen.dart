import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/features/customer/screens/cart_screen.dart';
import 'package:flutter_application_5/services/cart_service.dart';
import 'package:flutter_application_5/models/product.dart';

/// Screen 6: High-Fidelity Professional Product Details Screen (Unified Dokan Design)
class ProductDetailScreen extends StatefulWidget {
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String restaurantId;
  final String restaurantName;
  final String restaurantAddress;
  final double restaurantLat;
  final double restaurantLng;

  const ProductDetailScreen({
    super.key,
    this.name = 'بيج ماك دوبل فاخر',
    this.price = 95.0,
    this.imageUrl = 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80',
    this.description = 'قطعتين لحم أنجوس مشوي على اللهب، صوص سري خاص، خس مقرمش، طماطم، جبنة شيدر مذابة وخبز بالسمسم الطازج.',
    this.restaurantId = 'rest1',
    this.restaurantName = 'شاورما البلد',
    this.restaurantAddress = 'شارع عباس العقاد، مدينة نصر، القاهرة',
    this.restaurantLat = 30.0560,
    this.restaurantLng = 31.3300,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isFavorite = false;
  int _selectedSize = 1; // 0: صغير, 1: وسط, 2: كبير

  // Addons
  bool _addFries = false;
  bool _addSoda = false;
  bool _addExtraCheese = false;

  final TextEditingController _specialInstructionsController = TextEditingController();

  @override
  void dispose() {
    _specialInstructionsController.dispose();
    super.dispose();
  }

  double get _sizeMultiplier {
    if (_selectedSize == 0) return 0.85;
    if (_selectedSize == 2) return 1.25;
    return 1.0;
  }

  double get _totalPrice {
    double itemPrice = widget.price * _sizeMultiplier;
    if (_addFries) itemPrice += 15.0;
    if (_addSoda) itemPrice += 10.0;
    if (_addExtraCheese) itemPrice += 12.0;
    return itemPrice * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Sliver App Bar with Hero Image & Actions
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                boxShadow: AppShadows.soft,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: kDark, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                  boxShadow: AppShadows.soft,
                ),
                child: IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.redAccent : kDark,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _isFavorite = !_isFavorite),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.9),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Product Details Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: kDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: kEmeraldLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFD1FAE5)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.star_rounded, color: kEmeraldGreen, size: 16),
                            SizedBox(width: 4),
                            Text('4.8', style: TextStyle(fontWeight: FontWeight.bold, color: kEmeraldGreen, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: kGrey,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Price & Quantity Selector Row
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('السعر الفردي', style: TextStyle(fontSize: 11, color: kGrey)),
                            Text(
                              '${(widget.price * _sizeMultiplier).toInt()} ج.م',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: kEmeraldGreen,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_quantity > 1) {
                                    setState(() => _quantity--);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: kEmeraldLight,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.remove, size: 14, color: kEmeraldGreen),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  '$_quantity',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kDark),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _quantity++),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: kEmeraldGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.add, size: 14, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Size selection: صغير، وسط، كبير
                  const Text('اختر الحجم', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kDark)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSizeOption(0, 'صغير (Single)'),
                      const SizedBox(width: 8),
                      _buildSizeOption(1, 'وسط (Medium)'),
                      const SizedBox(width: 8),
                      _buildSizeOption(2, 'كبير (Double)'),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // Add-ons Section
                  const Text(
                    'إضافات اختيارية شهية',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kDark),
                  ),
                  const SizedBox(height: 10),

                  _buildAddonOption(
                    title: 'بطاطس مقلية كرسبي مقرمشة',
                    price: '+15 ج.م',
                    value: _addFries,
                    onChanged: (val) => setState(() => _addFries = val ?? false),
                    icon: Icons.fastfood_outlined,
                  ),
                  const SizedBox(height: 8),

                  _buildAddonOption(
                    title: 'مشروب غازي مثلج (كانز 330 مل)',
                    price: '+10 ج.م',
                    value: _addSoda,
                    onChanged: (val) => setState(() => _addSoda = val ?? false),
                    icon: Icons.local_drink_outlined,
                  ),
                  const SizedBox(height: 8),

                  _buildAddonOption(
                    title: 'إضافة جبنة شيدر مذابة إضافية',
                    price: '+12 ج.م',
                    value: _addExtraCheese,
                    onChanged: (val) => setState(() => _addExtraCheese = val ?? false),
                    icon: Icons.lunch_dining_outlined,
                  ),

                  const SizedBox(height: 20),

                  // Special Instructions
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                      boxShadow: AppShadows.soft,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: TextField(
                      controller: _specialInstructionsController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.edit_note_rounded, color: kEmeraldGreen),
                        hintText: 'ملاحظات خاصة (مثلاً: بدون بصل، كاتشب إضافي)...',
                        hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16.0),
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
          child: SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: () {
                context.read<CartService>().addItem(
                  Product(
                    id: widget.name.hashCode.toString(),
                    restaurantId: widget.restaurantId,
                    categoryId: 'cat_food',
                    category: 'وجبات',
                    name: widget.name,
                    description: widget.description,
                    price: widget.price * _sizeMultiplier,
                    imageUrl: widget.imageUrl,
                  ),
                  restaurantName: widget.restaurantName,
                  restaurantAddress: widget.restaurantAddress,
                  restaurantLat: widget.restaurantLat,
                  restaurantLng: widget.restaurantLng,
                  quantity: _quantity,
                  notes: _specialInstructionsController.text.trim(),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تمت إضافة ${widget.name} بنجاح إلى السلة! 🛒'),
                    backgroundColor: kEmeraldGreen,
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: kEmeraldGreen,
                side: const BorderSide(color: kEmeraldGreen, width: 2.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_shopping_cart, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'أضف إلى السلة (${_totalPrice.toInt()} ج.م)',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSizeOption(int index, String label) {
    final isSelected = _selectedSize == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSize = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? kEmeraldLight : Colors.white,
            borderRadius: BorderRadius.circular(12),
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

  Widget _buildAddonOption({
    required String title,
    required String price,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: value ? kEmeraldLight : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: value ? kEmeraldGreen : const Color(0xFFD1FAE5),
          width: value ? 1.4 : 1.1,
        ),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kDark)),
        secondary: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: kEmeraldGreen, size: 18),
            const SizedBox(width: 6),
            Text(price, style: const TextStyle(color: kEmeraldGreen, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        activeColor: kEmeraldGreen,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }
}
