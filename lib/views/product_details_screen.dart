import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/models/product_model.dart';
import 'package:tdiscount_app/utils/widgets/product_images_viewer.dart';
import 'package:tdiscount_app/viewModels/product_viewmodel.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool descriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final productViewModel =
        Provider.of<ProductViewModel>(context, listen: false);

    String? formattedShortDescription;
    if (product.shortDescription != null &&
        product.shortDescription!.isNotEmpty) {
      formattedShortDescription = product.shortDescription!
          .split('-')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .join('\n');
    }

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
                        icon: const Icon(Icons.arrow_back,
                            color: TColors.textPrimary),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8.0),
                      const Expanded(
                        child: Text(
                          "Produit Details",
                          style: TextStyle(
                            color: TColors.textPrimary,
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
                  decoration: BoxDecoration(
                    color: themedColor(
                      context,
                      TColors.lightContainer,
                      TColors.darkContainer,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        // ignore: unnecessary_null_comparison
                        const SizedBox(height: 16),

                        product.imageUrls.isNotEmpty
                            ? ProductImagesViewer(imageUrls: product.imageUrls)
                            : const Placeholder(
                                fallbackHeight: 200,
                                fallbackWidth: double.infinity,
                              ),

                        const SizedBox(height: 16),

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
                        const SizedBox(height: 8), // Add some spacing
// SKU
                        if (product.sku != null && product.sku!.isNotEmpty)
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'SKU: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                TextSpan(
                                  text: product.sku,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 16),

// Ajouter au panier button
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
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () async {
                              final added = await productViewModel
                                  .addProductIdToCart(widget.product.id);

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    added
                                        ? '${product.name} ajouté au panier !'
                                        : 'Ce produit est déjà dans le panier.',
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Ajouter au panier',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        const Divider(
                            thickness: 1,
                            color: Colors.grey), // <-- Add this line
                        const SizedBox(height: 16),

                        // Caractéristique title
                        const Text(
                          'Caractéristique :',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Product Short Description (shortDescription variable)
                        if (formattedShortDescription != null &&
                            formattedShortDescription.isNotEmpty)
                          Text(
                            formattedShortDescription,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Coolvetica',
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        else
                          const Text(
                            'Aucune caractéristique disponible.',
                            style: TextStyle(fontSize: 16),
                          ),

                        const SizedBox(height: 16),

                        // Description title
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: TColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Product Description (description variable) with "Voir plus"
                        if (product.description != null &&
                            product.description!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.description!,
                                maxLines: descriptionExpanded ? null : 4,
                                overflow: descriptionExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              if (!descriptionExpanded)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          descriptionExpanded = true;
                                        });
                                      },
                                      child: const Text('Voir plus'),
                                    ),
                                  ],
                                ),
                            ],
                          )
                        else
                          const Text(
                            'Aucune description disponible.',
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
