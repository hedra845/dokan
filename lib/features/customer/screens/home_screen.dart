import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application_5/models/restaurant.dart';
import 'package:flutter_application_5/services/auth_service.dart';
import 'package:flutter_application_5/features/customer/screens/restaurant_detail_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';
  Timer? _debounce;

  final Set<String> _favoriteIds = {};

  List<Map<String, dynamic>> _cuisines = [];
  bool _isLoadingCuisines = false;
  String? _cuisinesError;

  List<Restaurant> _restaurants = [];
  bool _isLoadingRestaurants = false;
  bool _isLoadingMoreRestaurants = false;
  String? _restaurantsError;
  int _currentPage = 1;
  bool _hasMoreRestaurants = true;
  int _totalRestaurants = 0;

  String _sortBy = 'relevance';
  double? _minRating;
  bool _openNowOnly = false;

  double? _currentLat;
  double? _currentLng;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadCuisines();
    _detectLocation();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 200 &&
        !_isLoadingMoreRestaurants &&
        _hasMoreRestaurants &&
        _restaurants.isNotEmpty) {
      _loadMoreRestaurants();
    }
  }

  Future<void> _detectLocation() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يرجى تفعيل خدمة الموقع (GPS)'),
          backgroundColor: Colors.red.shade50,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('الرجاء منح إذن الموقع لاستخدام هذه الميزة'),
            backgroundColor: Colors.red.shade50,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      if (!mounted) return;
      setState(() {
        _currentLat = position.latitude;
        _currentLng = position.longitude;
      });
      _refreshRestaurants();
    } on TimeoutException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('انتهت مهلة اكتشاف الموقع'),
          backgroundColor: Colors.red.shade50,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحديد الموقع: $e'),
          backgroundColor: Colors.red.shade50,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _loadCuisines() async {
    setState(() {
      _isLoadingCuisines = true;
      _cuisinesError = null;
    });
    try {
      final auth = context.read<AuthService>();
      final fetched = await auth.getCuisines();
      if (!mounted) return;
      setState(() {
        _cuisines = [
          {'id': 'all', 'name': 'الجميع', 'icon_url': ''},
          ...fetched,
        ];
      });
    } catch (e) {
      if (mounted) {
        setState(
          () => _cuisinesError = e.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingCuisines = false);
    }
  }

  String? get _selectedCuisineId {
    if (_selectedCategoryIndex < 0 ||
        _selectedCategoryIndex >= _cuisines.length)
      return null;
    final id = _cuisines[_selectedCategoryIndex]['id']?.toString();
    if (id == null || id == 'all') return null;
    return id;
  }

  Future<List<Restaurant>> _fetchRestaurants({int page = 1}) async {
    final auth = context.read<AuthService>();
    final result = await auth.getRestaurants(
      q: _searchQuery.isNotEmpty ? _searchQuery : null,
      cuisineId: _selectedCuisineIndex >= 0 ? _selectedCuisineId : null,
      minRating: _minRating,
      openNow: _openNowOnly,
      lat: _currentLat,
      lng: _currentLng,
      sort: _sortBy,
      page: page,
      size: 20,
    );
    return result;
  }

  int get _selectedCuisineIndex => _selectedCategoryIndex;

  Future<void> _refreshRestaurants() async {
    setState(() {
      _restaurants = [];
      _currentPage = 1;
      _hasMoreRestaurants = true;
      _totalRestaurants = 0;
      _restaurantsError = null;
    });
    await _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    setState(() {
      _isLoadingRestaurants = true;
      _restaurantsError = null;
    });
    try {
      final result = await _fetchRestaurants(page: _currentPage);
      if (!mounted) return;
      setState(() {
        _restaurants = result;
        _hasMoreRestaurants = result.length >= 20;
      });
    } catch (e) {
      if (!mounted) return;
      setState(
        () => _restaurantsError = e.toString().replaceFirst('Exception: ', ''),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_restaurantsError!),
          backgroundColor: Colors.red.shade50,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoadingRestaurants = false);
    }
  }

  Future<void> _loadMoreRestaurants() async {
    setState(() => _isLoadingMoreRestaurants = true);
    try {
      final result = await _fetchRestaurants(page: _currentPage + 1);
      if (!mounted) return;
      setState(() {
        _restaurants.addAll(result);
        _currentPage += 1;
        _hasMoreRestaurants = result.length >= 20;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red.shade50,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoadingMoreRestaurants = false);
    }
  }

  void _onSearchChanged(String val) {
    _searchQuery = val;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _refreshRestaurants();
      }
    });
  }

  void _onCategorySelected(int index) {
    setState(() => _selectedCategoryIndex = index);
    _refreshRestaurants();
  }

  void _onFilterChanged() {
    _refreshRestaurants();
  }

  void _showFiltersSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder:
          (ctx) => Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'التصفية',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildFilterRadioGroup(
                      'الترتيب',
                      ['Relevance', 'Distance', 'Rating', 'Name'],
                      [_sortBy],
                      (val) => setState(() {
                        _sortBy = val;
                        _onFilterChanged();
                      }),
                    ),
                    const SizedBox(height: 24),
                    _buildMinRatingSelector(),
                    const SizedBox(height: 24),
                    _buildToggleField(
                      'المفتوح الآن',
                      Switch(
                        value: _openNowOnly,
                        activeColor: const Color(0xFFFF521B),
                        onChanged:
                            (val) => setState(() {
                              _openNowOnly = val;
                              _onFilterChanged();
                            }),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildFilterRadioGroup(
    String label,
    List<String> options,
    List<String> groupValues,
    void Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children:
              options.map((opt) {
                final vals = {
                  'Relevance': 'relevance',
                  'Distance': 'distance',
                  'Rating': 'rating',
                  'Name': 'name',
                };
                final val = vals[opt] ?? opt.toLowerCase();
                final isSel =
                    groupValues.isNotEmpty && groupValues.first == val;
                return ChoiceChip(
                  label: Text(
                    opt,
                    style: TextStyle(
                      color: isSel ? Colors.white : const Color(0xFF4B5563),
                    ),
                  ),
                  selected: isSel,
                  onSelected: (_) => onChanged(val),
                  selectedColor: const Color(0xFFFF521B),
                  backgroundColor: const Color(0xFFF3F4F8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildMinRatingSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التقييم الأدنى',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children:
              [0.0, 1.0, 2.0, 3.0, 4.0, 5.0].map((r) {
                final sel = _minRating == r;
                return FilterChip(
                  label: Text(
                    '${r.toInt()}+',
                    style: TextStyle(
                      color: sel ? Colors.white : const Color(0xFF4B5563),
                    ),
                  ),
                  selected: sel,
                  onSelected:
                      (_) => setState(() {
                        _minRating = sel ? null : r.toDouble();
                        _onFilterChanged();
                      }),
                  selectedColor: const Color(0xFFFF521B),
                  backgroundColor: const Color(0xFFF3F4F8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildToggleField(String label, Widget trailing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        trailing,
      ],
    );
  }

  String get _sortLabel {
    switch (_sortBy) {
      case 'relevance':
        return 'الترتيب';
      case 'distance':
        return 'القرب';
      case 'rating':
        return 'التقييم';
      case 'name':
        return 'الاسم';
      default:
        return 'الترتيب';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: RefreshIndicator(
            onRefresh: _refreshRestaurants,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Top Bar
                SliverToBoxAdapter(child: _buildTopBar()),

                // Search Box
                SliverToBoxAdapter(child: _buildSearchBox()),

                // Promo Banner
                SliverToBoxAdapter(child: _buildPromoBanner()),

                // Horizontal Categories
                SliverToBoxAdapter(child: _buildCategoriesSection()),

                // Sort / Filter Bar
                SliverToBoxAdapter(child: _buildSortFilterBar()),

                // Restaurants Title
                SliverToBoxAdapter(child: _buildSectionHeader()),

                // Restaurants List
                SliverToBoxAdapter(child: _buildRestaurantsContent()),

                // Loading more indicator
                if (_isLoadingMoreRestaurants)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    if (_isLoadingCuisines) {
      return const SizedBox(
        height: 86,
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      );
    }
    if (_cuisinesError != null) {
      return SizedBox(
        height: 86,
        child: Center(
          child: Text(
            'خطأ في تحميل الفئات',
            style: TextStyle(color: Colors.red.shade700, fontSize: 13),
          ),
        ),
      );
    }

    return SizedBox(
      height: 86,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        itemCount: _cuisines.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (ctx, i) {
          final isSelected = _selectedCategoryIndex == i;
          final item = _cuisines[i];
          final iconUrl = item['icon_url']?.toString() ?? '';

          return GestureDetector(
            onTap: () => _onCategorySelected(i),
            child: Column(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          isSelected
                              ? const Color(0xFFFF521B)
                              : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child:
                        iconUrl.isNotEmpty
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                iconUrl,
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                                loadingBuilder: (_, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const SizedBox(
                                    width: 26,
                                    height: 26,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  );
                                },
                                errorBuilder:
                                    (_, __, ___) => const Icon(
                                      Icons.restaurant_menu,
                                      size: 26,
                                      color: Color(0xFF8C93A3),
                                    ),
                              ),
                            )
                            : const Icon(
                              Icons.restaurant_menu,
                              size: 26,
                              color: Color(0xFF8C93A3),
                            ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['name']?.toString() ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color:
                        isSelected
                            ? const Color(0xFFFF521B)
                            : const Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          Expanded(child: _buildFilterChip(_sortLabel, Icons.sort_rounded)),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFilterChip(
              _minRating != null ? 'تقييم ≥ ${_minRating!.toInt()}' : 'التقييم',
              Icons.star_border_rounded,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFilterChip(
              _openNowOnly ? 'مفتوح' : 'المفتوح',
              Icons.access_time_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return GestureDetector(
      onTap: _showFiltersSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7FA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Color(0xFF5A6275)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E2432),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantsContent() {
    if (_isLoadingRestaurants && _restaurants.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
      );
    }
    if (_restaurantsError != null && _restaurants.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
              const SizedBox(height: 12),
              Text(
                'خطأ في تحميل المطاعم',
                style: TextStyle(color: Colors.red.shade700, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }
    if (_restaurants.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.restaurant_menu, size: 48, color: Color(0xFFCBD5E1)),
              const SizedBox(height: 12),
              Text(
                'لا توجد مطاعم متاحة الآن',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: _restaurants.map((r) => _buildRestaurantCard(r)).toList(),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Location with pin and arrow
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('اختيار عنوان التوصيل')),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.location_on, color: Color(0xFFFF521B), size: 22),
                SizedBox(width: 4),
                Text(
                  'مدينة نصر، القاهرة',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E2432),
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF1E2432),
                  size: 20,
                ),
              ],
            ),
          ),

          // Notification Bell with Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF1F2F6)),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF1E2432),
                  size: 24,
                ),
              ),
              Positioned(
                top: 7,
                right: 8,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF3E00),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7FA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1E2432),
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: 'ابحث عن مطاعم أو أطعمة ...',
            hintStyle: const TextStyle(
              color: Color(0xFF9AA2B1),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF8C93A3),
              size: 22,
            ),
            suffixIcon:
                _searchQuery.isNotEmpty
                    ? IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xFF8C93A3),
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                    : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFFF3B00), Color(0xFFFF6D26)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFF521B).withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Left Burger Image
            Positioned(
              left: 12,
              bottom: 12,
              top: 12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=360&h=360&fit=crop',
                  width: 140,
                  height: 136,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => const Icon(
                        Icons.fastfood,
                        size: 60,
                        color: Colors.white,
                      ),
                ),
              ),
            ),

            // Right Text Content
            Padding(
              padding: const EdgeInsets.only(
                right: 20,
                top: 22,
                bottom: 20,
                left: 160,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'خصومات مميزة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'حتى 50%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Order Now Pill Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'اطلب الآن ◀',
                      style: TextStyle(
                        color: Color(0xFFFF4800),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
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

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: const Text(
        'المطاعم القريبة منك',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Color(0xFF1E2432),
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(Restaurant restaurant) {
    final isFav = _favoriteIds.contains(restaurant.id);
    final hasImage =
        restaurant.logoUrl != null && restaurant.logoUrl!.isNotEmpty;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantDetailScreen(restaurant: restaurant),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover / Logo image
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              foregroundDecoration:
                  !restaurant.isOpen
                      ? BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                      )
                      : null,
              child:
                  hasImage
                      ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                        child: Image.network(
                          restaurant.logoUrl!,
                          width: double.infinity,
                          height: 140,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          },
                          errorBuilder:
                              (_, __, ___) => const Icon(
                                Icons.restaurant_rounded,
                                size: 48,
                                color: Color(0xFFCBD5E1),
                              ),
                        ),
                      )
                      : const Icon(
                        Icons.restaurant_rounded,
                        size: 48,
                        color: Color(0xFFCBD5E1),
                      ),
            ),

            // Badges row (open/closed + favorite)
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 18, left: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + cuisine + details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              restaurant.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E2432),
                              ),
                            ),
                            if (!restaurant.isOpen) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'مغلق',
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          restaurant.cuisine.isNotEmpty
                              ? restaurant.cuisine
                              : 'وجبات سريعة',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8C93A3),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        // Rating
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFB800),
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              restaurant.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E2432),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${restaurant.reviewCount})',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF8C93A3),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Distance + delivery time
                        Text(
                          '${restaurant.distance.toStringAsFixed(1)} كم • ${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} دقيقة',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8C93A3),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Delivery fee + min order
                        Text(
                          'سعر التوصيل ${restaurant.deliveryFee.toStringAsFixed(0)} جنيه • طلب أدنى ${restaurant.minimumOrder.toStringAsFixed(0)} جنيه',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8C93A3),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Favorite Heart Icon
                  IconButton(
                    icon: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color:
                          isFav
                              ? const Color(0xFFFF3E00)
                              : const Color(0xFFFF521B),
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isFav) {
                          _favoriteIds.remove(restaurant.id);
                        } else {
                          _favoriteIds.add(restaurant.id);
                        }
                      });
                    },
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
