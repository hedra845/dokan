import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/data/mock_data.dart';

class DriverEarningsScreen extends StatelessWidget {
  const DriverEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final driver = MockData.mockDriver;

    return Scaffold(
      appBar: AppBar(title: const Text('إحصائياتي وأرباحي')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [kOrange, Color(0xFFD35400)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('إجمالي الأرباح المتاحة للسحب', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text('${driver.earnings.toStringAsFixed(0)} ج.م', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('إجمالي التوصيلات: ${driver.totalDeliveries}', style: const TextStyle(color: Colors.white, fontSize: 13)),
                      Text('التقييم: ${driver.rating} ⭐', style: const TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('سجل الرحلات الأخيرة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            _tripItem('#1050', 'مطعم أبو خالد', 'مدينة نصر', '25 ج.م'),
            _tripItem('#1049', 'ماكدونالدز', 'المعادي', '30 ج.م'),
            _tripItem('#1048', 'كنتاكي', 'التجمع الخامس', '25 ج.م'),
          ],
        ),
      ),
    );
  }

  static Widget _tripItem(String id, String from, String to, String earn) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: kOrangeLight, child: Icon(Icons.delivery_dining, color: kOrange)),
        title: Text('طلب $id • من $from'),
        subtitle: Text('إلى $to'),
        trailing: Text(earn, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 15)),
      ),
    );
  }
}