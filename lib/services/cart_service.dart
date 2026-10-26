import 'package:flutter/foundation.dart';
import 'package:flutter_application_5/models/cart.dart';
import 'package:flutter_application_5/models/product.dart';

class CartService extends ChangeNotifier {
  Cart? _cart;

  Cart? get cart => _cart;
  bool get hasItems => _cart != null && _cart!.items.isNotEmpty;
  int get itemCount => _cart?.itemCount ?? 0;
  double get subtotal => _cart?.subtotal ?? 0;
  List<CartItem> get items => _cart?.items ?? [];
  double get totalPrice => _cart?.subtotal ?? 0;
  int get totalItems => _cart?.itemCount ?? 0;
  int get quantity => itemCount;

  void addItem(
    Product product, {
    String? restaurantName,
    String? restaurantAddress,
    double? restaurantLat,
    double? restaurantLng,
    int quantity = 1,
    List<ProductAddon> addons = const [],
    String? notes,
  }) {
    if (_cart != null && _cart!.restaurantId != product.restaurantId) {
      _cart = null;
    }

    _cart ??= Cart(
      restaurantId: product.restaurantId,
      restaurantName: restaurantName ?? '',
      restaurantAddress: restaurantAddress ?? 'شارع عباس العقاد، مدينة نصر، القاهرة',
      restaurantLat: restaurantLat ?? 30.0560,
      restaurantLng: restaurantLng ?? 31.3300,
      items: [],
    );

    final existingIndex = _cart!.items.indexWhere(
      (i) => i.product.id == product.id,
    );
    if (existingIndex != -1) {
      _cart!.items[existingIndex].quantity += quantity;
    } else {
      _cart!.items.add(
        CartItem(
          product: product,
          quantity: quantity,
          selectedAddons: addons,
          notes: notes,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _cart?.items.removeWhere((i) => i.product.id == productId);
    if (_cart != null && _cart!.items.isEmpty) _cart = null;
    notifyListeners();
  }

  void decreaseItem(String productId) {
    final cart = _cart;
    if (cart == null) return;
    final index = cart.items.indexWhere((i) => i.product.id == productId);
    if (index != -1) {
      cart.items[index].quantity -= 1;
      if (cart.items[index].quantity <= 0) {
        cart.items.removeAt(index);
      }
    }
    if (cart.items.isEmpty) _cart = null;
    notifyListeners();
  }

  int getQuantity(String productId) {
    final cart = _cart;
    if (cart == null) return 0;
    final index = cart.items.indexWhere((i) => i.product.id == productId);
    if (index == -1) return 0;
    return cart.items[index].quantity;
  }

  void updateQuantity(String productId, int qty) {
    if (qty <= 0) {
      removeItem(productId);
      return;
    }
    final item = _cart?.items.firstWhere((i) => i.product.id == productId);
    if (item != null) {
      item.quantity = qty;
      notifyListeners();
    }
  }

  void clearCart() {
    _cart = null;
    notifyListeners();
  }
}
