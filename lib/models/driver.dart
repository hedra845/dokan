class Driver {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String? avatarUrl;
  double rating;
  int totalDeliveries;
  double earnings;
  final String vehicleType;
  final String? vehiclePlate;
  bool isOnline;
  double lat;
  double lng;
  String? currentOrderId;

  Driver({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    this.avatarUrl,
    this.rating = 4.8,
    this.totalDeliveries = 145,
    this.earnings = 3250.0,
    this.vehicleType = 'دراجة نارية',
    this.vehiclePlate = 'ب ج د 123',
    this.isOnline = true,
    this.lat = 30.0500,
    this.lng = 31.2400,
    this.currentOrderId,
  });
}
