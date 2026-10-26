import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';

class RouteMapView extends StatelessWidget {
  final LatLng fromPoint;
  final LatLng toPoint;
  final String fromLabel;
  final String toLabel;
  final LatLng? driverPoint;
  final double height;

  const RouteMapView({
    super.key,
    required this.fromPoint,
    required this.toPoint,
    this.fromLabel = 'المطعم',
    this.toLabel = 'العميل',
    this.driverPoint,
    this.height = 240,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate center between from and to
    final centerLat = (fromPoint.latitude + toPoint.latitude) / 2;
    final centerLng = (fromPoint.longitude + toPoint.longitude) / 2;
    final center = LatLng(centerLat, centerLng);

    // Simulated curved/interpolated route waypoints
    final routePoints = [
      fromPoint,
      LatLng(
        fromPoint.latitude + (toPoint.latitude - fromPoint.latitude) * 0.3 + 0.002,
        fromPoint.longitude + (toPoint.longitude - fromPoint.longitude) * 0.25,
      ),
      LatLng(
        fromPoint.latitude + (toPoint.latitude - fromPoint.latitude) * 0.65 - 0.001,
        fromPoint.longitude + (toPoint.longitude - fromPoint.longitude) * 0.7,
      ),
      toPoint,
    ];

    final currentDriver = driverPoint ??
        LatLng(
          fromPoint.latitude + (toPoint.latitude - fromPoint.latitude) * 0.5,
          fromPoint.longitude + (toPoint.longitude - fromPoint.longitude) * 0.5,
        );

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                center: center,
                zoom: 13.5,
                interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.flutter_application_5',
                ),
                // Polyline Route between restaurant and client
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 4.5,
                      color: kEmeraldGreen,
                      borderColor: Colors.white,
                      borderStrokeWidth: 1.5,
                    ),
                  ],
                ),
                // Markers
                MarkerLayer(
                  markers: [
                    // Restaurant Marker (من)
                    Marker(
                      point: fromPoint,
                      width: 90,
                      height: 56,
                      builder: (ctx) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1F2937),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              fromLabel,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 16),
                          ),
                        ],
                      ),
                    ),

                    // Customer Marker (إلى)
                    Marker(
                      point: toPoint,
                      width: 90,
                      height: 56,
                      builder: (ctx) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: kEmeraldGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              toLabel,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: kEmeraldGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person_pin_circle_rounded, color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                    ),

                    // Driver Marker (المندوب)
                    Marker(
                      point: currentDriver,
                      width: 44,
                      height: 44,
                      builder: (ctx) => Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.delivery_dining_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Route Badge Pill top
            Positioned(
              top: 10,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.near_me_rounded, color: kOrange, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'خريطة المسار المباشر',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2432),
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
