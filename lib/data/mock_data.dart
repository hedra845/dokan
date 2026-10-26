import 'package:flutter_application_5/models/user.dart';
import 'package:flutter_application_5/models/restaurant.dart';
import 'package:flutter_application_5/models/product.dart';
import 'package:flutter_application_5/models/category.dart';
import 'package:flutter_application_5/models/driver.dart';
import 'package:flutter_application_5/models/address.dart';

class MockData {
  static final List<User> users = [
    const User(
      id: 'c1',
      name: 'أحمد محمد',
      email: 'customer@test.com',
      phone: '01011111111',
      role: UserRole.customer,
      avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
    ),
    const User(
      id: 'r1',
      name: 'مطعم أبو خالد',
      email: 'restaurant@test.com',
      phone: '01022222222',
      role: UserRole.restaurant,
      restaurantId: 'rest1',
      avatarUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=150',
    ),
    const User(
      id: 'd1',
      name: 'محمد خالد',
      email: 'driver@test.com',
      phone: '01000000000',
      role: UserRole.driver,
      driverId: 'drv1',
      avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150',
    ),
  ];

  static final Driver mockDriver = Driver(
    id: 'drv1',
    userId: 'd1',
    name: 'محمد خالد',
    phone: '01000000000',
    rating: 4.8,
    totalDeliveries: 145,
    earnings: 3250.0,
    vehicleType: 'دراجة نارية',
    vehiclePlate: 'ب ج د 123',
    isOnline: true,
  );

  static final List<Category> categories = [
    const Category(id: 'cat1', name: 'برجر', emoji: '🍔'),
    const Category(id: 'cat2', name: 'بيتزا', emoji: '🍕'),
    const Category(id: 'cat3', name: 'شاورما', emoji: '🌯'),
    const Category(id: 'cat4', name: 'مشويات', emoji: '🍖'),
    const Category(id: 'cat5', name: 'حلويات', emoji: '🍰'),
    const Category(id: 'cat6', name: 'مشروبات', emoji: '🥤'),
    const Category(id: 'cat7', name: 'وجبات سريعة', emoji: '🍟'),
  ];

  static final List<Restaurant> restaurants = [
    Restaurant(
      id: 'rest1',
      name: 'مطعم أبو خالد',
      rating: 4.7,
      reviewCount: 328,
      deliveryTimeMin: 20,
      deliveryTimeMax: 35,
      deliveryFee: 20.0,
      distance: 1.2,
      isOpen: true,
      address: 'شارع عباس العقاد، مدينة نصر، القاهرة',
      categoryIds: ['cat1', 'cat4', 'cat6'],
      ownerId: 'r1',
      cuisine: 'برجر، مشويات، مشروبات',
      deliveryTime: '25',
      minimumOrder: 50,
    ),
    Restaurant(
      id: 'rest2',
      name: "ماكدونالدز McDonald's",
      rating: 4.5,
      reviewCount: 1240,
      deliveryTimeMin: 20,
      deliveryTimeMax: 30,
      deliveryFee: 15.0,
      distance: 2.1,
      isOpen: true,
      address: 'شارع النصر، المعادي، القاهرة',
      categoryIds: ['cat1', 'cat7', 'cat6'],
      ownerId: 'r2',
      cuisine: 'برجر، وجبات سريعة، مشروبات',
      deliveryTime: '25',
      minimumOrder: 40,
    ),
    Restaurant(
      id: 'rest3',
      name: 'كنتاكي KFC',
      rating: 4.4,
      reviewCount: 950,
      deliveryTimeMin: 25,
      deliveryTimeMax: 35,
      deliveryFee: 18.0,
      distance: 2.8,
      isOpen: true,
      address: 'شارع التسعين، التجمع الخامس',
      categoryIds: ['cat7', 'cat6'],
      ownerId: 'r3',
      cuisine: 'وجبات سريعة، مشروبات',
      deliveryTime: '30',
      minimumOrder: 60,
    ),
  ];

  static final List<Product> products = [
    Product(
      id: 'p1',
      restaurantId: 'rest1',
      categoryId: 'cat1',
      category: 'برجر',
      name: 'برجر لحم فاخر',
      description: 'برجر لحم طازج مع الجبن والخضار والصلصة الخاصة',
      price: 120.0,
      addons: const [
        ProductAddon(id: 'a1', name: 'جبنة إضافية', price: 15.0),
        ProductAddon(id: 'a2', name: 'صوص باربكيو', price: 10.0),
        ProductAddon(id: 'a3', name: 'بطاطس مقلية', price: 25.0),
      ],
    ),
    Product(
      id: 'p2',
      restaurantId: 'rest1',
      categoryId: 'cat1',
      category: 'برجر',
      name: 'برجر دجاج مقرمش',
      description: 'صدر دجاج مقرمش مع الخس وصلصة المايونيز والجبن',
      price: 95.0,
      addons: const [
        ProductAddon(id: 'a1', name: 'جبنة إضافية', price: 15.0),
        ProductAddon(id: 'a3', name: 'بطاطس مقلية', price: 25.0),
      ],
    ),
    Product(
      id: 'p3',
      restaurantId: 'rest1',
      categoryId: 'cat4',
      category: 'مشويات',
      name: 'مشاوي مشكل عائلي',
      description: 'تشكيلة كفتة وشيش طاووق وكباب مع الخبز والسلطات',
      price: 240.0,
    ),
    Product(
      id: 'p4',
      restaurantId: 'rest1',
      categoryId: 'cat6',
      category: 'مشروبات',
      name: 'كوكاكولا كانز',
      description: 'مشروب غازي بارد 330 مل',
      price: 20.0,
    ),
    Product(
      id: 'p5',
      restaurantId: 'rest2',
      categoryId: 'cat1',
      category: 'برجر',
      name: 'بيج ماك',
      description: 'شطيرتان من اللحم البقري المشوي مع الجبن وصلصة ماك الخاصة',
      price: 110.0,
    ),
    Product(
      id: 'p6',
      restaurantId: 'rest2',
      categoryId: 'cat7',
      category: 'وجبات سريعة',
      name: 'بطاطس مقلية كبيرة',
      description: 'بطاطس مقلية ذهبية مقرمشة',
      price: 35.0,
    ),
  ];

  static const Address defaultAddress = Address(
    id: 'addr1',
    label: 'المنزل',
    governorate: 'القاهرة',
    area: 'مدينة نصر',
    street: 'شارع عباس العقاد',
    buildingNumber: '15',
    floor: '3',
    apartment: '12',
    landmark: 'بجوار البنك الأهلي',
  );

  static List<String> favoriteRestaurantIds = ['rest1'];
}
