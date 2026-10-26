class VehicleInfo {
  final String vehicleType;
  final String plateNumber;
  final String model;
  final String color;

  VehicleInfo({
    required this.vehicleType,
    required this.plateNumber,
    required this.model,
    required this.color,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      vehicleType: (json['vehicle_type'] ?? json['vehicleType'] ?? '').toString(),
      plateNumber: (json['plate_number'] ?? json['plateNumber'] ?? '').toString(),
      model: (json['model'] ?? '').toString(),
      color: (json['color'] ?? '').toString(),
    );
  }
}

class DriverProfile {
  final String userId;
  final String fullName;
  final String status;
  final String? statusReason;
  final String? avatarUrl;
  final bool isOnline;
  final double lat;
  final double lng;
  final double ratingAvg;
  final int ratingCount;
  final VehicleInfo? vehicle;

  DriverProfile({
    required this.userId,
    required this.fullName,
    required this.status,
    this.statusReason,
    this.avatarUrl,
    required this.isOnline,
    required this.lat,
    required this.lng,
    required this.ratingAvg,
    required this.ratingCount,
    this.vehicle,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      userId: (json['user_id'] ?? json['userId'] ?? '').toString(),
      fullName: (json['full_name'] ?? json['fullName'] ?? '').toString(),
      status: (json['status'] ?? 'pending').toString(),
      statusReason: json['status_reason']?.toString() ?? json['statusReason']?.toString(),
      avatarUrl: json['avatar_url']?.toString() ?? json['avatarUrl']?.toString(),
      isOnline: json['is_online'] == true,
      lat: (json['lat'] is num ? (json['lat'] as num).toDouble() : 0.0),
      lng: (json['lng'] is num ? (json['lng'] as num).toDouble() : 0.0),
      ratingAvg: (json['rating_avg'] is num ? (json['rating_avg'] as num).toDouble() : 0.0),
      ratingCount: (json['rating_count'] ?? 0) as int? ?? 0,
      vehicle: json['vehicle'] is Map
          ? VehicleInfo.fromJson(json['vehicle'] as Map<String, dynamic>)
          : null,
    );
  }
}
