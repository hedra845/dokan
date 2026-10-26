import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/features/customer/screens/restaurant_detail_screen.dart';
import 'package:flutter_application_5/features/customer/screens/restaurant_listing_screen.dart';

/// Screen 13: Enhanced Dokan Favorites Screen
class CustomerFavoritesScreen extends StatefulWidget {
  const CustomerFavoritesScreen({super.key});

  @override
  State<CustomerFavoritesScreen> createState() => _CustomerFavoritesScreenState();
}

class _CustomerFavoritesScreenState extends State<CustomerFavoritesScreen> {
  final List<Map<String, dynamic>> _favorites = [
    {
      'id': '1',
      'name': 'شاورما البلد',
      'category': 'شاورما • مشويات مصرية',
      'rating': '4.8',
      'deliveryTime': '20-30 دقيقة',
      'deliveryFee': 'مجاناً',
      'imageUrl': 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=300',
    },
    {
      'id': '2',
      'name': 'كشري التحرير',
      'category': 'كشري • أطباق شعبية',
      'rating': '4.7',
      'deliveryTime': '25-35 دقيقة',
      'deliveryFee': '15 ج.م',
      'imageUrl': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300',
    },
    {
      'id': '3',
      'name': 'بيتزا روما الإيطالية',
      'category': 'بيتزا • معجنات وحلويات',
      'rating': '4.9',
      'deliveryTime': '30-45 دقيقة',
      'deliveryFee': 'مجاناً',
      'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('المفضلة ❤️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kDark)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_favorites.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() => _favorites.clear());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم مسح جميع العناصر من المفضلة'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('مسح الكل', style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: _favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: kEmeraldLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border_rounded, size: 54, color: kEmeraldGreen),
                  ),
                  const SizedBox(height: 18),
                  const Text('قائمة المفضلة فارغة', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: kDark)),
                  const SizedBox(height: 8),
                  const Text('اضغط على علامة القلب في أي مطعم لإضافته هنا', style: TextStyle(fontSize: 13, color: kGrey)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RestaurantListingScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kEmeraldGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('استكشف المطاعم الآن', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: _favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = _favorites[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RestaurantDetailScreen(
                          restaurantId: item['id']!,
                          restaurantName: item['name']!,
                          imageUrl: item['imageUrl']!,
                          rating: double.parse(item['rating']!),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item['imageUrl']!,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name']!,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: kDark),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['category'] ?? '',
                                style: const TextStyle(fontSize: 11, color: Color(0xFF8A92A0)),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: kEmeraldLight,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item['rating']!,
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kEmeraldGreen),
                                        ),
                                        const SizedBox(width: 2),
                                        const Icon(Icons.star, color: kEmeraldGreen, size: 10),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.access_time, size: 12, color: Color(0xFF8A92A0)),
                                  const SizedBox(width: 3),
                                  Text(
                                    item['deliveryTime']!,
                                    style: const TextStyle(fontSize: 10, color: Color(0xFF8A92A0)),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item['deliveryFee'] ?? '',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kEmeraldGreen),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.redAccent, size: 24),
                          onPressed: () {
                            final removed = _favorites[index];
                            setState(() => _favorites.removeAt(index));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('تمت إزالة "${removed['name']}" من المفضلة'),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'تراجع',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    setState(() => _favorites.insert(index, removed));
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
