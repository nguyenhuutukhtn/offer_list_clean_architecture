import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the first offer, verify details, and go back',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify that we are on the offer listing page
      expect(find.text('Special Offers'), findsOneWidget);

      // Tap on the first offer
      await tester.tap(find.byType(OfferCard).first);
      await tester.pumpAndSettle();

      // Verify that we are on the offer details page
      expect(find.byType(OfferDetailsPage), findsOneWidget);

      // Verify the presence of certain widgets on the details page
      expect(find.text('Buy Now'), findsOneWidget);

      // Go back to the listing page
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Verify that we are back on the offer listing page
      expect(find.text('Special Offers'), findsOneWidget);
    });

    // Add more integration tests as needed
  });
}