import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/utils/widgets/custom_drawer.dart';
import 'package:tdiscount_app/utils/widgets/horizontal_product_card.dart';
import 'package:tdiscount_app/viewModels/product_viewmodel.dart';

class PanierScreen extends StatefulWidget {
  const PanierScreen({super.key});

  @override
  _PanierScreenState createState() => _PanierScreenState();
}

class _PanierScreenState extends State<PanierScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

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

    return Scaffold(
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
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : cartProducts.isEmpty
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
                            itemCount: cartProducts.length,
                            itemBuilder: (context, index) {
                              final product = cartProducts[index];
                              return HorizontalProductCard(
                                imagePath: product.imageUrls.isNotEmpty
                                    ? product.imageUrls.first
                                    : 'assets/images/placeholder.png',
                                productName: product.name,
                                quantity: 1,
                                price: product.price,
                                previousPrice: product.regularPrice,
                                onAdd: () {},
                                onRemove: () {},
                                onDelete: () async {
                                  await productViewModel
                                      .removeProductIdFromCart(product.id);
                                  // Optionally, show a snackbar
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${product.name} retiré du panier.')),
                                  );
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
