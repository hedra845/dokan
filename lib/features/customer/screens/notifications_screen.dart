import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';

/// Screen 10: Notifications Screen matching Reference Image Screen 10
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'تم تأكيد طلبك',
        'subtitle': 'طلبك من ماكدونالدز بقيمة 145 ج.م قيد التحضير الآن',
        'time': 'منذ 5 دقائق',
        'icon': Icons.check_circle_outline,
        'color': kEmeraldGreen,
      },
      {
        'title': 'عرض خاص',
        'subtitle': 'خصم 30% على وجبات البيتزا لفترة محدودة!',
        'time': 'منذ 30 دقيقة',
        'icon': Icons.local_offer_outlined,
        'color': kEmeraldGreen,
      },
      {
        'title': 'تم توصيل الطلب',
        'subtitle': 'تم توصيل طلبك بنجاح من مطعم كشري التحرير',
        'time': 'منذ ساعة',
        'icon': Icons.done_all,
        'color': kEmeraldGreen,
      },
      {
        'title': 'تحديثات التطبيق',
        'subtitle': 'تم إضافة ميزة جديدة لطرق الدفع الإلكتروني',
        'time': 'منذ 3 ساعات',
        'icon': Icons.system_update_alt,
        'color': kEmeraldGreen,
      },
      {
        'title': 'تنبيه',
        'subtitle': 'لقد انتهى عرض المطعم المفضل لديك، تابع للمزيد من العروض اليومية',
        'time': 'منذ 5 ساعات',
        'icon': Icons.notifications_active_outlined,
        'color': kEmeraldGreen,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('الإشعارات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: kDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(color: Color(0xFFEEEEEE), height: 20),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kEmeraldGreen, width: 1.3),
                ),
                child: Icon(item['icon'] as IconData, color: kEmeraldGreen, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['title'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kDark),
                        ),
                        Text(
                          item['time'] as String,
                          style: const TextStyle(fontSize: 11, color: kGrey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['subtitle'] as String,
                      style: const TextStyle(fontSize: 12, color: kGrey, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
