import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../models/address.dart';

class LocationPickerScreen extends StatefulWidget {
  final Address? initialAddress;
  const LocationPickerScreen({super.key, this.initialAddress});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late MapController _mapController;
  late LatLng _selectedPoint;
  double _currentZoom = 15.0;

  final _labelController = TextEditingController(text: 'المنزل');
  final _streetController = TextEditingController(text: 'شارع التحرير');
  final _buildingController = TextEditingController(text: '12');
  final _floorController = TextEditingController(text: '3');
  final _apartmentController = TextEditingController(text: '8');
  final _landmarkController = TextEditingController(text: 'بجوار المسجد');
  String _selectedArea = 'مدينة نصر';

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selectedPoint = LatLng(
      widget.initialAddress?.lat ?? 30.0444,
      widget.initialAddress?.lng ?? 31.2357,
    );
    if (widget.initialAddress != null) {
      _labelController.text = widget.initialAddress!.label;
      _streetController.text = widget.initialAddress!.street;
      _buildingController.text = widget.initialAddress!.buildingNumber;
      _floorController.text = widget.initialAddress!.floor ?? '';
      _apartmentController.text = widget.initialAddress!.apartment ?? '';
      _landmarkController.text = widget.initialAddress!.landmark ?? '';
      _selectedArea = widget.initialAddress!.area;
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  void _onMapTap(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      _selectedPoint = latLng;
    });
  }

  void _saveLocation() {
    final address = Address(
      id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
      label: _labelController.text.trim().isEmpty ? 'عنواني' : _labelController.text.trim(),
      governorate: 'القاهرة',
      area: _selectedArea,
      street: _streetController.text.trim().isEmpty ? 'الشارع الرئيسي' : _streetController.text.trim(),
      buildingNumber: _buildingController.text.trim().isEmpty ? '1' : _buildingController.text.trim(),
      floor: _floorController.text.trim(),
      apartment: _apartmentController.text.trim(),
      landmark: _landmarkController.text.trim(),
      lat: _selectedPoint.latitude,
      lng: _selectedPoint.longitude,
    );
    Navigator.pop(context, address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحديد موقع التوصيل على الخريطة'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            // Map
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _selectedPoint,
                zoom: _currentZoom,
                onTap: _onMapTap,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.flutter_application_5',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedPoint,
                      width: 50,
                      height: 50,
                      builder: (ctx) => Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF521B),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Help pill top
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app, color: Color(0xFFFF521B), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'انقر على أي نقطة بالخريطة لتحديد مكانك بدقة',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E2432),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Zoom Controls
            Positioned(
              left: 16,
              bottom: 260,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: 'zoom_in',
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E2432),
                    onPressed: () {
                      _currentZoom += 1;
                      _mapController.move(_selectedPoint, _currentZoom);
                    },
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: 'zoom_out',
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E2432),
                    onPressed: () {
                      _currentZoom -= 1;
                      _mapController.move(_selectedPoint, _currentZoom);
                    },
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),

            // Bottom sheet with address inputs
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.pin_drop_rounded, color: Color(0xFFFF521B), size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'الإحداثيات: ${_selectedPoint.latitude.toStringAsFixed(4)}, ${_selectedPoint.longitude.toStringAsFixed(4)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _streetController,
                            decoration: InputDecoration(
                              labelText: 'الشارع',
                              hintText: 'اسم الشارع',
                              prefixIcon: const Icon(Icons.edit_road, size: 18),
                              filled: true,
                              fillColor: const Color(0xFFF3F4F8),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _buildingController,
                            decoration: InputDecoration(
                              labelText: 'رقم العمارة',
                              filled: true,
                              fillColor: const Color(0xFFF3F4F8),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF521B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'تأكيد هذا الموقع للتوصيل',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
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
