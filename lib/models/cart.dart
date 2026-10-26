import 'package:flutter_application_5/models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  final List<ProductAddon> selectedAddons;
  String? notes;

  CartItem({
    required this.product,
    required this.quantity,
    this.selectedAddons = const [],
    this.notes,
  });

  double get addonsTotal => selectedAddons.fold(0.0, (sum, a) => sum + a.price);
  double get unitPrice => product.price + addonsTotal;
  double get total => unitPrice * quantity;
}

class Cart {
  final String restaurantId;
  final String restaurantName;
  final String restaurantAddress;
  final double restaurantLat;
  final double restaurantLng;
  final List<CartItem> items;

  Cart({
    required this.restaurantId,
    required this.restaurantName,
    this.restaurantAddress = 'شارع عباس العقاد، مدينة نصر، القاهرة',
    this.restaurantLat = 30.0560,
    this.restaurantLng = 31.3300,
    required this.items,
  });

  double get subtotal => items.fold(0.0, (sum, i) => sum + i.total);
  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);
}
