import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/models/order_item.dart';
import 'package:flutter_application_5/models/address.dart';

enum OrderStatus {
  pending,
  accepted,
  preparing,
  ready,
  driverAssigned,
  pickedUp,
  onTheWay,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get arabicName {
    switch (this) {
      case OrderStatus.pending:
        return 'جديد';
      case OrderStatus.accepted:
        return 'تم قبول الطلب';
      case OrderStatus.preparing:
        return 'جاري التحضير';
      case OrderStatus.ready:
        return 'جاهز للتسليم';
      case OrderStatus.driverAssigned:
        return 'السائق في الطريق للمطعم';
      case OrderStatus.pickedUp:
        return 'تم استلام الطلب';
      case OrderStatus.onTheWay:
        return 'في الطريق إليك';
      case OrderStatus.delivered:
        return 'تم التوصيل';
      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
      case OrderStatus.accepted:
      case OrderStatus.preparing:
      case OrderStatus.ready:
      case OrderStatus.driverAssigned:
      case OrderStatus.pickedUp:
      case OrderStatus.onTheWay:
      case OrderStatus.delivered:
        return kEmeraldGreen;
      case OrderStatus.cancelled:
        return const Color(0xFFEF4444);
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.pending:
        return Icons.access_time;
      case OrderStatus.accepted:
        return Icons.check_circle_outline;
      case OrderStatus.preparing:
        return Icons.restaurant;
      case OrderStatus.ready:
        return Icons.done_all;
      case OrderStatus.driverAssigned:
        return Icons.delivery_dining;
      case OrderStatus.pickedUp:
        return Icons.shopping_bag;
      case OrderStatus.onTheWay:
        return Icons.directions_bike;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  bool get isActive => this != OrderStatus.delivered && this != OrderStatus.cancelled;
}

class Order {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String restaurantId;
  final String restaurantName;
  final String restaurantAddress;
  final double restaurantLat;
  final double restaurantLng;
  String? driverId;
  String? driverName;
  final List<OrderItem> items;
  OrderStatus status;
  final Address deliveryAddress;
  final String paymentMethod;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final DateTime createdAt;
  DateTime? updatedAt;

  Order({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.customerPhone = '01011111111',
    required this.restaurantId,
    required this.restaurantName,
    this.restaurantAddress = 'شارع عباس العقاد، مدينة نصر، القاهرة',
    this.restaurantLat = 30.0560,
    this.restaurantLng = 31.3300,
    this.driverId,
    this.driverName,
    required this.items,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.subtotal,
    required this.deliveryFee,
    this.discount = 0,
    required this.createdAt,
    this.updatedAt,
  });

  double get total => subtotal + deliveryFee - discount;
  double get totalPrice => total;
  String get shortId => id.length > 4 ? '#${id.substring(id.length - 4)}' : '#$id';
}
