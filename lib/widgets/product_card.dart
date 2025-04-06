import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/Provider/favorites_provider.dart';

class ProductCard extends StatefulWidget {
  final String imagePath;
  final String name;
  final String price;
  final String? discount;
  final String? previousPrice;

  const ProductCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
    this.discount,
    this.previousPrice,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    bool isFavorite = favoritesProvider.isFavorite(widget.name);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  widget.imagePath,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    favoritesProvider.toggleFavorite(widget.name);
                  },
                ),
              ),
              if (widget.discount != null)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.discount!,
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
                if (widget.previousPrice != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'TND ${widget.previousPrice}',
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
                  onPressed: () {
                    // Ajouter au panier
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// List of products
final List<Map<String, String>> products = [
  {
    'imagePath': 'assets/produit1.jpg',
    'name': 'TV TCL 32"',
    'price': '799',
    //'previousPrice': '999', // Add previous price
  },
  {
    'imagePath': 'assets/prod2.jpg',
    'name': 'TV SAMSUNG',
    'price': '899',
    'discount': '-40%',
    'previousPrice': '1499', // Add previous price
  },
  {
    'imagePath': 'assets/prod2.jpg',
    'name': 'Sshfdiofdsk jsdhfosh jk jskdk  hs hD ',
    'price': '499',
    'discount': '-30%',
    'previousPrice': '699', // Add previous price
  },
  {
    'imagePath': 'assets/produit1.jpg',
    'name': 'PC Portable',
    'price': '1099',
    'discount': '-60%',
    'previousPrice': '2599', // Add previous price
  },
  {
    'imagePath': 'assets/produit1.jpg',
    'name': 'TV TCL 32"',
    'price': '799',
    //'previousPrice': '999', // Add previous price
  },
  {
    'imagePath': 'assets/prod2.jpg',
    'name': 'TV SAMSUNG',
    'price': '899',
    'discount': '-40%',
    'previousPrice': '1499', // Add previous price
  },
  {
    'imagePath': 'assets/prod2.jpg',
    'name': 'Sshfdiofdsk jsdhfosh jk jskdk  hs hD ',
    'price': '499',
    'discount': '-30%',
    'previousPrice': '699', // Add previous price
  },
  {
    'imagePath': 'assets/produit1.jpg',
    'name': 'PC Portable',
    'price': '1099',
    'discount': '-60%',
    'previousPrice': '2599', // Add previous price
  },
  {
    'imagePath': 'assets/produit1.jpg',
    'name': 'TV TCL 32"',
    'price': '799',
    //'previousPrice': '999', // Add previous price
  },
  {
    'imagePath': 'assets/prod2.jpg',
    'name': 'TV SAMSUNG',
    'price': '899',
    'discount': '-40%',
    'previousPrice': '1499', // Add previous price
  },
  {
    'imagePath': 'assets/prod2.jpg',
    'name': 'Sshfdiofdsk jsdhfosh jk jskdk  hs hD ',
    'price': '499',
    'discount': '-30%',
    'previousPrice': '699', // Add previous price
  },
  {
    'imagePath': 'assets/produit1.jpg',
    'name': 'PC Portable',
    'price': '1099',
    'discount': '-60%',
    'previousPrice': '2599', // Add previous price
  },
];
