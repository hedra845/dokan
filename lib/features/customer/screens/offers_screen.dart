import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/features/customer/screens/product_detail_screen.dart';

/// Screen 16: Offers and Promotions matching Reference Image Screen 16
class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('العروض', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: kDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Discount Banner: خصومات حصرية تصل إلى 50%
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: kEmeraldGreen,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [kEmeraldGreen.withOpacity(0.92), Colors.transparent],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'خصومات حصرية\nتصل إلى 50%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'تسوق الآن',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kEmeraldGreen),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Section 1: عروض اليوم على المطاعم والبقالة
            const Text(
              'عروض اليوم على المطاعم والبقالة',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kDark),
            ),
            const SizedBox(height: 12),

            // Horizontal offers list
            SizedBox(
              height: 175,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildDealCard(
                    context,
                    title: 'بيتزا هت',
                    deal: 'خصم 40 ج.م',
                    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
                  ),
                  const SizedBox(width: 14),
                  _buildDealCard(
                    context,
                    title: 'كشري التحرير',
                    deal: 'توصيل مجاني',
                    imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
                  ),
                  const SizedBox(width: 14),
                  _buildDealCard(
                    context,
                    title: 'برجر كينج',
                    deal: 'خصم 25%',
                    imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 2: العروض الخاصة
            const Text(
              'العروض الخاصة',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kDark),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildSpecialOfferCard(
                    context,
                    title: 'وجبات عائلية',
                    discount: 'وفر 35%',
                    imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildSpecialOfferCard(
                    context,
                    title: 'عروض السوبر ماركت',
                    discount: 'خصم حتى 50%',
                    imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealCard(BuildContext context, {required String title, required String deal, required String imageUrl}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(name: title, price: 95.0, imageUrl: imageUrl),
          ),
        );
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.network(
                imageUrl,
                height: 95,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kDark),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    deal,
                    style: const TextStyle(color: kEmeraldGreen, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialOfferCard(BuildContext context, {required String title, required String discount, required String imageUrl}) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.75), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              discount,
              style: const TextStyle(color: kDiscountYellow, fontWeight: FontWeight.bold, fontSize: 11),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
