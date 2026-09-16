// End-to-end check that logging in lands on a drawn home screen with the
// welcome greeting on top.
//
// Run on a booted device:
//   flutter test integration_test/welcome_dialog_test.dart -d <device-id>
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:lime_demo_app/constants/app_constants.dart';
import 'package:lime_demo_app/constants/test_keys.dart';
import 'package:lime_demo_app/main.dart';
import 'package:lime_demo_app/services/local_storage_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await LocalStorageService.clearAll();
  });

  testWidgets('login greets the user over a loaded home screen',
      (tester) async {
    await tester.pumpWidget(const LimeDemoApp());
    // Splash holds for 2s before routing.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.byKey(TestKeys.loginButton), findsOneWidget);

    await tester.enterText(
        find.byKey(TestKeys.loginUsernameField), AppConstants.validUsername);
    await tester.enterText(
        find.byKey(TestKeys.loginPasswordField), AppConstants.validPassword);
    await tester.tap(find.byKey(TestKeys.loginButton));
    await tester.pumpAndSettle();

    // Home is rendered underneath, not replaced by the dialog.
    expect(find.text('Shop by Category'), findsOneWidget);
    expect(find.byKey(TestKeys.homeWelcomeDialog), findsOneWidget);
    expect(find.text('Welcome, Emma!'), findsOneWidget);

    await tester.tap(find.byKey(TestKeys.homeWelcomeContinueButton));
    await tester.pumpAndSettle();

    expect(find.byKey(TestKeys.homeWelcomeDialog), findsNothing);
    expect(find.text('Shop by Category'), findsOneWidget);
  });
}
