import 'package:flutter/material.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/models/product_model.dart'; // Import the Product model
import 'package:tdiscount_app/utils/widgets/product_images_viewer.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product; // Accept the product object

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Make the entire page scrollable
        child: Stack(
          children: [
            // Blue background
            Container(
              height: MediaQuery.of(context)
                  .size
                  .height, // Ensure it covers the full screen
              color: TColors.primary,
            ),
            // Content
            Column(
              children: [
                // Top section with back button and "Produit Details" title
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8.0),
                      const Expanded(
                        child: Text(
                          "Produit Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // White container with curved borders
                Container(
                  decoration: const BoxDecoration(
                    color: TColors.lightContainer,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Product Price
                        Row(
                          children: [
                            Text(
                              '${product.price} DT',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: TColors.textprice,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (product.regularPrice != null)
                              Text(
                                ' ${product.regularPrice} DT',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Product Image
                        // ignore: unnecessary_null_comparison
                        product.imageUrls.isNotEmpty
                            ? ProductImagesViewer(imageUrls: product.imageUrls)
                            : const Placeholder(
                                fallbackHeight: 200,
                                fallbackWidth: double.infinity,
                              ),

                        const SizedBox(height: 16),

                        // Product Description
                        if ((product.description != null &&
                                product.description!.isNotEmpty) ||
                            (product.shortDescription != null &&
                                product.shortDescription!.isNotEmpty)) ...[
                          if (product.shortDescription != null &&
                              product.shortDescription!.isNotEmpty)
                            Text(
                              product.shortDescription!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Coolvetica',
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          const SizedBox(height: 8),
                          if (product.description != null &&
                              product.description!.isNotEmpty)
                            Text(
                              product.description!,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic),
                            ),
                        ] else
                          const Text(
                            'No description available.',
                            style: TextStyle(fontSize: 16),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
