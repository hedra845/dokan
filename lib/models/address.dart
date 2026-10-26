class Address {
  final String id;
  final String label;
  final String governorate;
  final String area;
  final String street;
  final String buildingNumber;
  final String? floor;
  final String? apartment;
  final String? landmark;
  final double lat;
  final double lng;

  const Address({
    required this.id,
    required this.label,
    required this.governorate,
    required this.area,
    required this.street,
    required this.buildingNumber,
    this.floor,
    this.apartment,
    this.landmark,
    this.lat = 30.0444,
    this.lng = 31.2357,
  });

  String get fullAddress {
    final parts = [
      if (street.isNotEmpty) street,
      if (buildingNumber.isNotEmpty) 'عمارة $buildingNumber',
      if (floor != null && floor!.isNotEmpty) 'طابق $floor',
      if (apartment != null && apartment!.isNotEmpty) 'شقة $apartment',
      if (area.isNotEmpty) area,
      if (governorate.isNotEmpty) governorate,
      if (landmark != null && landmark!.isNotEmpty) '($landmark)',
    ];
    return parts.isEmpty ? 'القاهرة، مصر' : parts.join('، ');
  }

  Address copyWith({
    String? id,
    String? label,
    String? governorate,
    String? area,
    String? street,
    String? buildingNumber,
    String? floor,
    String? apartment,
    String? landmark,
    double? lat,
    double? lng,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      governorate: governorate ?? this.governorate,
      area: area ?? this.area,
      street: street ?? this.street,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      floor: floor ?? this.floor,
      apartment: apartment ?? this.apartment,
      landmark: landmark ?? this.landmark,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}
