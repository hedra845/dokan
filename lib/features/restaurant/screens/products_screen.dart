import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/services/product_service.dart';
import 'package:flutter_application_5/services/auth_service.dart';

class RestaurantProductsScreen extends StatefulWidget {
  const RestaurantProductsScreen({super.key});

  @override
  State<RestaurantProductsScreen> createState() => _RestaurantProductsScreenState();
}

class _RestaurantProductsScreenState extends State<RestaurantProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    final restaurantId = user?.restaurantId ?? 'rest1';
    final productService = context.read<ProductService>();
    final products = productService.getByRestaurant(restaurantId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المنتجات والقائمة'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kOrange,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('خاصية إضافة منتج جديد ستفتح النموذج')),
          );
        },
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, i) {
          final p = products[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                width: 50, height: 50,
                decoration: BoxDecoration(color: kOrangeLight, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.fastfood, color: kOrange),
              ),
              title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${p.price.toStringAsFixed(0)} ج.م • ${p.description}', maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: Switch(
                value: p.isAvailable,
                activeColor: kOrange,
                onChanged: (val) {
                  setState(() {
                    productService.toggleAvailability(p.id);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}