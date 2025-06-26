import 'package:flutter/material.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';

class HorizontalProductCard extends StatelessWidget {
  final String imagePath;
  final String productName;
  final int quantity;
  final String price;
  final String? previousPrice;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;

  const HorizontalProductCard({
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: themedColor(context, TColors.cardlight, TColors.carddark),
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
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Details Column
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Row: Name and Remove Button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Second Row: Quantity Controls and Prices
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        size: 20,
                      ),
                      onPressed: onRemove,
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(fontSize: 12),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 20,
                      ),
                      onPressed: onAdd,
                    ),
                    const SizedBox(width: 0),
                    const Spacer(),
                    if (previousPrice != null)
                      Text(
                        previousPrice!,
                        style: const TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.red,
                          color: Colors.red,
                        ),
                      ),
                    if (previousPrice != null) const SizedBox(width: 8),
                    Text(
                      '$price TND',
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
          ),
        ],
      ),
    );
  }
}
