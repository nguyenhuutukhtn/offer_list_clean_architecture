import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_app/main.dart' as app;
import 'package:mobile_app/presentation/pages/login_page.dart';
import 'package:mobile_app/presentation/pages/offer_listing_page.dart';
import 'package:mobile_app/presentation/pages/offer_details_page.dart';
import 'package:mobile_app/presentation/pages/purchase_history_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap through app navigation', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify that we start on the login page
      expect(find.byType(LoginPage), findsOneWidget);

      // Enter login credentials
      await tester.enterText(find.byKey(Key('emailField')), 'tu1@test.com');
      await tester.enterText(find.byKey(Key('passwordField')), '123456');
      await tester.tap(find.byKey(Key('loginButton')));
      await tester.pumpAndSettle();

      // Verify that we're now on the offer listing page
      expect(find.byType(OfferListingPage), findsOneWidget);

      // Tap on the first offer
      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();

      // Verify that we're now on the offer details page
      expect(find.byType(OfferDetailsPage), findsOneWidget);

      // Tap the 'Buy Now' button
      await tester.tap(find.text('Buy Now'));
      await tester.pumpAndSettle();

      // Verify the purchase confirmation dialog
      expect(find.text('Confirm Purchase'), findsOneWidget);
      await tester.tap(find.text('Buy'));
      await tester.pumpAndSettle();

      // Verify the success message
      expect(find.text('Purchase successful!'), findsOneWidget);

      // Go back to the offer listing page
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Open the drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to Purchase History
      await tester.tap(find.text('Purchase History'));
      await tester.pumpAndSettle();

      // Verify that we're on the purchase history page
      expect(find.byType(PurchaseHistoryPage), findsOneWidget);

      // Verify that the purchased offer is in the history
      expect(find.text('Test Offer'), findsOneWidget);

      // Log out
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      // Verify that we're back on the login page
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}