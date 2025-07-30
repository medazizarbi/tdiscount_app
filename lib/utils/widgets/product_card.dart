import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/viewModels/favorites_view_model.dart';
import 'package:tdiscount_app/viewModels/product_viewmodel.dart';

class ProductCard extends StatefulWidget {
  final int productId; // <-- Add this line
  final String imageUrl;
  final String name;
  final String price;
  final String? discountPercentage; // Optional discount percentage
  final String? regularPrice; // Optional regular price

  const ProductCard({
    super.key,
    required this.productId, // <-- Add this line
    required this.imageUrl,
    required this.name,
    required this.price,
    this.discountPercentage,
    this.regularPrice,
  });

  @override
  ProductCardState createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoriteViewModel>(context);
    final int productId = widget.productId; // <-- Use the real productId
    bool isFavorite = favoritesProvider.isFavorite(productId);

    return Container(
      decoration: BoxDecoration(
        color: themedColor(context, TColors.cardlight, TColors.cardlight),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.imageUrl,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 150,
                      height: 150,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'TND ',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        widget.price,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      if (widget.regularPrice != null &&
                          double.tryParse(
                                  widget.regularPrice!.replaceAll(',', '.')) !=
                              null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'TND ${widget.regularPrice}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 109, 109, 109),
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 124, 124, 124)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.blue,
                          size: 24,
                        ),
                        onPressed: () async {
                          // Access your ProductViewModel
                          final productViewModel =
                              Provider.of<ProductViewModel>(context,
                                  listen: false);
                          final added = await productViewModel
                              .addProductIdToCart(widget.productId);

                          if (!mounted) return;

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                added
                                    ? '${widget.name} ajouté au panier !'
                                    : 'Ce produit est déjà dans le panier.',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Heart icon at top right of the card (not just the image)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? TColors.textprice : TColors.buttonSecondary,
                size: 24,
              ),
              onPressed: () async {
                await favoritesProvider.toggleFavorite(productId);
                setState(() {}); // Refresh UI after toggling
              },
            ),
          ),
          if (widget.discountPercentage != null)
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.discountPercentage!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// List of products
final List<Map<String, String?>> products = [
  {
    'imageUrl':
        'https://tdiscount.tn/wp-content/uploads/2025/03/micro-onde-focus-fm250-25l-noir.jpg',
    'name': 'TV TCL 32"',
    'price': '799',
    'regularPrice': '11.55', // Add previous price
    'sku': 'TV-TCL-32-2025', // Add SKU
  },
  {
    'imageUrl':
        'https://tdiscount.tn/wp-content/uploads/2025/03/micro-onde-focus-fm250-25l-noir.jpg',
    'name': 'TV SAMSUNG',
    'price': '899',
    'regularPrice': '11,55', // Add previous price
  },
  {
    'imageUrl':
        'https://tdiscount.tn/wp-content/uploads/2025/03/micro-onde-focus-fm250-25l-noir.jpg',
    'name': 'Sshfdiofdsk jsdhfosh jk jskdk  hs hD ',
    'price': '499',
    'regularPrice': '699', // Add previous price
  },
  {
    'imageUrl':
        'https://tdiscount.tn/wp-content/uploads/2025/03/micro-onde-focus-fm250-25l-noir.jpg',
    'name': 'PC Portable',
    'price': '1099',
    'regularPrice': '2599', // Add previous price
  },
  {
    'imageUrl':
        'https://tdiscount.tn/wp-content/uploads/2025/03/micro-onde-focus-fm250-25l-noir.jpg',
    'name': 'Sshfdiofdsk jsdhfosh jk jskdk  hs hD ',
    'price': '499',
    'regularPrice': '699', // Add previous price
  },
  {
    'imageUrl':
        'https://tdiscount.tn/wp-content/uploads/2025/03/micro-onde-focus-fm250-25l-noir.jpg',
    'name': 'PC Portable',
    'price': '1099',
    'regularPrice': '2599', // Add previous price
  },
];
