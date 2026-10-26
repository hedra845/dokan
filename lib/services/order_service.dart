import 'package:flutter/foundation.dart';
import 'package:flutter_application_5/core/constants/supabase_config.dart';
import 'package:flutter_application_5/models/order.dart';
import 'package:flutter_application_5/models/order_item.dart';
import 'package:flutter_application_5/models/address.dart';
import 'package:flutter_application_5/data/mock_data.dart';

class OrderService extends ChangeNotifier {
  final List<Order> _orders = [];

  OrderService() {
    _initSampleOrders();
    fetchOrdersFromSupabase();
  }

  void _initSampleOrders() {
    _orders.add(
      Order(
        id: '1052',
        customerId: 'c1',
        customerName: 'أحمد محمد',
        customerPhone: '01011111111',
        restaurantId: 'rest1',
        restaurantName: 'مطعم أبو خالد',
        driverId: 'drv1',
        driverName: 'محمد خالد',
        items: [
          OrderItem(
            productId: 'p1',
            productName: 'برجر لحم فاخر',
            price: 120.0,
            quantity: 2,
          ),
          OrderItem(
            productId: 'p4',
            productName: 'كوكاكولا كانز',
            price: 20.0,
            quantity: 1,
          ),
        ],
        status: OrderStatus.preparing,
        deliveryAddress: MockData.defaultAddress,
        paymentMethod: 'الدفع عند الاستلام',
        subtotal: 260.0,
        deliveryFee: 20.0,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    );
    _orders.add(
      Order(
        id: '1051',
        customerId: 'c1',
        customerName: 'سارة علي',
        customerPhone: '01099998888',
        restaurantId: 'rest1',
        restaurantName: 'مطعم أبو خالد',
        items: [
          OrderItem(
            productId: 'p2',
            productName: 'برجر دجاج مقرمش',
            price: 95.0,
            quantity: 1,
          ),
        ],
        status: OrderStatus.ready,
        deliveryAddress: MockData.defaultAddress,
        paymentMethod: 'محفظة إلكترونية',
        subtotal: 95.0,
        deliveryFee: 20.0,
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
    );
  }

  List<Order> get orders => List.unmodifiable(_orders);

  Future<void> fetchOrdersFromSupabase() async {
    if (!SupabaseConfig.isConfigured) return;

    try {
      final data = await SupabaseConfig.client
          .from('orders')
          .select()
          .order('created_at', ascending: false);

      if (data.isNotEmpty) {
        _orders.clear();
        for (final item in data) {
          _orders.add(_orderFromJson(item));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('fetchOrdersFromSupabase error: $e');
    }
  }

  Order _orderFromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] is List ? json['items'] as List : [];
    final items =
        rawItems.map((it) {
          return OrderItem(
            productId: (it['product_id'] ?? it['productId'] ?? '').toString(),
            productName:
                (it['product_name'] ?? it['productName'] ?? '').toString(),
            price: (it['price'] as num?)?.toDouble() ?? 0.0,
            quantity: (it['quantity'] as num?)?.toInt() ?? 1,
          );
        }).toList();

    final addrJson =
        json['delivery_address'] is Map
            ? json['delivery_address'] as Map<String, dynamic>
            : {};
    final address = Address(
      id: (addrJson['id'] ?? 'addr').toString(),
      label: (addrJson['label'] ?? 'المنزل').toString(),
      governorate: (addrJson['governorate'] ?? 'القاهرة').toString(),
      area: (addrJson['area'] ?? '').toString(),
      street: (addrJson['street'] ?? '').toString(),
      buildingNumber:
          (addrJson['building_number'] ?? addrJson['building'] ?? '')
              .toString(),
      lat: (addrJson['lat'] as num?)?.toDouble() ?? 30.0444,
      lng: (addrJson['lng'] as num?)?.toDouble() ?? 31.2357,
    );

    return Order(
      id: (json['id'] ?? '').toString(),
      customerId: (json['customer_id'] ?? '').toString(),
      customerName: (json['customer_name'] ?? '').toString(),
      customerPhone: (json['customer_phone'] ?? '').toString(),
      restaurantId: (json['restaurant_id'] ?? '').toString(),
      restaurantName: (json['restaurant_name'] ?? '').toString(),
      driverId: json['driver_id']?.toString(),
      driverName: json['driver_name']?.toString(),
      items: items,
      status: _parseStatus(json['status']?.toString()),
      deliveryAddress: address,
      paymentMethod:
          (json['payment_method'] ?? 'الدفع عند الاستلام').toString(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 20.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  OrderStatus _parseStatus(String? status) {
    switch (status) {
      case 'accepted':
        return OrderStatus.accepted;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready':
        return OrderStatus.ready;
      case 'driverAssigned':
        return OrderStatus.driverAssigned;
      case 'pickedUp':
        return OrderStatus.pickedUp;
      case 'onTheWay':
        return OrderStatus.onTheWay;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'pending':
      default:
        return OrderStatus.pending;
    }
  }

  List<Order> getOrdersByCustomer(String customerId) =>
      _orders.where((o) => o.customerId == customerId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<Order> getOrdersByRestaurant(String restaurantId) =>
      _orders.where((o) => o.restaurantId == restaurantId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<Order> getPendingOrdersForRestaurant(String restaurantId) =>
      _orders
          .where(
            (o) =>
                o.restaurantId == restaurantId &&
                o.status == OrderStatus.pending,
          )
          .toList();

  List<Order> getAvailableOrdersForDriver() =>
      _orders
          .where(
            (o) =>
                (o.status == OrderStatus.ready ||
                    o.status == OrderStatus.accepted ||
                    o.status == OrderStatus.preparing) &&
                o.driverId == null,
          )
          .toList();

  Order? getActiveDriverOrder(String driverId) {
    try {
      return _orders.firstWhere(
        (o) => o.driverId == driverId && o.status.isActive,
      );
    } catch (_) {
      return null;
    }
  }

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> createOrder(Order order) async {
    _orders.insert(0, order);
    notifyListeners();

    if (SupabaseConfig.isConfigured) {
      try {
        await SupabaseConfig.client.from('orders').insert({
          'id': order.id,
          'customer_id': order.customerId.length > 20 ? order.customerId : null,
          'customer_name': order.customerName,
          'customer_phone': order.customerPhone,
          'restaurant_id': order.restaurantId,
          'restaurant_name': order.restaurantName,
          'items':
              order.items
                  .map(
                    (i) => {
                      'product_id': i.productId,
                      'product_name': i.productName,
                      'price': i.price,
                      'quantity': i.quantity,
                    },
                  )
                  .toList(),
          'status': order.status.name,
          'delivery_address': {
            'label': order.deliveryAddress.label,
            'street': order.deliveryAddress.street,
            'area': order.deliveryAddress.area,
            'governorate': order.deliveryAddress.governorate,
            'building': order.deliveryAddress.buildingNumber,
            'lat': order.deliveryAddress.lat,
            'lng': order.deliveryAddress.lng,
          },
          'payment_method': order.paymentMethod,
          'subtotal': order.subtotal,
          'delivery_fee': order.deliveryFee,
          'discount': order.discount,
        });
      } catch (e) {
        debugPrint('createOrder Supabase error: $e');
      }
    }
  }

  Future<void> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    String? driverId,
    String? driverName,
  }) async {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    _orders[idx].status = status;
    _orders[idx].updatedAt = DateTime.now();
    if (driverId != null) _orders[idx].driverId = driverId;
    if (driverName != null) _orders[idx].driverName = driverName;
    notifyListeners();

    if (SupabaseConfig.isConfigured) {
      try {
        final updateData = <String, dynamic>{
          'status': status.name,
          'updated_at': DateTime.now().toIso8601String(),
        };
        if (driverId != null) updateData['driver_id'] = driverId;
        if (driverName != null) updateData['driver_name'] = driverName;

        await SupabaseConfig.client
            .from('orders')
            .update(updateData)
            .eq('id', orderId);
      } catch (e) {
        debugPrint('updateOrderStatus Supabase error: $e');
      }
    }
  }

  int getTodayOrderCount(String restaurantId) {
    return _orders.where((o) => o.restaurantId == restaurantId).length;
  }

  double getTodaySales(String restaurantId) {
    return _orders
        .where(
          (o) =>
              o.restaurantId == restaurantId &&
              o.status != OrderStatus.cancelled,
        )
        .fold(0.0, (sum, o) => sum + o.total);
  }
}
