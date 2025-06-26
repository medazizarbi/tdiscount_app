import 'package:flutter/material.dart';

// dont use this file directly, use the horizantal product cart instead widget in your panier_screen.dart
class PanierProductCard extends StatelessWidget {
  final String imagePath;
  final String productName;
  final int quantity;
  final double price;
  final double? previousPrice; // Optional previous price
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const PanierProductCard({
    super.key,
    required this.imagePath,
    required this.productName,
    required this.quantity,
    required this.price,
    this.previousPrice,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Image.asset(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 12),

          // Name Section
          Expanded(
            flex: 2,
            child: Text(
              productName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Quantity and Price Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Quantity and Price in the Same Row
              Row(
                children: [
                  // "-" Button
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: onRemove,
                  ),
                  // Quantity
                  Text(
                    '$quantity',
                    style: const TextStyle(fontSize: 16),
                  ),
                  // "+" Button
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: onAdd,
                  ),
                  const SizedBox(
                      width: 12), // Spacing between quantity and price
                  // Price Row (Previous Price + Actual Price)
                  if (previousPrice != null)
                    Text(
                      '\$${previousPrice!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.red,
                      ),
                    ),
                  if (previousPrice != null)
                    const SizedBox(width: 8), // Spacing
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
