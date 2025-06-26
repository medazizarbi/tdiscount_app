import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/viewModels/favorites_view_model.dart';
import 'package:tdiscount_app/utils/widgets/custom_drawer.dart';
import 'package:tdiscount_app/utils/widgets/product_card.dart';
import 'package:tdiscount_app/views/product_details_screen.dart';

class FavorisScreen extends StatefulWidget {
  const FavorisScreen({super.key});

  @override
  State<FavorisScreen> createState() => _FavorisScreenState();
}

class _FavorisScreenState extends State<FavorisScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

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

    // Fix: Delay loadFavorites until after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoriteViewModel>(context, listen: false).loadFavorites();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoriteViewModel>(context);
    final favoriteProducts = favoritesProvider.favoriteProducts;
    final isLoading = favoritesProvider.isLoading;

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
                child: Column(
                  children: [
                    // Back Button & Title Row
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Mes Favoris",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    if (isLoading)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (favoriteProducts.isEmpty)
                      Expanded(
                        child: SlideTransition(
                          position: _offsetAnimation,
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.favorite_border,
                                    size: 80,
                                    color: Color.fromARGB(137, 62, 62, 62)),
                                SizedBox(height: 16),
                                Text(
                                  "Aucun produit en favori.",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(137, 62, 62, 62)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: GridView.builder(
                            itemCount: favoriteProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.7,
                            ),
                            itemBuilder: (context, index) {
                              final product = favoriteProducts[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(
                                              product: product),
                                    ),
                                  );
                                },
                                child: ProductCard(
                                  productId: product.id,
                                  imageUrl: product.imageUrls.isNotEmpty
                                      ? product.imageUrls.first
                                      : 'assets/images/placeholder.png',
                                  name: product.name,
                                  price: product.price.toString(),
                                  //discountPercentage: product.discountPercentage,
                                  regularPrice: product.regularPrice,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
