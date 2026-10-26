import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import 'package:flutter_application_5/core/constants/supabase_config.dart';
import 'package:flutter_application_5/models/user.dart';
import 'package:flutter_application_5/data/mock_data.dart';
import 'package:flutter_application_5/models/restaurant.dart';
import 'package:flutter_application_5/models/driver_profile.dart';

class AuthApiException implements Exception {
  final String message;
  final Map<String, String> fieldErrors;

  const AuthApiException(this.message, {this.fieldErrors = const {}});

  @override
  String toString() => message;
}

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get accessToken => SupabaseConfig.isConfigured
      ? SupabaseConfig.client.auth.currentSession?.accessToken
      : null;
  String? get refreshToken => SupabaseConfig.isConfigured
      ? SupabaseConfig.client.auth.currentSession?.refreshToken
      : null;

  static const String _keyUserId = 'logged_user_id';

  Future<void> loadSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(_keyUserId);

    if (SupabaseConfig.isConfigured) {
      final session = SupabaseConfig.client.auth.currentSession;
      if (session != null) {
        final profile = await fetchCurrentUser();
        if (profile != null) {
          _currentUser = profile;
          notifyListeners();
          return;
        }
      }
    }

    if (savedId != null) {
      _currentUser = MockData.users.firstWhere(
        (u) => u.id == savedId,
        orElse: () => MockData.users.firstWhere((u) => u.id == 'c1'),
      );
    } else {
      _currentUser = null;
    }

    notifyListeners();
  }

  Future<void> forgotPassword(String identifier) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (SupabaseConfig.isConfigured) {
        await SupabaseConfig.client.auth.resetPasswordForEmail(
          identifier.trim(),
        );
        return;
      }
      // Demo delay if Supabase credentials not set
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception('فشل إرسال رابط الاستعادة: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> fetchCurrentUser() async {
    if (!SupabaseConfig.isConfigured) return _currentUser;

    try {
      final supaUser = SupabaseConfig.client.auth.currentUser;
      if (supaUser == null) return null;

      final res = await SupabaseConfig.client
          .from('profiles')
          .select()
          .eq('id', supaUser.id)
          .maybeSingle();

      if (res != null) {
        return _buildUserFromMap(res);
      }

      // If user profile does not exist yet, construct from user metadata
      final meta = supaUser.userMetadata ?? {};
      return User(
        id: supaUser.id,
        name: meta['full_name']?.toString() ?? supaUser.email?.split('@').first ?? 'مستخدم',
        email: supaUser.email ?? '',
        phone: meta['phone']?.toString() ?? '',
        role: _parseUserRole(meta['role']?.toString()),
        emailVerified: supaUser.emailConfirmedAt != null,
      );
    } catch (e) {
      debugPrint('fetchCurrentUser error: $e');
      return null;
    }
  }

  User _buildUserFromMap(Map<String, dynamic> rawUser) {
    final role = _parseUserRole(rawUser['role']?.toString());
    return User(
      id: (rawUser['id'] ?? rawUser['user_id'] ?? '').toString(),
      name: (rawUser['full_name'] ?? rawUser['name'] ?? '').toString(),
      email: (rawUser['email'] ?? '').toString(),
      phone: (rawUser['phone'] ?? '').toString(),
      role: role,
      avatarUrl: rawUser['avatar_url']?.toString(),
      restaurantId: rawUser['restaurant_id']?.toString(),
      driverId: rawUser['driver_id']?.toString(),
      emailVerified: rawUser['email_verified'] == true,
      phoneVerified: rawUser['phone_verified'] == true,
      createdAt: _parseDateTime(rawUser['created_at']?.toString()),
      approvalStatus: rawUser['approval_status']?.toString() ?? 'approved',
      preferredLanguage: rawUser['preferred_language']?.toString(),
      marketingOptIn: rawUser['marketing_opt_in'] == true,
    );
  }

  Future<User?> fetchCustomerProfile() async {
    return fetchCurrentUser();
  }

  Future<User?> updateCustomerProfile({
    required String fullName,
    required String avatarUrl,
    required bool marketingOptIn,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (SupabaseConfig.isConfigured && _currentUser != null) {
        await SupabaseConfig.client.from('profiles').update({
          'full_name': fullName.trim(),
          'avatar_url': avatarUrl.trim(),
          'marketing_opt_in': marketingOptIn,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', _currentUser!.id);

        _currentUser = _currentUser!.copyWith(
          name: fullName.trim(),
          avatarUrl: avatarUrl.trim(),
          marketingOptIn: marketingOptIn,
        );
      } else if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          name: fullName.trim(),
          avatarUrl: avatarUrl.trim(),
          marketingOptIn: marketingOptIn,
        );
      }

      notifyListeners();
      return _currentUser;
    } catch (e) {
      throw Exception('فشل تحديث الملف الشخصي: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User> login(String emailOrPhone, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final identifier = emailOrPhone.trim();

      if (SupabaseConfig.isConfigured) {
        // Supabase signIn
        final res = await SupabaseConfig.client.auth.signInWithPassword(
          email: identifier.contains('@') ? identifier : '$identifier@phoenix.local',
          password: password,
        );

        if (res.user != null) {
          final profile = await fetchCurrentUser();
          if (profile != null) {
            _currentUser = profile;
          } else {
            _currentUser = User(
              id: res.user!.id,
              name: identifier.split('@').first,
              email: res.user!.email ?? identifier,
              phone: '',
              role: UserRole.customer,
            );
          }

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_keyUserId, _currentUser!.id);
          notifyListeners();
          return _currentUser!;
        }
      }

      // Offline / Local mock login fallback
      await Future.delayed(const Duration(milliseconds: 600));
      final user = MockData.users.firstWhere(
        (u) => u.email.toLowerCase() == identifier.toLowerCase() || u.phone == identifier,
        orElse: () => User(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          name: identifier.split('@').first,
          email: identifier.contains('@') ? identifier : '$identifier@test.com',
          phone: identifier.contains('@') ? '01011111111' : identifier,
          role: UserRole.customer,
        ),
      );

      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserId, user.id);
      notifyListeners();
      return user;
    } on supa.AuthException catch (e) {
      throw AuthApiException(e.message);
    } catch (e) {
      throw Exception('فشل تسجيل الدخول: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User> registerClient({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (SupabaseConfig.isConfigured) {
        final res = await SupabaseConfig.client.auth.signUp(
          email: email.trim(),
          password: password,
          data: {
            'full_name': fullName.trim(),
            'phone': phone.trim(),
            'role': 'customer',
          },
        );

        final userId = res.user?.id ?? 'client_${DateTime.now().millisecondsSinceEpoch}';
        await SupabaseConfig.client.from('profiles').upsert({
          'id': userId,
          'full_name': fullName.trim(),
          'email': email.trim(),
          'phone': phone.trim(),
          'role': 'customer',
          'email_verified': res.user?.emailConfirmedAt != null,
        });

        final user = User(
          id: userId,
          name: fullName.trim(),
          email: email.trim(),
          phone: phone.trim(),
          role: UserRole.customer,
          emailVerified: res.user?.emailConfirmedAt != null,
        );

        _currentUser = user;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyUserId, user.id);
        notifyListeners();
        return user;
      }

      await Future.delayed(const Duration(milliseconds: 600));
      final user = User(
        id: 'client_${DateTime.now().millisecondsSinceEpoch}',
        name: fullName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        role: UserRole.customer,
        emailVerified: true,
      );

      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserId, user.id);
      notifyListeners();
      return user;
    } on supa.AuthException catch (e) {
      throw AuthApiException(e.message);
    } catch (e) {
      throw Exception('فشل إنشاء الحساب: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User> registerRestaurant({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String restaurantName,
    required String restaurantPhone,
    required String description,
    required String address,
    required double lat,
    required double lng,
    required List<String> cuisineIds,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (SupabaseConfig.isConfigured) {
        final res = await SupabaseConfig.client.auth.signUp(
          email: email.trim(),
          password: password,
          data: {
            'full_name': fullName.trim(),
            'phone': phone.trim(),
            'role': 'restaurant',
          },
        );

        final userId = res.user?.id ?? 'rest_user_${DateTime.now().millisecondsSinceEpoch}';

        // Insert restaurant entry
        final restRes = await SupabaseConfig.client.from('restaurants').insert({
          'owner_id': userId,
          'name': restaurantName.trim(),
          'phone': restaurantPhone.trim(),
          'description': description.trim(),
          'address': address.trim(),
          'lat': lat,
          'lng': lng,
          'category_ids': cuisineIds,
          'cuisine': cuisineIds.join(', '),
        }).select().maybeSingle();

        final restaurantId = restRes?['id']?.toString() ?? 'rest_${DateTime.now().millisecondsSinceEpoch}';

        await SupabaseConfig.client.from('profiles').upsert({
          'id': userId,
          'full_name': fullName.trim(),
          'email': email.trim(),
          'phone': phone.trim(),
          'role': 'restaurant',
          'restaurant_id': restaurantId,
          'email_verified': res.user?.emailConfirmedAt != null,
        });

        final user = User(
          id: userId,
          name: restaurantName.trim(),
          email: email.trim(),
          phone: phone.trim(),
          role: UserRole.restaurant,
          restaurantId: restaurantId,
          emailVerified: res.user?.emailConfirmedAt != null,
        );

        _currentUser = user;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyUserId, user.id);
        notifyListeners();
        return user;
      }

      await Future.delayed(const Duration(milliseconds: 600));
      final user = User(
        id: 'restaurant_${DateTime.now().millisecondsSinceEpoch}',
        name: restaurantName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        role: UserRole.restaurant,
        restaurantId: 'rest1',
        emailVerified: true,
      );

      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserId, user.id);
      notifyListeners();
      return user;
    } on supa.AuthException catch (e) {
      throw AuthApiException(e.message);
    } catch (e) {
      throw Exception('فشل إنشاء حساب المطعم: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User> registerDriver({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String vehicleType,
    required String plateNumber,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (SupabaseConfig.isConfigured) {
        final res = await SupabaseConfig.client.auth.signUp(
          email: email.trim(),
          password: password,
          data: {
            'full_name': fullName.trim(),
            'phone': phone.trim(),
            'role': 'driver',
          },
        );

        final userId = res.user?.id ?? 'drv_user_${DateTime.now().millisecondsSinceEpoch}';

        await SupabaseConfig.client.from('profiles').upsert({
          'id': userId,
          'full_name': fullName.trim(),
          'email': email.trim(),
          'phone': phone.trim(),
          'role': 'driver',
          'driver_id': userId,
          'email_verified': res.user?.emailConfirmedAt != null,
        });

        await SupabaseConfig.client.from('driver_profiles').upsert({
          'user_id': userId,
          'full_name': fullName.trim(),
          'is_online': false,
          'vehicle': {
            'vehicle_type': vehicleType,
            'plate_number': plateNumber.trim(),
            'model': '',
            'color': '',
          },
        });

        final user = User(
          id: userId,
          name: fullName.trim(),
          email: email.trim(),
          phone: phone.trim(),
          role: UserRole.driver,
          driverId: userId,
          emailVerified: res.user?.emailConfirmedAt != null,
        );

        _currentUser = user;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyUserId, user.id);
        notifyListeners();
        return user;
      }

      await Future.delayed(const Duration(milliseconds: 600));
      final user = User(
        id: 'driver_${DateTime.now().millisecondsSinceEpoch}',
        name: fullName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        role: UserRole.driver,
        driverId: 'drv1',
        emailVerified: true,
      );

      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserId, user.id);
      notifyListeners();
      return user;
    } on supa.AuthException catch (e) {
      throw AuthApiException(e.message);
    } catch (e) {
      throw Exception('فشل إنشاء حساب المندوب: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> addAddress({
    required String label,
    required String line1,
    String? line2,
    required String city,
    required String area,
    required String building,
    String? notes,
    required double lat,
    required double lng,
    bool isDefault = false,
  }) async {
    try {
      if (SupabaseConfig.isConfigured && _currentUser != null) {
        final inserted = await SupabaseConfig.client.from('addresses').insert({
          'user_id': _currentUser!.id,
          'label': label.trim(),
          'street': line1.trim(),
          'city': city.trim(),
          'area': area.trim(),
          'building': building.trim(),
          'building_number': building.trim(),
          'notes': notes?.trim(),
          'lat': lat,
          'lng': lng,
          'is_default': isDefault,
        }).select().maybeSingle();

        return inserted;
      }

      return {
        'id': 'addr_${DateTime.now().millisecondsSinceEpoch}',
        'label': label,
        'line1': line1,
        'city': city,
        'area': area,
        'building': building,
        'lat': lat,
        'lng': lng,
        'is_default': isDefault,
      };
    } catch (e) {
      throw Exception('فشل إضافة العنوان: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAddresses() async {
    try {
      if (SupabaseConfig.isConfigured && _currentUser != null) {
        final list = await SupabaseConfig.client
            .from('addresses')
            .select()
            .eq('user_id', _currentUser!.id)
            .order('created_at', ascending: false);

        return List<Map<String, dynamic>>.from(list);
      }

      return [
        {
          'id': 'addr_1',
          'label': 'المنزل',
          'line1': MockData.defaultAddress.street,
          'city': MockData.defaultAddress.governorate,
          'area': MockData.defaultAddress.area,
          'building': MockData.defaultAddress.buildingNumber,
          'lat': MockData.defaultAddress.lat,
          'lng': MockData.defaultAddress.lng,
          'is_default': true,
        }
      ];
    } catch (e) {
      debugPrint('getAddresses error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCuisines() async {
    try {
      if (SupabaseConfig.isConfigured) {
        final list = await SupabaseConfig.client
            .from('cuisines')
            .select()
            .order('sort_order', ascending: true);

        return List<Map<String, dynamic>>.from(list);
      }

      return MockData.categories.map((c) => {
        'id': c.id,
        'name': c.name,
        'icon_url': '',
        'emoji': c.emoji,
      }).toList();
    } catch (e) {
      debugPrint('getCuisines error: $e');
      return MockData.categories.map((c) => {
        'id': c.id,
        'name': c.name,
        'icon_url': '',
        'emoji': c.emoji,
      }).toList();
    }
  }

  Future<List<Restaurant>> getRestaurants({
    String? q,
    String? cuisineId,
    double? minRating,
    bool? openNow,
    double? lat,
    double? lng,
    String? sort,
    int page = 1,
    int size = 20,
  }) async {
    try {
      if (SupabaseConfig.isConfigured) {
        var query = SupabaseConfig.client.from('restaurants').select();

        if (q != null && q.trim().isNotEmpty) {
          query = query.ilike('name', '%${q.trim()}%');
        }
        if (openNow == true) {
          query = query.eq('is_open', true);
        }
        if (minRating != null && minRating > 0) {
          query = query.gte('rating', minRating);
        }

        final data = await query;
        final list = (data as List).map((item) => _buildRestaurantFromMap(item as Map<String, dynamic>)).toList();

        if (cuisineId != null && cuisineId.isNotEmpty && cuisineId != 'all') {
          return list.where((r) => r.categoryIds.contains(cuisineId)).toList();
        }
        return list;
      }

      var list = List<Restaurant>.from(MockData.restaurants);
      if (q != null && q.isNotEmpty) {
        list = list.where((r) => r.name.toLowerCase().contains(q.toLowerCase())).toList();
      }
      if (cuisineId != null && cuisineId.isNotEmpty && cuisineId != 'all') {
        list = list.where((r) => r.categoryIds.contains(cuisineId)).toList();
      }
      if (openNow == true) {
        list = list.where((r) => r.isOpen).toList();
      }
      return list;
    } catch (e) {
      debugPrint('getRestaurants error: $e');
      return MockData.restaurants;
    }
  }

  Restaurant _buildRestaurantFromMap(Map<String, dynamic> map) {
    final catIds = <String>[];
    if (map['category_ids'] is List) {
      catIds.addAll((map['category_ids'] as List).map((e) => e.toString()));
    }

    final deliveryMin = (map['delivery_time_min'] as num?)?.toInt() ?? 20;
    final deliveryMax = (map['delivery_time_max'] as num?)?.toInt() ?? 40;

    return Restaurant(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      imageUrl: map['image_url']?.toString(),
      logoUrl: map['logo_url']?.toString(),
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      reviewCount: (map['review_count'] as num?)?.toInt() ?? 0,
      deliveryTimeMin: deliveryMin,
      deliveryTimeMax: deliveryMax,
      deliveryFee: (map['delivery_fee'] as num?)?.toDouble() ?? 20.0,
      distance: (map['distance'] as num?)?.toDouble() ?? 1.5,
      isOpen: map['is_open'] == true,
      address: map['address']?.toString() ?? '',
      lat: (map['lat'] as num?)?.toDouble() ?? 30.0560,
      lng: (map['lng'] as num?)?.toDouble() ?? 31.3300,
      categoryIds: catIds,
      ownerId: map['owner_id']?.toString() ?? '',
      isFavorite: false,
      cuisine: map['cuisine']?.toString() ?? '',
      deliveryTime: '$deliveryMin~$deliveryMax دقيقة',
      minimumOrder: (map['minimum_order'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Future<DriverProfile?> fetchDriverProfile() async {
    try {
      if (SupabaseConfig.isConfigured && _currentUser != null) {
        final data = await SupabaseConfig.client
            .from('driver_profiles')
            .select()
            .eq('user_id', _currentUser!.id)
            .maybeSingle();

        if (data != null) {
          return DriverProfile.fromJson(data);
        }
      }

      return DriverProfile(
        userId: _currentUser?.id ?? 'drv1',
        fullName: _currentUser?.name ?? MockData.mockDriver.name,
        status: 'approved',
        isOnline: MockData.mockDriver.isOnline,
        lat: 30.0444,
        lng: 31.2357,
        ratingAvg: MockData.mockDriver.rating,
        ratingCount: MockData.mockDriver.totalDeliveries,
        vehicle: VehicleInfo(
          vehicleType: MockData.mockDriver.vehicleType,
          plateNumber: MockData.mockDriver.vehiclePlate ?? '',
          model: '2023',
          color: 'أسود',
        ),
      );
    } catch (e) {
      debugPrint('fetchDriverProfile error: $e');
      return null;
    }
  }

  Future<DriverProfile?> updateDriverProfile({
    String? fullName,
    String? avatarUrl,
    bool? isOnline,
    double? lat,
    double? lng,
  }) async {
    try {
      if (SupabaseConfig.isConfigured && _currentUser != null) {
        final updateMap = <String, dynamic>{
          'updated_at': DateTime.now().toIso8601String(),
        };
        if (fullName != null) updateMap['full_name'] = fullName.trim();
        if (avatarUrl != null) updateMap['avatar_url'] = avatarUrl.trim();
        if (isOnline != null) updateMap['is_online'] = isOnline;
        if (lat != null) updateMap['lat'] = lat;
        if (lng != null) updateMap['lng'] = lng;

        final updated = await SupabaseConfig.client
            .from('driver_profiles')
            .update(updateMap)
            .eq('user_id', _currentUser!.id)
            .select()
            .maybeSingle();

        if (updated != null) {
          return DriverProfile.fromJson(updated);
        }
      }

      if (isOnline != null) {
        MockData.mockDriver.isOnline = isOnline;
      }
      return fetchDriverProfile();
    } catch (e) {
      throw Exception('فشل تحديث بيانات المندوب: $e');
    }
  }

  Future<void> switchRole(UserRole role) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 200));
    switch (role) {
      case UserRole.customer:
        _currentUser = MockData.users.firstWhere((u) => u.id == 'c1');
        break;
      case UserRole.restaurant:
        _currentUser = MockData.users.firstWhere((u) => u.id == 'r1');
        break;
      case UserRole.driver:
        _currentUser = MockData.users.firstWhere((u) => u.id == 'd1');
        break;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, _currentUser!.id);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    if (SupabaseConfig.isConfigured) {
      try {
        await SupabaseConfig.client.auth.signOut();
      } catch (_) {}
    }
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    notifyListeners();
  }

  UserRole _parseUserRole(String? rawRole) {
    switch ((rawRole ?? '').trim().toLowerCase()) {
      case 'restaurant':
      case 'vendor':
      case 'merchant':
        return UserRole.restaurant;
      case 'driver':
      case 'courier':
      case 'delivery':
        return UserRole.driver;
      case 'customer':
      case 'client':
      case 'user':
      default:
        return UserRole.customer;
    }
  }

  DateTime? _parseDateTime(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    return DateTime.tryParse(raw.trim());
  }
}
