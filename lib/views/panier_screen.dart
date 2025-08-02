import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/utils/widgets/custom_drawer.dart';
import 'package:tdiscount_app/utils/widgets/horizontal_product_card.dart';
import 'package:tdiscount_app/viewModels/product_viewmodel.dart';
import 'package:tdiscount_app/views/order_info_screen.dart';

class PanierScreen extends StatefulWidget {
  const PanierScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PanierScreenState createState() => _PanierScreenState();
}

class _PanierScreenState extends State<PanierScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productViewModel =
          Provider.of<ProductViewModel>(context, listen: false);
      productViewModel.fetchAllCartProducts();
    });

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
    final productViewModel = Provider.of<ProductViewModel>(context);
    final cartProducts = productViewModel.cartProducts;
    final isLoading = productViewModel.isLoading;

    if (cartProducts.isEmpty) {
      _controller.forward();
    }

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: TColors.primary,
          elevation: 0,
          title: Image.asset(
            "assets/images/tdiscount_images/Logo-Tdiscount-market-noire.png",
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: themedColor(
                        context, TColors.lightContainer, TColors.darkContainer),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Title Row
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Mon Panier",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 250),
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: TColors.primary)),
                        )
                      else if (cartProducts.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 100),
                          child: SlideTransition(
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
                                    "Votre panier est vide !",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: themedColor(
                                            context,
                                            TColors.textPrimary,
                                            TColors.textSecondary)),
                                  ),
                                  const SizedBox(height: 300),
                                ],
                              ),
                            ),
                          ),
                        )
                      else ...[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartProducts.length,
                          itemBuilder: (context, index) {
                            final product = cartProducts[index];
                            return HorizontalProductCard(
                              imagePath: product.imageUrls.isNotEmpty
                                  ? product.imageUrls.first
                                  : 'assets/images/placeholder.png',
                              productName: product.name,
                              price: product.price,
                              previousPrice: product.regularPrice,
                              quantity:
                                  productViewModel.cartQuantities[product.id] ??
                                      1,
                              onQuantityChanged: (newQty) {
                                productViewModel.updateProductQuantity(
                                    product.id, newQty);
                              },
                              onDelete: () async {
                                await productViewModel
                                    .removeProductIdFromCart(product.id);
                                _scaffoldMessengerKey.currentState
                                    ?.showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          '${product.name} retiré du panier.')),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Divider(
                          color: themedColor(context, TColors.textPrimary,
                              TColors.textSecondary),
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                        // Total section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            color: themedColor(context, TColors.lightContainer,
                                TColors.darkContainer),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total :",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: themedColor(
                                          context,
                                          TColors.textPrimary,
                                          TColors.textSecondary),
                                    ),
                                  ),
                                  Text(
                                    "${productViewModel.totalPrice.toStringAsFixed(3)} TND",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Vous économisez :",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: themedColor(context, Colors.red,
                                          Colors.red.shade200),
                                    ),
                                  ),
                                  Text(
                                    "${productViewModel.totalEconomy.toStringAsFixed(3)} TND",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: themedColor(context, Colors.red,
                                          Colors.red.shade200),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: TColors.primary,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderInfoScreen(
                                          products:
                                              productViewModel.cartProducts,
                                          quantities: Map<int, int>.from(
                                              productViewModel.cartQuantities),
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Completer votre commande',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
