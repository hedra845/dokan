import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  /// استبدل هذا الرابط بعنوان مشروعك في Supabase
  /// You can find this in: Supabase Dashboard -> Project Settings -> API -> Project URL
  static const String supabaseUrl = 'https://jjqpgrgovjtlnbayrovr.supabase.co';

  /// استبدل هذا المفتاح بمفتاح anon public key
  /// You can find this in: Supabase Dashboard -> Project Settings -> API -> Project API keys (anon public)
  static const String supabaseAnonKey ='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpqcXBncmdvdmp0bG5iYXlyb3ZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTE5NDM4MzksImV4cCI6MjEwNzUxOTgzOX0.k6Vb3GM9-4J7Qv61FRFRyeWZwM-bDCJjRvWM02JRIFY';

  /// فحص إذا ما كان المستخدم قد قام بتهيئة المفاتيح الخاصة به
  static bool get isConfigured =>
      !supabaseUrl.contains('YOUR_PROJECT_REF') &&
      !supabaseAnonKey.contains('YOUR_SUPABASE_ANON_KEY');

  static SupabaseClient get client => Supabase.instance.client;
}
