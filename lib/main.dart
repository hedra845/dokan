import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_5/core/constants/supabase_config.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/services/auth_service.dart';
import 'package:flutter_application_5/services/order_service.dart';
import 'package:flutter_application_5/services/cart_service.dart';
import 'package:flutter_application_5/services/restaurant_service.dart';
import 'package:flutter_application_5/services/product_service.dart';
import 'package:flutter_application_5/services/driver_service.dart';
import 'package:flutter_application_5/features/auth/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Initialize Supabase if configured
  if (SupabaseConfig.isConfigured) {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        publishableKey: SupabaseConfig.supabaseAnonKey,
      );
    } catch (e) {
      debugPrint('Supabase initialization error: $e');
    }
  }

  final authService = AuthService();
  await authService.loadSavedSession();

  runApp(PhoenixApp(authService: authService));
}

class PhoenixApp extends StatelessWidget {
  final AuthService authService;
  const PhoenixApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider(create: (_) => OrderService()),
        ChangeNotifierProvider(create: (_) => CartService()),
        Provider(create: (_) => RestaurantService()),
        Provider(create: (_) => ProductService()),
        Provider(create: (_) => DriverService()),
      ],
      child: MaterialApp(
        title: 'Phoenix Systems Food Delivery',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        builder: (context, child) => Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
