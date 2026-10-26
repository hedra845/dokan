import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_5/main.dart';
import 'package:flutter_application_5/services/auth_service.dart';

void main() {
  testWidgets('PhoenixApp smoke test', (WidgetTester tester) async {
    final auth = AuthService();
    await tester.pumpWidget(PhoenixApp(authService: auth));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.byType(PhoenixApp), findsOneWidget);
  });
}
