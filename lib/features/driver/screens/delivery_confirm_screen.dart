import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/models/order.dart';

class DeliveryConfirmScreen extends StatelessWidget {
  final Order order;
  const DeliveryConfirmScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90, height: 90,
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 24),
              const Text('تم تسليم الطلب بنجاح! 🎉', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: kDark)),
              const SizedBox(height: 8),
              Text('رقم الطلب: ${order.shortId}', style: const TextStyle(color: kGrey, fontSize: 16)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: kOrangeLight, borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.monetization_on, color: kOrange),
                    SizedBox(width: 8),
                    Text('تمت إضافة 25 ج.م إلى رصيد محفظتك', style: TextStyle(fontWeight: FontWeight.bold, color: kDark)),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('العودة إلى الصفحة الرئيسية'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}