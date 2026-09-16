import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lime_demo_app/constants/test_keys.dart';
import 'package:lime_demo_app/screens/product_catalog_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _buildTestApp() => const MaterialApp(home: ProductCatalogScreen());

/// The grid builds lazily, so the default 800x600 surface only ever renders
/// the first row. Give it room for three rows of tiles.
Future<void> _pumpTallCatalog(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1200, 3000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(_buildTestApp());
  await tester.pumpAndSettle();
}

Future<void> _search(WidgetTester tester, String query) async {
  await tester.enterText(find.byKey(TestKeys.catalogSearchBar), query);
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('ProductCatalogScreen search', () {
    testWidgets('should match on the product name', (tester) async {
      await _pumpTallCatalog(tester);

      await _search(tester, 'denim');

      expect(find.text('Denim Dress'), findsOneWidget);
      expect(find.text('Casual Sundress'), findsNothing);
    });

    testWidgets('should show an empty state when nothing matches',
        (tester) async {
      await _pumpTallCatalog(tester);

      await _search(tester, 'zzzz');

      expect(find.text('No dresses found'), findsOneWidget);
    });

    // The next two pin deliberate defects - the colour synonyms in
    // _filteredAllProducts. Do not "fix" them without removing these tests.
    testWidgets('BUG: searching white should also surface red dresses',
        (tester) async {
      await _pumpTallCatalog(tester);

      await _search(tester, 'white');

      expect(find.text('White Linen Dress'), findsOneWidget);
      expect(find.text('Crochet White Dress'), findsOneWidget);
      expect(find.text('Red Evening Dress'), findsOneWidget,
          reason: 'the white/red synonym should leak a red dress in');
    });

    testWidgets('BUG: searching red should also surface black dresses',
        (tester) async {
      await _pumpTallCatalog(tester);

      await _search(tester, 'red');

      expect(find.text('Red Evening Dress'), findsOneWidget);
      expect(find.text('Black Sequin Mini'), findsOneWidget,
          reason: 'the red/black synonym should leak black dresses in');
      expect(find.text('Little Black Dress'), findsOneWidget);
    });
  });
}
