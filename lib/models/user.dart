import 'package:flutter/material.dart';

enum UserRole { customer, restaurant, driver }

extension UserRoleExtension on UserRole {
  String get arabicName {
    switch (this) {
      case UserRole.customer:
        return 'عميل';
      case UserRole.restaurant:
        return 'مطعم';
      case UserRole.driver:
        return 'مندوب توصيل';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.customer:
        return Icons.person;
      case UserRole.restaurant:
        return Icons.restaurant;
      case UserRole.driver:
        return Icons.delivery_dining;
    }
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? avatarUrl;
  final String? restaurantId;
  final String? driverId;
  final bool emailVerified;
  final bool phoneVerified;
  final DateTime? createdAt;
  final String? approvalStatus;
  final String? preferredLanguage;
  final bool marketingOptIn;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarUrl,
    this.restaurantId,
    this.driverId,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.createdAt,
    this.approvalStatus,
    this.preferredLanguage,
    this.marketingOptIn = false,
  });

  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    bool? emailVerified,
    bool? phoneVerified,
    String? preferredLanguage,
    bool? marketingOptIn,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      restaurantId: restaurantId,
      driverId: driverId,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      createdAt: createdAt,
      approvalStatus: approvalStatus,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      marketingOptIn: marketingOptIn ?? this.marketingOptIn,
    );
  }
}
