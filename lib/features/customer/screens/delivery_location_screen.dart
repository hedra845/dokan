import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';

enum MapTypeStyle { osmStandard, osmHot, cartoLight }

class DeliveryLocationScreen extends StatefulWidget {
  const DeliveryLocationScreen({super.key});

  @override
  State<DeliveryLocationScreen> createState() => _DeliveryLocationScreenState();
}

class _DeliveryLocationScreenState extends State<DeliveryLocationScreen> {
  static const LatLng _cairoCenter = LatLng(30.0644, 31.2796); // Nasr City, Cairo
  late final MapController _mapController;
  LatLng _selectedLocation = _cairoCenter;
  String _addressTitle = 'مدينة نصر، القاهرة';
  String _addressDetails = 'جاري تحديد الشارع والمنطقة...';
  bool _isLoadingAddress = false;
  bool _isLocating = false;
  MapTypeStyle _currentMapStyle = MapTypeStyle.osmStandard;

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounceTimer;

  // Preset popular Egyptian delivery hubs for quick selection
  final List<Map<String, dynamic>> _popularAreas = [
    {'name': 'مدينة نصر', 'lat': 30.0644, 'lng': 31.2796, 'city': 'القاهرة'},
    {'name': 'مصر الجديدة', 'lat': 30.0910, 'lng': 31.3285, 'city': 'القاهرة'},
    {'name': 'التجمع الخامس', 'lat': 30.0074, 'lng': 31.4284, 'city': 'القاهرة الجديدة'},
    {'name': 'المعادي', 'lat': 29.9602, 'lng': 31.2569, 'city': 'القاهرة'},
    {'name': 'الشيخ زايد', 'lat': 30.0468, 'lng': 30.9876, 'city': 'الجيزة'},
    {'name': 'الدقي والمهندسين', 'lat': 30.0390, 'lng': 31.2050, 'city': 'الجيزة'},
    {'name': 'سموحة', 'lat': 31.2156, 'lng': 29.9553, 'city': 'الإسكندرية'},
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _reverseGeocode(_selectedLocation);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  String _getTileUrl() {
    switch (_currentMapStyle) {
      case MapTypeStyle.osmHot:
        // OpenStreetMap Humanitarian / HOT style
        return 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png';
      case MapTypeStyle.cartoLight:
        // CartoDB Positron / OpenStreetMap-based clean light style
        return 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png';
      case MapTypeStyle.osmStandard:
        // OpenStreetMap Standard Map (خريطة الشارع المفتوح الرسمية)
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    }
  }

  Future<void> _reverseGeocode(LatLng point) async {
    setState(() => _isLoadingAddress = true);
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${point.latitude}&lon=${point.longitude}&accept-language=ar',
      );
      final res = await http.get(url, headers: {'User-Agent': 'DokanApp/1.0'});
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        final address = data['address'] as Map<String, dynamic>? ?? {};
        final suburb = address['suburb'] ?? address['neighbourhood'] ?? address['quarter'] ?? '';
        final road = address['road'] ?? address['pedestrian'] ?? '';
        final city = address['city'] ?? address['town'] ?? address['state'] ?? 'القاهرة';

        String title = '';
        if (suburb.isNotEmpty) {
          title = '$suburb، $city';
        } else if (road.isNotEmpty) {
          title = '$road، $city';
        } else {
          title = city;
        }

        String details = data['display_name'] ?? 'موقع محدد على الخريطة';
        if (details.length > 60) {
          details = details.split(',').take(3).join(', ');
        }

        if (mounted) {
          setState(() {
            _addressTitle = title.isEmpty ? 'الموقع المحدد' : title;
            _addressDetails = details;
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _addressTitle = 'موقع محدد (${point.latitude.toStringAsFixed(3)}, ${point.longitude.toStringAsFixed(3)})';
          _addressDetails = 'تم التحديد عبر الخريطة المفتوحة (OpenStreetMap)';
        });
      }
    } finally {
      if (mounted) setState(() => _isLoadingAddress = false);
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      setState(() => _isSearching = true);
      try {
        final encoded = Uri.encodeComponent('$query, مصر');
        final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$encoded&format=json&accept-language=ar&limit=5',
        );
        final res = await http.get(url, headers: {'User-Agent': 'DokanApp/1.0'});
        if (res.statusCode == 200) {
          final list = (json.decode(res.body) as List).cast<Map<String, dynamic>>();
          if (mounted) {
            setState(() => _searchResults = list);
          }
        }
      } catch (_) {
      } finally {
        if (mounted) setState(() => _isSearching = false);
      }
    });
  }

  void _selectSearchResult(Map<String, dynamic> item) {
    final lat = double.tryParse(item['lat']?.toString() ?? '') ?? _selectedLocation.latitude;
    final lon = double.tryParse(item['lon']?.toString() ?? '') ?? _selectedLocation.longitude;
    final point = LatLng(lat, lon);

    setState(() {
      _selectedLocation = point;
      _searchResults = [];
      _searchController.clear();
      _addressTitle = (item['display_name'] as String).split(',').first;
      _addressDetails = item['display_name'] ?? '';
    });

    FocusScope.of(context).unfocus();
    _mapController.move(point, 16.0);
    _reverseGeocode(point);
  }

  Future<void> _locateUserGPS() async {
    setState(() => _isLocating = true);
    try {
      var enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء تفعيل الـ GPS في الهاتف لتحديد موقعك بدقة 📍'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }

      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء إعطاء صلاحية الموقع للوصول إلى مكانك الحالي'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final point = LatLng(pos.latitude, pos.longitude);
      setState(() => _selectedLocation = point);
      _mapController.move(point, 16.5);
      _reverseGeocode(point);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديد موقعك الحالي بنجاح 🎯'),
            backgroundColor: kEmeraldGreen,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعذر تحديد الموقع عبر GPS: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _confirmAndReturn() {
    Navigator.pop(context, _addressTitle);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // ── 1. Google Maps Vector / Tile Layer ──
            Positioned.fill(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: _selectedLocation,
                  zoom: 15.0,
                  maxZoom: 19.0,
                  minZoom: 4.0,
                  onTap: (tapPosition, point) {
                    setState(() => _selectedLocation = point);
                    _reverseGeocode(point);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: _getTileUrl(),
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.dokan.delivery',
                    maxZoom: 19,
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLocation,
                        width: 50,
                        height: 50,
                        anchorPos: AnchorPos.align(AnchorAlign.top),
                        builder: (_) => Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: kEmeraldGreen,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(70),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.delivery_dining,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── 2. Top Header & Google Places Search Bar ──
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(25),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: const Color(0xFFD1FAE5), width: 1.2),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 18, color: kDark),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: _onSearchChanged,
                              decoration: const InputDecoration(
                                hintText: 'ابحث عن منطقة، شارع أو معلم في مصر...',
                                hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchResults = []);
                              },
                            )
                          else if (_isSearching)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: kEmeraldGreen),
                              ),
                            )
                          else
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(Icons.search, color: kEmeraldGreen, size: 22),
                            ),
                        ],
                      ),
                    ),

                    // Search Results Overlay
                    if (_searchResults.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(30),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemCount: _searchResults.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (ctx, i) {
                            final item = _searchResults[i];
                            return ListTile(
                              dense: true,
                              leading: const Icon(Icons.location_on, color: kEmeraldGreen, size: 20),
                              title: Text(
                                item['display_name'] ?? '',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kDark),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () => _selectSearchResult(item),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 10),

                    // Quick Popular Areas Chips
                    SizedBox(
                      height: 34,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _popularAreas.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (ctx, i) {
                          final area = _popularAreas[i];
                          return GestureDetector(
                            onTap: () {
                              final pt = LatLng(area['lat'] as double, area['lng'] as double);
                              setState(() {
                                _selectedLocation = pt;
                                _addressTitle = '${area['name']}، ${area['city']}';
                                _addressDetails = 'تم التحديد السريع عبر خرائط جوجل';
                              });
                              _mapController.move(pt, 15.5);
                              _reverseGeocode(pt);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(12),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.place_outlined, size: 14, color: kEmeraldGreen),
                                  const SizedBox(width: 4),
                                  Text(
                                    area['name'] as String,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kDark),
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
              ),
            ),

            // ── 3. Map Controls (GPS Floating Button & Layer Type Switcher) ──
            Positioned(
              left: 16,
              bottom: 240,
              child: Column(
                children: [
                  // Map Style Toggle (OpenStreetMap Standard vs Humanitarian vs CartoLight)
                  FloatingActionButton.small(
                    heroTag: 'map_layer',
                    backgroundColor: Colors.white,
                    elevation: 3,
                    tooltip: 'تغيير نمط الخريطة المفتوحة',
                    onPressed: () {
                      setState(() {
                        if (_currentMapStyle == MapTypeStyle.osmStandard) {
                          _currentMapStyle = MapTypeStyle.osmHot;
                        } else if (_currentMapStyle == MapTypeStyle.osmHot) {
                          _currentMapStyle = MapTypeStyle.cartoLight;
                        } else {
                          _currentMapStyle = MapTypeStyle.osmStandard;
                        }
                      });
                    },
                    child: Icon(
                      _currentMapStyle == MapTypeStyle.osmHot
                          ? Icons.wb_sunny_outlined
                          : _currentMapStyle == MapTypeStyle.cartoLight
                              ? Icons.map_outlined
                              : Icons.layers_rounded,
                      color: kEmeraldGreen,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Current GPS Locator
                  FloatingActionButton(
                    heroTag: 'gps_button',
                    backgroundColor: Colors.white,
                    elevation: 4,
                    onPressed: _isLocating ? null : _locateUserGPS,
                    child: _isLocating
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: kEmeraldGreen),
                          )
                        : const Icon(Icons.my_location, color: kEmeraldGreen, size: 24),
                  ),
                ],
              ),
            ),

            // ── 4. Bottom Delivery Address Confirmation Card ──
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 20,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: kEmeraldLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.location_on, color: kEmeraldGreen, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        _addressTitle,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: kDark,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: 6),
                                      if (_isLoadingAddress)
                                        const SizedBox(
                                          width: 12,
                                          height: 12,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: kEmeraldGreen),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    _addressDetails,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'OpenStreetMap ©',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Action Button
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _confirmAndReturn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kEmeraldGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'تأكيد هذا الموقع للتوصيل',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
