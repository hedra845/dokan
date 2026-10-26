import 'package:flutter/foundation.dart';
import 'package:flutter_application_5/core/constants/supabase_config.dart';
import 'package:flutter_application_5/models/product.dart';
import 'package:flutter_application_5/data/mock_data.dart';

class ProductService {
  List<Product> getByRestaurant(String restaurantId) =>
      MockData.products.where((p) => p.restaurantId == restaurantId).toList();

  Product? getById(String id) {
    try {
      return MockData.products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Product>> fetchByRestaurantFromSupabase(
    String restaurantId,
  ) async {
    if (!SupabaseConfig.isConfigured) return getByRestaurant(restaurantId);

    try {
      final res = await SupabaseConfig.client
          .from('products')
          .select()
          .eq('restaurant_id', restaurantId);

      if (res.isNotEmpty) {
        return res.map((item) {
          final m = item;
          final rawAddons = m['addons'] is List ? m['addons'] as List : [];
          final addons =
              rawAddons.map((a) {
                return ProductAddon(
                  id: (a['id'] ?? '').toString(),
                  name: (a['name'] ?? '').toString(),
                  price: (a['price'] as num?)?.toDouble() ?? 0.0,
                );
              }).toList();

          return Product(
            id: m['id']?.toString() ?? '',
            restaurantId: m['restaurant_id']?.toString() ?? '',
            categoryId: m['category_id']?.toString() ?? '',
            category: m['category']?.toString() ?? '',
            name: m['name']?.toString() ?? '',
            description: m['description']?.toString() ?? '',
            price: (m['price'] as num?)?.toDouble() ?? 0.0,
            imageUrl: m['image_url']?.toString(),
            isAvailable: m['is_available'] == true,
            addons: addons,
          );
        }).toList();
      }
    } catch (e) {
      debugPrint('fetchByRestaurantFromSupabase error: $e');
    }
    return getByRestaurant(restaurantId);
  }

  Future<void> toggleAvailability(String productId) async {
    final idx = MockData.products.indexWhere((p) => p.id == productId);
    bool? newStatus;
    if (idx != -1) {
      newStatus = !MockData.products[idx].isAvailable;
      MockData.products[idx] = MockData.products[idx].copyWith(
        isAvailable: newStatus,
      );
    }

    if (SupabaseConfig.isConfigured && newStatus != null) {
      try {
        await SupabaseConfig.client
            .from('products')
            .update({'is_available': newStatus})
            .eq('id', productId);
      } catch (e) {
        debugPrint('toggleAvailability Supabase error: $e');
      }
    }
  }
}
