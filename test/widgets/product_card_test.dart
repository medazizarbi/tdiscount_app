import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/utils/widgets/product_card.dart';
import 'package:tdiscount_app/viewModels/favorites_view_model.dart';
import 'package:tdiscount_app/viewModels/product_viewmodel.dart';

void main() {
  testWidgets('ProductCard displays long prices without overflow',
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
              name: 'Test Product',
              price: '11.900',
              regularPrice: '29.900',
              discountPercentage: '10%',
            ),
          ),
        ),
      ),
    );

    // Check that both prices are displayed
    expect(find.text('11.900'), findsOneWidget); // main price
    expect(find.text('TND 29.900'), findsOneWidget); // regular price

    // Check that the product name is displayed
    expect(find.text('Test Product'), findsOneWidget);

    // Optionally, check that no overflow error is present
    expect(find.byType(OverflowBar), findsNothing);
    expect(find.byType(OverflowBox), findsNothing);
  });

  testWidgets('ProductCard displays very long prices without overflow',
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
              productId: 2,
              imageUrl:
                  'https://tdiscount.tn/wp-content/uploads/2025/03/micro-onde-focus-fm250-25l-noir.jpg',
              name: 'Long Price Product',
              price: '166620.900',
              regularPrice: '142860.900',
              discountPercentage: '15%',
            ),
          ),
        ),
      ),
    );

    // Check that both long prices are displayed
    expect(find.text('120.900'), findsOneWidget); // main price
    expect(find.text('TND 140.900'), findsOneWidget); // regular price

    // Check that the product name is displayed
    expect(find.text('Long Price Product'), findsOneWidget);

    // Optionally, check that no overflow error is present
    expect(find.byType(OverflowBar), findsNothing);
    expect(find.byType(OverflowBox), findsNothing);
  });

  testWidgets('ProductCard displays extremely long prices without overflow',
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
              productId: 3,
              imageUrl:
                  'https://tdiscount.tn/wp-content/uploads/2025/03/micro-onde-focus-fm250-25l-noir.jpg',
              name: 'Extreme Price Product',
              price: '1234567890.900',
              regularPrice: '9876543210.900',
              discountPercentage: '20%',
            ),
          ),
        ),
      ),
    );

    // Check that both extremely long prices are displayed
    expect(find.text('1234567890.900'), findsOneWidget); // main price
    expect(find.text('TND 9876543210.900'), findsOneWidget); // regular price

    // Check that the product name is displayed
    expect(find.text('Extreme Price Product'), findsOneWidget);

    // Optionally, check that no overflow error is present
    expect(find.byType(OverflowBar), findsNothing);
    expect(find.byType(OverflowBox), findsNothing);
  });
}
