import 'package:flutter/foundation.dart';
import 'package:flutter_application_5/core/constants/supabase_config.dart';
import 'package:flutter_application_5/models/restaurant.dart';
import 'package:flutter_application_5/data/mock_data.dart';

class RestaurantService {
  List<Restaurant> getAll() => MockData.restaurants;

  List<Restaurant> getByCategory(String categoryId) =>
      MockData.restaurants.where((r) => r.categoryIds.contains(categoryId)).toList();

  List<Restaurant> search(String query) {
    final q = query.toLowerCase();
    return MockData.restaurants.where((r) => r.name.toLowerCase().contains(q)).toList();
  }

  Restaurant? getById(String id) {
    try {
      return MockData.restaurants.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<Restaurant?> fetchByIdFromSupabase(String id) async {
    if (!SupabaseConfig.isConfigured) return getById(id);

    try {
      final res = await SupabaseConfig.client
          .from('restaurants')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (res != null) {
        final catIds = <String>[];
        if (res['category_ids'] is List) {
          catIds.addAll((res['category_ids'] as List).map((e) => e.toString()));
        }
        final deliveryMin = (res['delivery_time_min'] as num?)?.toInt() ?? 20;
        final deliveryMax = (res['delivery_time_max'] as num?)?.toInt() ?? 40;

        return Restaurant(
          id: res['id']?.toString() ?? '',
          name: res['name']?.toString() ?? '',
          imageUrl: res['image_url']?.toString(),
          logoUrl: res['logo_url']?.toString(),
          rating: (res['rating'] as num?)?.toDouble() ?? 5.0,
          reviewCount: (res['review_count'] as num?)?.toInt() ?? 0,
          deliveryTimeMin: deliveryMin,
          deliveryTimeMax: deliveryMax,
          deliveryFee: (res['delivery_fee'] as num?)?.toDouble() ?? 20.0,
          distance: (res['distance'] as num?)?.toDouble() ?? 1.5,
          isOpen: res['is_open'] == true,
          address: res['address']?.toString() ?? '',
          lat: (res['lat'] as num?)?.toDouble() ?? 30.0560,
          lng: (res['lng'] as num?)?.toDouble() ?? 31.3300,
          categoryIds: catIds,
          ownerId: res['owner_id']?.toString() ?? '',
          isFavorite: isFavorite(id),
          cuisine: res['cuisine']?.toString() ?? '',
          deliveryTime: '$deliveryMin~$deliveryMax دقيقة',
          minimumOrder: (res['minimum_order'] as num?)?.toDouble() ?? 0.0,
        );
      }
    } catch (e) {
      debugPrint('fetchByIdFromSupabase error: $e');
    }
    return getById(id);
  }

  void toggleFavorite(String restaurantId) {
    if (MockData.favoriteRestaurantIds.contains(restaurantId)) {
      MockData.favoriteRestaurantIds.remove(restaurantId);
    } else {
      MockData.favoriteRestaurantIds.add(restaurantId);
    }
  }

  bool isFavorite(String restaurantId) =>
      MockData.favoriteRestaurantIds.contains(restaurantId);
}
