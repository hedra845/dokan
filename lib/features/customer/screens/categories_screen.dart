import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/features/customer/screens/category_products_screen.dart';

/// Screen 14: Grocery & Supermarket Categories (Unified Dokan Styling)
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'خضار وفواكه', 'icon': Icons.eco_outlined, 'count': '120+ صنف'},
      {'name': 'مشروبات وعصائر', 'icon': Icons.local_drink_outlined, 'count': '85+ صنف'},
      {'name': 'لحوم ودواجن', 'icon': Icons.kebab_dining_outlined, 'count': 'طازجة يومياً'},
      {'name': 'حلويات', 'icon': Icons.cake_outlined, 'count': 'حلويات وتورت'},
      {'name': 'معلبات ومؤن', 'icon': Icons.inventory_2_outlined, 'count': '210+ صنف'},
      {'name': 'مستلزمات البيت', 'icon': Icons.home_outlined, 'count': '500+ صنف'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('الأقسام والبقالة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kDark)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Grid of categories
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.15,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryProductsScreen(
                          categoryName: cat['name'] as String,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                      boxShadow: AppShadows.soft,
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: kEmeraldLight,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(cat['icon'] as IconData, color: kEmeraldGreen, size: 22),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, color: kGrey, size: 14),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat['name'] as String,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kDark),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cat['count'] as String,
                              style: const TextStyle(fontSize: 11, color: kGrey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Banner: "كل احتياجاتك بأسعار مميزة"
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1542838132-92c53300491e?w=500'),
                  fit: BoxFit.cover,
                ),
                boxShadow: AppShadows.button,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      kEmeraldDark.withValues(alpha: 0.95),
                      kEmeraldGreen.withValues(alpha: 0.5),
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('توصيل سريع 🛵', style: TextStyle(color: kEmeraldGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'كل احتياجاتك ومقاضيك\nبأفضل جودة لباب بيتك',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
