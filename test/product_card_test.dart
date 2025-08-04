import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/utils/widgets/product_card.dart';
import 'package:tdiscount_app/viewModels/favorites_view_model.dart';
import 'package:tdiscount_app/viewModels/product_viewmodel.dart';

void main() {
  group('ProductCard Widget', () {
    testWidgets('displays product info and reacts to taps',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => FavoriteViewModel()),
            ChangeNotifierProvider(create: (_) => ProductViewModel()),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ProductCard(
                productId: 1,
                imageUrl:
                    'https://tdiscount.tn/wp-content/uploads/2025/03/micro-onde-focus-fm250-25l-noir.jpg',
                name: 'TV TCL 32"',
                price: '799',
                regularPrice: '899',
                discountPercentage: '10%',
              ),
            ),
          ),
        ),
      );

      // Check product name and price
      expect(find.text('TV TCL 32"'), findsOneWidget);
      expect(find.text('TND '), findsOneWidget);
      expect(find.text('799'), findsOneWidget);
      expect(find.text('899'), findsOneWidget);
      expect(find.text('10%'), findsOneWidget);

      // Tap favorite icon
      final favoriteBtn = find.byKey(const Key('favorite_btn_1'));
      expect(favoriteBtn, findsOneWidget);
      await tester.tap(favoriteBtn);
      await tester.pumpAndSettle();

      // Tap add to cart icon
      final addToCartBtn = find.byKey(const Key('add_to_cart_btn_1'));
      expect(addToCartBtn, findsOneWidget);
      await tester.tap(addToCartBtn);
      await tester.pumpAndSettle();

      // Optionally, check for SnackBar or state changes if needed
    });
  });
}
