import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/features/customer/screens/product_detail_screen.dart';
import 'package:flutter_application_5/features/customer/screens/cart_screen.dart';
import 'package:flutter_application_5/services/cart_service.dart';
import 'package:flutter_application_5/models/product.dart';

/// Screen: Category Products with custom subcategories & distinct layout per category
class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;
  final String categoryIcon;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
    this.categoryIcon = '🛒',
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  int _selectedSubcategoryIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Dynamic subcategories and products mapped specifically by Category Name
  Map<String, dynamic> get _categoryData {
    switch (widget.categoryName) {
      case 'خضار وفواكه':
        return {
          'banner': 'https://images.unsplash.com/photo-1610348725531-843dff563e2c?w=600',
          'subcategories': ['الكل', '🍎 فواكه طازجة', '🥦 خضروات ورقية', '🥔 بطاطس وبصل', '🍓 فواكه موسمية'],
          'items': [
            {
              'name': 'طماطم بلدي طازجة',
              'unit': '1 كجم',
              'price': 15.0,
              'oldPrice': '20.0',
              'tag': 'طازج اليوم',
              'image': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400',
              'sub': '🥦 خضروات ورقية',
              'desc': 'طماطم فرز أول قطفة طازجة للمائدة والسلطة اليومية.',
            },
            {
              'name': 'خيار بلدي مقرمش',
              'unit': '1 كجم',
              'price': 18.0,
              'oldPrice': '22.0',
              'tag': 'عضوي',
              'image': 'https://images.unsplash.com/photo-1604977042946-1eecc30f269e?w=400',
              'sub': '🥦 خضروات ورقية',
              'desc': 'خيار بلدي طازج ومقرمش خالي من المبيدات.',
            },
            {
              'name': 'تفاح سكري أحمر إيطالي',
              'unit': '1 كجم',
              'price': 55.0,
              'oldPrice': '65.0',
              'tag': 'خصم 15%',
              'image': 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400',
              'sub': '🍎 فواكه طازجة',
              'desc': 'تفاح سكري حلو المذاق وغني بالفيتامينات والمعادن.',
            },
            {
              'name': 'موز بلدي فاخر',
              'unit': '1 كجم',
              'price': 22.0,
              'oldPrice': '26.0',
              'tag': 'الأكثر طلباً',
              'image': 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400',
              'sub': '🍎 فواكه طازجة',
              'desc': 'موز طازج غني بالبوتاسيوم والطاقة.',
            },
            {
              'name': 'بطاطس تحمير سيلانا',
              'unit': '2 كجم',
              'price': 35.0,
              'oldPrice': '42.0',
              'tag': 'توفير',
              'image': 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400',
              'sub': '🥔 بطاطس وبصل',
              'desc': 'بطاطس خاصة بالتحمير والقلي لقرمشة تدوم.',
            },
            {
              'name': 'فراولة بلدي سكرية',
              'unit': 'طبق 500 جم',
              'price': 28.0,
              'oldPrice': '35.0',
              'tag': 'موسمية',
              'image': 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400',
              'sub': '🍓 فواكه موسمية',
              'desc': 'فراولة طازجة ولذيذة جاهزة للأكل والعصائر.',
            },
          ]
        };

      case 'مشروبات وعصائر':
        return {
          'banner': 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=600',
          'subcategories': ['الكل', '🧃 عصائر طبيعية', '🥤 مشروبات غازية', '💧 مياه شرب', '☕ قهوة ومشروبات ساخنة'],
          'items': [
            {
              'name': 'مياه شرب نقي 600 مل',
              'unit': 'زجاجة مفردة',
              'price': 6.0,
              'oldPrice': '8.0',
              'tag': 'الأكثر طلباً',
              'image': 'https://images.unsplash.com/photo-1548839140-29a749e1bc4e?w=400',
              'sub': '💧 مياه شرب',
              'desc': 'مياه معدنية نقية مفلترة بأعلى معايير الجودة العالمية.',
            },
            {
              'name': 'كرتونة مياه 20 زجاجة',
              'unit': '20 × 600 مل',
              'price': 95.0,
              'oldPrice': '120.0',
              'tag': 'عرض التوفير',
              'image': 'https://images.unsplash.com/photo-1523362628745-0c100150b504?w=400',
              'sub': '💧 مياه شرب',
              'desc': 'عرض العائلة كرتونة مياه موفرة بأفضل سعر.',
            },
            {
              'name': 'عصير برتقال فريش 100%',
              'unit': '1 لتر',
              'price': 32.0,
              'oldPrice': '40.0',
              'tag': 'طازج',
              'image': 'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=400',
              'sub': '🧃 عصائر طبيعية',
              'desc': 'عصير برتقال طبيعي معصور يومياً بدون سكر مضاف.',
            },
            {
              'name': 'كوكاكولا كانز مثلج 330 مل',
              'unit': 'علبة واحدة',
              'price': 15.0,
              'oldPrice': '18.0',
              'tag': 'مثلج',
              'image': 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=400',
              'sub': '🥤 مشروبات غازية',
              'desc': 'المشروب الغازي الأشهر عالمياً يقدم مثلجاً.',
            },
            {
              'name': 'عصير مانجو كينج بالقطع',
              'unit': 'لتر عائلي',
              'price': 38.0,
              'oldPrice': '45.0',
              'tag': 'مميز',
              'image': 'https://images.unsplash.com/photo-1546173159-315724a31696?w=400',
              'sub': '🧃 عصائر طبيعية',
              'desc': 'عصير مانجو مركز ولذيذ بقطع المانجو الحقيقية.',
            },
          ]
        };

      case 'لحوم ودواجن':
        return {
          'banner': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600',
          'subcategories': ['الكل', '🥩 لحوم بقري طازجة', '🍗 دواجن طازجة', '🥓 مصنعات ومفروم', '🍖 كفتة وتتبيلات'],
          'items': [
            {
              'name': 'لحم بقري كندوز بلدي',
              'unit': '1 كجم',
              'price': 380.0,
              'oldPrice': '420.0',
              'tag': 'ذبح اليوم',
              'image': 'https://images.unsplash.com/photo-1603048588665-791ca8aea617?w=400',
              'sub': '🥩 لحوم بقري طازجة',
              'desc': 'لحم بقري بلدي طازج ومختوم وصحي 100%.',
            },
            {
              'name': 'صدور بانيه دجاج طازجة',
              'unit': '1 كجم',
              'price': 185.0,
              'oldPrice': '210.0',
              'tag': 'الأكثر طلباً',
              'image': 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=400',
              'sub': '🍗 دواجن طازجة',
              'desc': 'صدور دجاج مخلية ونظيفة تماماً ومجهزة للطهي.',
            },
            {
              'name': 'لحم مفروم بلدي قليل الدسم',
              'unit': '1 كجم',
              'price': 360.0,
              'oldPrice': '390.0',
              'tag': 'فرز أول',
              'image': 'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=400',
              'sub': '🥓 مصنعات ومفروم',
              'desc': 'مفروم كندوز طازج ومثالي للحواوشي والمكرونة بشاميل والكفتة.',
            },
            {
              'name': 'كفتة حاتي متبلة جاهزة للشوي',
              'unit': 'طبق 800 جم',
              'price': 220.0,
              'oldPrice': '250.0',
              'tag': 'خلطة سرية',
              'image': 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400',
              'sub': '🍖 كفتة وتتبيلات',
              'desc': 'كفتة مشوية على الفحم متبلة بأعشاب وتوابل الحاتي الشهيرة.',
            },
          ]
        };

      case 'حلويات':
        return {
          'banner': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600',
          'subcategories': ['الكل', '🧁 حلويات شرقية', '🎂 تورت وجاتوه', '🍩 دوناتس وكوكيز', '🍨 أيس كريم'],
          'items': [
            {
              'name': 'صينية بسبوسة بالمكسرات والسمن البلدي',
              'unit': 'كيلو مشكل',
              'price': 140.0,
              'oldPrice': '170.0',
              'tag': 'سمن بلدي',
              'image': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400',
              'sub': '🧁 حلويات شرقية',
              'desc': 'بسبوسة مصرية دايبة بالسمن البلدي واللوز المحمص.',
            },
            {
              'name': 'تورتة شوكولاتة نوتيلا فاخرة',
              'unit': 'مقاس 24 سم',
              'price': 260.0,
              'oldPrice': '320.0',
              'tag': 'حفلات',
              'image': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
              'sub': '🎂 تورت وجاتوه',
              'desc': 'طبقات كيك الشوكولاتة الهشة محشوة كريمة البندق والنوتيلا.',
            },
            {
              'name': 'بوكس دوناتس ميكس 6 قطع',
              'unit': '6 قطع نكهات',
              'price': 110.0,
              'oldPrice': '135.0',
              'tag': 'عرض خاص',
              'image': 'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?w=400',
              'sub': '🍩 دوناتس وكوكيز',
              'desc': 'تشكيلة دوناتس طازجة نوتيلا، كيندر، لوتس، وفراولة.',
            },
            {
              'name': 'كنافة نابلسية بالجبنة السايحة',
              'unit': 'طبق نصف كيلو',
              'price': 95.0,
              'oldPrice': '115.0',
              'tag': 'ساخنة',
              'image': 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=400',
              'sub': '🧁 حلويات شرقية',
              'desc': 'كنافة شعر حمراء مقرمشة محشوة بجبنة عكاوي مطاطية ولذيذة.',
            },
          ]
        };

      case 'معلبات ومؤن':
      case 'سوبر ماركت':
      case 'بقالة':
      default:
        return {
          'banner': 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600',
          'subcategories': ['الكل', '🥫 معلبات وصلصة', '🍚 أرز وزيوت ومكرونة', '🧀 ألبان وأجبان', '🍳 بيض ومخبوزات'],
          'items': [
            {
              'name': 'أرز مصري عريض الحبة كيس 5 كجم',
              'unit': '5 كجم',
              'price': 145.0,
              'oldPrice': '170.0',
              'tag': 'عرض الأسبوع',
              'image': 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
              'sub': '🍚 أرز وزيوت ومكرونة',
              'desc': 'أرز مصري ممتاز أبيض ومغسول ومعبأ آلياً.',
            },
            {
              'name': 'زيت عباد شمس نقي 1.6 لتر',
              'unit': '1.6 لتر',
              'price': 88.0,
              'oldPrice': '105.0',
              'tag': 'توفير',
              'image': 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',
              'sub': '🍚 أرز وزيوت ومكرونة',
              'desc': 'زيت طعام صحي مكرر ومثالي للطبخ والقلي الخفيف.',
            },
            {
              'name': 'جبنة بيضاء فيتا فاخرة',
              'unit': 'علبة 500 جم',
              'price': 42.0,
              'oldPrice': '50.0',
              'tag': 'طازج',
              'image': 'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=400',
              'sub': '🧀 ألبان وأجبان',
              'desc': 'جبنة طبيعية كريمية غنية بالكالسيوم للفطور والعشاء.',
            },
            {
              'name': 'علبة تونة قطع في زيت الزيتون',
              'unit': '185 جم',
              'price': 38.0,
              'oldPrice': '48.0',
              'tag': 'خصم 20%',
              'image': 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=400',
              'sub': '🥫 معلبات وصلصة',
              'desc': 'تونة فاخرة لحم أبيض صافي في زيت الزيتون البكر.',
            },
            {
              'name': 'صلصة طماطم بيوريه برطمان 360 جم',
              'unit': 'برطمان زجاج',
              'price': 22.0,
              'oldPrice': '28.0',
              'tag': 'مركز',
              'image': 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=400',
              'sub': '🥫 معلبات وصلصة',
              'desc': 'معجون طماطم طبيعي مائة بالمائة بدون مواد حافظة.',
            },
          ]
        };
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = _categoryData;
    final List<String> subcategories = List<String>.from(data['subcategories'] as List);
    final List<Map<String, dynamic>> allItems = List<Map<String, dynamic>>.from(data['items'] as List);

    final selectedSubcategory = subcategories[_selectedSubcategoryIndex];

    final filteredItems = allItems.where((item) {
      final matchesSub = _selectedSubcategoryIndex == 0 || item['sub'] == selectedSubcategory;
      final matchesSearch = _searchQuery.isEmpty ||
          (item['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (item['desc'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSub && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kDark),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kDark, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<CartService>(
            builder: (context, cart, _) => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined, color: kDark),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  ),
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: kEmeraldGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar for Products inside this Category
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val.trim()),
                      decoration: InputDecoration(
                        hintText: 'ابحث عن صنف في ${widget.categoryName}...',
                        hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 16, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    ),
                ],
              ),
            ),
          ),

          // 2. Subcategory Filter Chips Row
          SizedBox(
            height: 42,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: subcategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final isSelected = _selectedSubcategoryIndex == idx;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSubcategoryIndex = idx),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? kEmeraldGreen : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? kEmeraldGreen : const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: kEmeraldGreen.withAlpha(50),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Text(
                      subcategories[idx],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // 3. Products Grid View
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: kEmeraldLight, shape: BoxShape.circle),
                          child: const Icon(Icons.search_off_rounded, size: 40, color: kEmeraldGreen),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'لا توجد منتجات مطابقة لهذا القسم حالياً',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kDark),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, i) {
                      final item = filteredItems[i];
                      final price = item['price'] as double;
                      final oldPrice = item['oldPrice'] as String;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(
                                name: item['name'] as String,
                                price: price,
                                imageUrl: item['image'] as String,
                                description: item['desc'] as String,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image with Tag
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                                    child: Image.network(
                                      item['image'] as String,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if ((item['tag'] as String).isNotEmpty)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFDE59),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item['tag'] as String,
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

                              // Product Details
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name'] as String,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: kDark,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item['unit'] as String,
                                            style: const TextStyle(fontSize: 10, color: kGrey),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${price.toInt()} ج.م',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                  color: kEmeraldGreen,
                                                ),
                                              ),
                                              Text(
                                                '$oldPrice ج.م',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFF9AA2B1),
                                                  decoration: TextDecoration.lineThrough,
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              context.read<CartService>().addItem(
                                                Product(
                                                  id: (item['name'] as String).hashCode.toString(),
                                                  restaurantId: 'cat_store',
                                                  categoryId: widget.categoryName,
                                                  category: widget.categoryName,
                                                  name: item['name'] as String,
                                                  description: item['desc'] as String,
                                                  price: price,
                                                  imageUrl: item['image'] as String,
                                                ),
                                                restaurantName: 'دكان ماركت',
                                                quantity: 1,
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('تمت إضافة ${item['name']} إلى السلة 🛒'),
                                                  duration: const Duration(seconds: 2),
                                                  backgroundColor: kEmeraldGreen,
                                                  action: SnackBarAction(
                                                    label: 'السلة',
                                                    textColor: Colors.white,
                                                    onPressed: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (_) => const CartScreen()),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(7),
                                              decoration: BoxDecoration(
                                                color: kEmeraldGreen,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
