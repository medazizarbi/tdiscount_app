import 'package:flutter/material.dart';
import 'package:tdiscount_app/models/product_model.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';

class HorizontalProductCard extends StatelessWidget {
  final Product product;

  const HorizontalProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // Set the width of the card
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: TColors.darkContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade400, // Set the border color
          width: 1.5, // Set the border width
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              product.imageUrl ??
                  'https://via.placeholder.com/150', // Provide a default image URL if null
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          // Product Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              product.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          // Product Price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '${product.price} DT', // Display price with "DT" currency
              style: const TextStyle(
                fontSize: 12,
                color: TColors.textprice,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
