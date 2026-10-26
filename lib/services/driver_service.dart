import 'package:flutter/foundation.dart';
import 'package:flutter_application_5/core/constants/supabase_config.dart';
import 'package:flutter_application_5/models/driver.dart';
import 'package:flutter_application_5/data/mock_data.dart';

class DriverService {
  Driver getDriver() => MockData.mockDriver;

  Future<void> toggleOnline(bool isOnline, {String? driverId}) async {
    MockData.mockDriver.isOnline = isOnline;

    if (SupabaseConfig.isConfigured && driverId != null) {
      try {
        await SupabaseConfig.client
            .from('driver_profiles')
            .update({'is_online': isOnline})
            .eq('user_id', driverId);
      } catch (e) {
        debugPrint('toggleOnline driver error: $e');
      }
    }
  }

  Future<void> addEarnings(double amount, {String? driverId}) async {
    MockData.mockDriver.earnings += amount;
    MockData.mockDriver.totalDeliveries += 1;

    if (SupabaseConfig.isConfigured && driverId != null) {
      try {
        await SupabaseConfig.client.rpc('increment_driver_earnings', params: {
          'driver_id_param': driverId,
          'amount_param': amount,
        });
      } catch (e) {
        debugPrint('addEarnings driver error: $e');
      }
    }
  }
}
