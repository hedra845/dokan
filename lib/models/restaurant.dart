class Restaurant {
  final String id;
  final String name;
  final String? imageUrl;
  final String? logoUrl;
  final double rating;
  final int reviewCount;
  final int deliveryTimeMin;
  final int deliveryTimeMax;
  final double deliveryFee;
  final double distance;
  bool isOpen;
  final String address;
  final double lat;
  final double lng;
  final List<String> categoryIds;
  final String ownerId;
  bool isFavorite;
  final String cuisine;
  final String deliveryTime;
  final double minimumOrder;

  Restaurant({
    required this.id,
    required this.name,
    this.imageUrl,
    this.logoUrl,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTimeMin,
    required this.deliveryTimeMax,
    required this.deliveryFee,
    required this.distance,
    required this.isOpen,
    required this.address,
    this.lat = 30.0560,
    this.lng = 31.3300,
    required this.categoryIds,
    required this.ownerId,
    this.isFavorite = false,
    this.cuisine = '',
    this.deliveryTime = '',
    this.minimumOrder = 0,
  });
}
