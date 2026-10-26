import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';

class RestaurantReportsScreen extends StatefulWidget {
  const RestaurantReportsScreen({super.key});

  @override
  State<RestaurantReportsScreen> createState() => _RestaurantReportsScreenState();
}

class _RestaurantReportsScreenState extends State<RestaurantReportsScreen> {
  int _selectedPeriodIndex = 0; // 0: أسبوعي, 1: شهري, 2: سنوي

  final List<Map<String, dynamic>> _daysData = const [
    {'day': 'السبت', 'val': 0.65, 'amount': '1,200'},
    {'day': 'الأحد', 'val': 0.85, 'amount': '1,650'},
    {'day': 'الاثنين', 'val': 0.40, 'amount': '800'},
    {'day': 'الثلاثاء', 'val': 0.95, 'amount': '1,850'},
    {'day': 'الأربعاء', 'val': 0.70, 'amount': '1,350'},
    {'day': 'الخميس', 'val': 1.00, 'amount': '2,100'},
    {'day': 'الجمعة', 'val': 0.80, 'amount': '1,550'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text(
          'التقارير والإحصائيات',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Period Filter Tabs
              _buildPeriodSelector(),
              const SizedBox(height: 18),

              // Hero Weekly Revenue Card
              _buildHeroCard(),
              const SizedBox(height: 16),

              // Quick Stat Cards (Orders count & Avg Order Value)
              Row(
                children: [
                  Expanded(
                    child: _buildMiniStatCard(
                      title: 'إجمالي الطلبات',
                      value: '260 طلب',
                      icon: Icons.receipt_long_rounded,
                      color: const Color(0xFF3B82F6),
                      change: '+8%',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMiniStatCard(
                      title: 'متوسط قيمة الطلب',
                      value: '135 ج.م',
                      icon: Icons.account_balance_wallet_outlined,
                      color: const Color(0xFF10B981),
                      change: '+4%',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sales Chart Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'نشاط المبيعات اليومي (آخر 7 أيام)',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildBarChart(),
              const SizedBox(height: 26),

              // Top Selling Items Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'الأصناف الأكثر طلباً',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    'عرض الكل',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: kOrange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildTopItemCard(
                rank: 1,
                name: 'برجر لحم فاخر',
                category: 'وجبات رئيسية',
                count: '120 طلب',
                total: '14,400 ج.م',
              ),
              const SizedBox(height: 10),
              _buildTopItemCard(
                rank: 2,
                name: 'برجر دجاج مقرمش',
                category: 'وجبات سريعة',
                count: '95 طلب',
                total: '9,025 ج.م',
              ),
              const SizedBox(height: 10),
              _buildTopItemCard(
                rank: 3,
                name: 'مشاوي مشكل عائلي',
                category: 'مشويات',
                count: '45 طلب',
                total: '10,800 ج.م',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['أسبوعي', 'شهري', 'سنوي'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: List.generate(periods.length, (index) {
          final isSelected = _selectedPeriodIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriodIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? kOrange : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: kOrange.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : [],
                ),
                child: Text(
                  periods[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFFF521B),
            Color(0xFFFF7A45),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF521B).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'إجمالي مبيعات الأسبوع',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '8,500',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'ج.م',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text(
                  '+12% مقارنة بالأسبوع الماضي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String change,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F2F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                change,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F2F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 170,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _daysData.map((item) {
                final double percent = item['val'] as double;
                final isHighest = percent == 1.0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Tooltip text on bar hover or highest
                    if (isHighest)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2432),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          item['amount'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 19),
                    // Bar
                    Container(
                      width: 26,
                      height: 115 * percent,
                      decoration: BoxDecoration(
                        gradient: isHighest
                            ? const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFFFF3E00), Color(0xFFFF7A45)],
                              )
                            : LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  kOrange.withValues(alpha: 0.9),
                                  kOrange.withValues(alpha: 0.75),
                                ],
                              ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isHighest
                            ? [
                                BoxShadow(
                                  color: kOrange.withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : [],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Day name
                    Text(
                      item['day'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isHighest ? FontWeight.bold : FontWeight.w600,
                        color: isHighest ? const Color(0xFF1F2937) : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopItemCard({
    required int rank,
    required String name,
    required String category,
    required String count,
    required String total,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F2F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rank == 1
                  ? const Color(0xFFFEF3C7)
                  : rank == 2
                      ? const Color(0xFFF3F4F6)
                      : const Color(0xFFFDF2E9),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: rank == 1
                      ? const Color(0xFFD97706)
                      : rank == 2
                          ? const Color(0xFF4B5563)
                          : const Color(0xFFEA580C),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Star Icon
          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 24),
          const SizedBox(width: 10),

          // Name and count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Revenue Total
          Text(
            total,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Color(0xFFFF521B),
            ),
          ),
        ],
      ),
    );
  }
}