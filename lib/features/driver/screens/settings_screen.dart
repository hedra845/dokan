import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/services/auth_service.dart';
import 'package:flutter_application_5/models/driver_profile.dart';
import 'package:flutter_application_5/models/user.dart';
import 'package:flutter_application_5/data/mock_data.dart';

import 'package:flutter_application_5/features/customer/navigation/customer_nav.dart';
import 'package:flutter_application_5/features/restaurant/navigation/restaurant_nav.dart';
import 'package:flutter_application_5/features/auth/screens/role_selection_screen.dart';

class DriverSettingsScreen extends StatefulWidget {
  const DriverSettingsScreen({super.key});

  @override
  State<DriverSettingsScreen> createState() => _DriverSettingsScreenState();
}

class _DriverSettingsScreenState extends State<DriverSettingsScreen> {
  DriverProfile? _driverProfile;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final auth = context.read<AuthService>();
      final profile = await auth.fetchDriverProfile();
      if (!mounted) return;
      setState(() {
        _driverProfile = profile;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String get _driverName {
    return _driverProfile?.fullName.isNotEmpty ?? false
        ? _driverProfile!.fullName
        : MockData.mockDriver.name;
  }

  String get _driverPhone {
    return MockData.mockDriver.phone;
  }

  String get _vehicleInfo {
    if (_driverProfile?.vehicle != null) {
      final v = _driverProfile!.vehicle!;
      final type = v.vehicleType.isNotEmpty ? v.vehicleType : 'مركبة';
      final plate = v.plateNumber.isNotEmpty ? v.plateNumber : '';
      if (plate.isNotEmpty) return 'مركبة: $type ($plate)';
      return 'مركبة: $type';
    }
    return 'مركبة: ${MockData.mockDriver.vehicleType} (${MockData.mockDriver.vehiclePlate ?? ""})';
  }

  String get _statusText {
    if (_driverProfile == null) return '';
    switch (_driverProfile!.status) {
      case 'approved':
        return 'مندوب توصيل معتمد';
      case 'pending':
        return 'طلب التفعيل قيد المراجعة';
      case 'rejected':
        return 'تم رفض الطلب';
      case 'suspended':
        return 'الحساب موقوف';
      default:
        return _driverProfile!.status;
    }
  }

  Color get _statusColor {
    if (_driverProfile == null) return kOrange;
    switch (_driverProfile!.status) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.blue;
      case 'rejected':
      case 'suspended':
        return Colors.red;
      default:
        return kOrange;
    }
  }

  String get _avatarUrl => _driverProfile?.avatarUrl ?? '';

  bool get _isOnline => _driverProfile?.isOnline ?? MockData.mockDriver.isOnline;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('حساب المندوب'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1E2432),
        elevation: 1,
        bottom: _error != null
            ? PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Container(
                  color: Colors.red.shade50,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Text(
                      _error!,
                      style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (_isLoading && _driverProfile == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
                )
              else
                _buildProfileHeader(),
              const SizedBox(height: 24),
              _driverTile(Icons.assignment_ind_outlined, 'وثائق السائق ورخصة القيادة'),
              _driverTile(Icons.two_wheeler, 'بيانات المركبة واللوحات'),
              _driverTile(Icons.account_balance_wallet_outlined, 'بيانات الحساب البنكي والتحويل'),
              _driverTile(Icons.support_agent, 'الدعم الفني للطوارئ'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kOrange,
                    side: const BorderSide(color: kOrange),
                  ),
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('التبديل إلى حساب العميل أو المطعم'),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('اختر الحساب للتجربة',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: const Icon(Icons.person, color: kOrange),
                              title: const Text('تطبيق العميل (أحمد محمد)'),
                              onTap: () async {
                                Navigator.pop(context);
                                await auth.switchRole(UserRole.customer);
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (_) => const CustomerNav()),
                                    (route) => false,
                                  );
                                }
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.restaurant, color: Colors.deepOrange),
                              title: const Text('لوحة تحكم المطعم (مطعم أبو خالد)'),
                              onTap: () async {
                                Navigator.pop(context);
                                await auth.switchRole(UserRole.restaurant);
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (_) => const RestaurantNav()),
                                    (route) => false,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await auth.logout();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                        (route) => false,
                      );
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('تسجيل الخروج'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFEBEE),
                    foregroundColor: kRed,
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final ratingAvg = _driverProfile?.ratingAvg ?? MockData.mockDriver.rating;
    final ratingCount = _driverProfile?.ratingCount ?? MockData.mockDriver.totalDeliveries;

    return Column(
      children: [
        _buildAvatar(),
        const SizedBox(height: 12),
        Text(_driverName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        Text(_driverPhone, style: const TextStyle(color: kGrey)),
        const SizedBox(height: 4),
        Text(_vehicleInfo, style: const TextStyle(color: kGrey, fontSize: 13)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: _statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _statusText,
            style: TextStyle(
              color: _statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 20),
            const SizedBox(width: 4),
            Text(
              ratingAvg.toStringAsFixed(1),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2432)),
            ),
            const SizedBox(width: 8),
            Text(
              '$ratingCount تقييم',
              style: const TextStyle(color: kGrey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          _isOnline ? 'متاح الآن للتوصيل' : 'غير متاح',
          style: TextStyle(
            color: _isOnline ? Colors.green : Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    final url = _avatarUrl;
    if (url.isNotEmpty) {
      return CircleAvatar(
        radius: 46,
        backgroundImage: NetworkImage(url),
        onBackgroundImageError: (_, __) {},
        backgroundColor: kOrange,
        child: const SizedBox.shrink(),
      );
    }
    return const CircleAvatar(
      radius: 46,
      backgroundColor: kOrange,
      child: Icon(Icons.delivery_dining, size: 50, color: Colors.white),
    );
  }

  static Widget _driverTile(IconData icon, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: kOrange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kGrey),
      ),
    );
  }
}
