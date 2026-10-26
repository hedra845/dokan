import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/features/customer/screens/product_detail_screen.dart';
import 'package:flutter_application_5/features/customer/screens/cart_screen.dart';

/// Screen 5: Restaurant Details & Menu (Professional Dokan Theme)
class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final String imageUrl;
  final double rating;
  final String cuisine;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
    required this.imageUrl,
    this.rating = 4.6,
    this.cuisine = 'برجر • وجبات سريعة • مشروبات',
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;

  final List<Map<String, dynamic>> _burgerMeals = [
    {
      'id': 'p1',
      'name': 'بيج ماك دوبل فاخر',
      'description': 'قطعتين لحم بقري أنجوس مشوي، صوص خاص، خس، طماطم، بصل، جبنة شيدر.',
      'price': 95.0,
      'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&auto=format&fit=crop&q=80',
    },
    {
      'id': 'p2',
      'name': 'تشكن كرسبي برجر',
      'description': 'صدور دجاج كرسبي مقرمشة، صوص رانش، خس، مايونيز، خبز بالسمسم.',
      'price': 85.0,
      'imageUrl': 'https://images.unsplash.com/photo-1521305916504-4a1121188589?w=400&auto=format&fit=crop&q=80',
    },
    {
      'id': 'p3',
      'name': 'سموك هاوس تشيز برجر',
      'description': 'شريحة لحم مشوية مع صوص باربكيو مدخن، جبنة شيدر، بصل مكرمل وخيار مخلل.',
      'price': 110.0,
      'imageUrl': 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=400&auto=format&fit=crop&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 220,
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
                            Colors.white.withValues(alpha: 0.85),
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
          ];
        },
        body: Column(
          children: [
            // Restaurant Info Header Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                  boxShadow: AppShadows.soft,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.restaurantName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.cuisine,
                              style: const TextStyle(fontSize: 12, color: kGrey),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: kEmeraldLight,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFD1FAE5)),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${widget.rating}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kEmeraldGreen),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.star_rounded, color: kEmeraldGreen, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFFF1F5F9), height: 1),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.delivery_dining, size: 16, color: kEmeraldGreen),
                            SizedBox(width: 4),
                            Text('توصيل 15 ج.م', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kDark)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 14, color: kGrey),
                            SizedBox(width: 4),
                            Text('25-35 دقيقة', style: TextStyle(fontSize: 11, color: kDark)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.verified_outlined, size: 14, color: kEmeraldGreen),
                            SizedBox(width: 4),
                            Text('مطعم معتمد', style: TextStyle(fontSize: 11, color: kEmeraldGreen, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Tab Bar: قائمة الطعام، العروض، التقييمات
            TabBar(
              controller: _tabController,
              labelColor: kEmeraldGreen,
              unselectedLabelColor: kGrey,
              indicatorColor: kEmeraldGreen,
              indicatorWeight: 2.5,
              tabs: const [
                Tab(text: 'قائمة الوجبات'),
                Tab(text: 'العروض الترويجية'),
                Tab(text: 'تقييمات الزبائن'),
              ],
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMealsList(),
                  const Center(child: Text('لا توجد عروض إضافية اليوم', style: TextStyle(color: kGrey))),
                  const Center(child: Text('التقييم العام 4.8 من 500+ عميل', style: TextStyle(color: kGrey))),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
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
            height: 50,
            child: OutlinedButton(
              onPressed: () {
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 20),
                  SizedBox(width: 8),
                  Text('عرض سلة المشتريات ←', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: _burgerMeals.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final meal = _burgerMeals[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(
                  name: meal['name'],
                  price: meal['price'],
                  imageUrl: meal['imageUrl'],
                  description: meal['description'],
                  restaurantId: widget.restaurantId,
                  restaurantName: widget.restaurantName,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    meal['imageUrl'],
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal['name'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: kDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meal['description'],
                        style: const TextStyle(fontSize: 11, color: kGrey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${meal['price']} ج.م',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: kEmeraldGreen,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: kEmeraldLight,
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFD1FAE5)),
                            ),
                            child: const Icon(Icons.add, color: kEmeraldGreen, size: 16),
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
    );
  }
}
