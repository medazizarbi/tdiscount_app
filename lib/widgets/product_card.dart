import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String price;
  final String? discount;
  final String? previousPrice; // Add previousPrice parameter

  const ProductCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
    this.discount,
    this.previousPrice, // Initialize previousPrice
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image with Heart Button
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  // Add to favorites logic here
                },
              ),
            ),
            if (discount != null)
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
                    discount!,
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

        // Price with Currency and Previous Price
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Currency Text (TND)
              const Text(
                'TND ',
                style: TextStyle(
                  fontSize: 14, // Smaller than the price
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // Price Text
              Text(
                price,
                style: const TextStyle(
                  fontSize: 17, // Larger than the currency
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // Previous Price (if exists)
              if (previousPrice != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'TND $previousPrice', // Display previous price with currency
                    style: const TextStyle(
                      fontSize: 12, // Smaller than the current price
                      color: Color.fromARGB(255, 109, 109, 109),
                      decoration: TextDecoration.lineThrough, // Strikethrough
                      decorationColor: Colors.red, // Red strikethrough line
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Name and Add to Cart Button (in the same row)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Product Name (with constraints)
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 124, 124, 124),
                  ),
                  overflow: TextOverflow.ellipsis, // Truncate long text
                  maxLines: 2, // Ensure text doesn't wrap
                ),
              ),

              // Add to Cart Button (Cart Icon)
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.blue, // Adjust the color as needed
                  size: 24,
                ),
                onPressed: () {
                  // Add to cart logic here
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// List of products
final List<Map<String, String>> products = [
  {
    'imagePath': 'assets/produit1.jpg',
    'name': 'TV TCL 32"',
    'price': '799',
    'previousPrice': '999', // Add previous price
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
