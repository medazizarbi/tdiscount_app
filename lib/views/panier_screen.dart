import 'package:flutter/material.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/utils/widgets/custom_drawer.dart';
import 'package:tdiscount_app/utils/widgets/horizontal_product_card.dart';

class PanierProductCard extends StatelessWidget {
  final String imagePath;
  final String productName;
  final int quantity;
  final double price;
  final double? previousPrice; // Optional previous price
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;

  const PanierProductCard({
    super.key,
    required this.imagePath,
    required this.productName,
    required this.quantity,
    required this.price,
    this.previousPrice,
    required this.onAdd,
    required this.onRemove,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class PanierScreen extends StatefulWidget {
  const PanierScreen({super.key});

  @override
  _PanierScreenState createState() => _PanierScreenState();
}

class _PanierScreenState extends State<PanierScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  // Simulated cart data
  final List<Map<String, dynamic>> cartItems = [
    {
      'imagePath': 'assets/images/produit1.jpg',
      'productName': 'Product 1 iehg rh hui  hui hui hui hui hui hui hui hui',
      'quantity': 2,
      'price': 20.0,
      'previousPrice': 25.0,
    },
    {
      'imagePath': 'assets/images/prod2.jpg',
      'productName': 'Product 2  hui  hui hui hui hui hui hui hui hui ',
      'quantity': 1,
      'price': 15.0,
      'previousPrice': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      _controller.forward();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primary,
        elevation: 0,
        title: Image.asset(
          "assets/images/tdiscount_images/Logo-Tdiscount-market-noire.png", // Your logo path
          height: 40,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: TColors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          color: TColors.primary,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: themedColor(
                      context, TColors.lightContainer, TColors.darkContainer),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: cartItems.isEmpty
                    ? SlideTransition(
                        position: _offsetAnimation,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined,
                                  size: 80,
                                  color: themedColor(
                                      context,
                                      TColors.textPrimary,
                                      TColors.textSecondary)),
                              const SizedBox(height: 16),
                              Text(
                                "Votre panier est vide.",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: themedColor(
                                        context,
                                        TColors.textPrimary,
                                        TColors.textSecondary)),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return HorizontalProductCard(
                            imagePath: item['imagePath'],
                            productName: item['productName'],
                            quantity: item['quantity'],
                            price: item['price'],
                            previousPrice: item['previousPrice'],
                            onAdd: () {
                              setState(() {
                                item['quantity']++;
                              });
                            },
                            onRemove: () {
                              setState(() {
                                if (item['quantity'] > 1) {
                                  item['quantity']--;
                                }
                              });
                            },
                            onDelete: () {
                              setState(() {
                                cartItems.removeAt(index);
                              });
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
