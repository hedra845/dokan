import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/features/customer/screens/restaurant_detail_screen.dart';

/// Screen 4: Restaurant Listing matching Unified Dokan Brand Design
class RestaurantListingScreen extends StatefulWidget {
  const RestaurantListingScreen({super.key});

  @override
  State<RestaurantListingScreen> createState() => _RestaurantListingScreenState();
}

class _RestaurantListingScreenState extends State<RestaurantListingScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['الأقرب', 'التقييم', 'أقل سعر', 'خصم'];

  final List<Map<String, dynamic>> _restaurants = [
    {
      'id': '1',
      'name': 'ماكدونالدز',
      'rating': '4.6',
      'badge': 'مميز • برجر ووجبات سريعة',
      'deliveryTime': '30-40 دقيقة',
      'deliveryFee': '20 ج.م',
      'discount': '20% خصم',
      'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&auto=format&fit=crop&q=80',
    },
    {
      'id': '2',
      'name': 'KFC',
      'rating': '4.4',
      'badge': 'مميز • دجاج مقرمش',
      'deliveryTime': '35-45 دقيقة',
      'deliveryFee': '25 ج.م',
      'discount': '15% خصم',
      'imageUrl': 'https://images.unsplash.com/photo-1513639776629-7b61b0ac49cb?w=500&auto=format&fit=crop&q=80',
    },
    {
      'id': '3',
      'name': 'بيتزا هت',
      'rating': '4.5',
      'badge': 'شائع • بيتزا إيطالية',
      'deliveryTime': '40-60 دقيقة',
      'deliveryFee': '25 ج.م',
      'discount': '25% خصم',
      'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&auto=format&fit=crop&q=80',
    },
    {
      'id': '4',
      'name': 'كشري التحرير',
      'rating': '4.7',
      'badge': 'مفتوح • أكلات مصرية',
      'deliveryTime': '25-40 دقيقة',
      'deliveryFee': '15 ج.م',
      'discount': 'عرض اليوم',
      'imageUrl': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&auto=format&fit=crop&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'المطاعم',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kDark),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kDark, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: kDark),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                for (int index = 0; index < _filters.length; index++)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilter = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: _selectedFilter == index ? kEmeraldGreen : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedFilter == index ? kEmeraldGreen : const Color(0xFFE2E8F0),
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          _filters[index],
                          style: TextStyle(
                            color: _selectedFilter == index ? Colors.white : kDark,
                            fontSize: 12,
                            fontWeight: _selectedFilter == index ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Restaurant List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: _restaurants.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, i) {
                final r = _restaurants[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RestaurantDetailScreen(
                          restaurantId: r['id'],
                          restaurantName: r['name'],
                          imageUrl: r['imageUrl'],
                          rating: double.parse(r['rating']),
                          cuisine: r['badge'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                      boxShadow: AppShadows.soft,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Image with discount badge
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                r['imageUrl'],
                                width: 95,
                                height: 85,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (r['discount'].toString().isNotEmpty)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDE59),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    r['discount'],
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(width: 14),

                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    r['name'],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: kDark,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        r['rating'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: kDark,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      const Icon(Icons.star, color: kStarYellow, size: 14),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                r['badge'],
                                style: const TextStyle(fontSize: 11, color: kGrey),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time, size: 13, color: kGrey),
                                      const SizedBox(width: 4),
                                      Text(
                                        r['deliveryTime'],
                                        style: const TextStyle(fontSize: 11, color: kGrey),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.delivery_dining, size: 14, color: kEmeraldGreen),
                                      const SizedBox(width: 4),
                                      Text(
                                        r['deliveryFee'],
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kEmeraldGreen),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
