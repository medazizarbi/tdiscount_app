import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/models/product_model.dart';
import 'package:tdiscount_app/utils/widgets/product_images_viewer.dart';
import 'package:tdiscount_app/utils/widgets/product_card.dart';
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
  void initState() {
    super.initState();
    _fetchRelatedProducts();
  }

  void _fetchRelatedProducts() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productViewModel =
          Provider.of<ProductViewModel>(context, listen: false);

      productViewModel.clearRelatedProducts();

      if (widget.product.hasRelatedProducts) {
        productViewModel.fetchRelatedProducts(widget.product.relatedIds);
      }
    });
  }

  bool _areRelatedProductsForCurrentProduct(ProductViewModel viewModel) {
    if (!widget.product.hasRelatedProducts) return false;
    if (viewModel.relatedProducts.isEmpty) return false;

    final currentRelatedIds = widget.product.relatedIds.toSet();
    final storedRelatedIds = viewModel.relatedProducts.map((p) => p.id).toSet();

    return currentRelatedIds.length == storedRelatedIds.length &&
        currentRelatedIds.every((id) => storedRelatedIds.contains(id));
  }

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: TColors.primary,
            elevation: 0,
            centerTitle: true,
            floating: true, // makes the app bar float
            pinned: false, // not pinned
            title: Image.asset(
              "assets/images/tdiscount_images/Logo-Tdiscount-market-noire.png",
              height: 40,
              fit: BoxFit.contain,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: TColors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            automaticallyImplyLeading: false,
          ),
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  color: TColors.primary,
                ),
                Column(
                  children: [
                    const SizedBox(
                        height: 20), // Space between app bar and white widget
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
                            const SizedBox(height: 16),
                            product.imageUrls.isNotEmpty
                                ? ProductImagesViewer(
                                    imageUrls: product.imageUrls)
                                : const Placeholder(
                                    fallbackHeight: 200,
                                    fallbackWidth: double.infinity,
                                  ),
                            const SizedBox(height: 16),
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 16),
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
                            const SizedBox(height: 8),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: () async {
                                  final added = await productViewModel
                                      .addProductIdToCart(widget.product.id);

                                  if (!mounted) return;

                                  // ignore: use_build_context_synchronously
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Divider(thickness: 1, color: Colors.grey),
                            if (formattedShortDescription != null &&
                                formattedShortDescription.isNotEmpty) ...[
                              Text(
                                'Caractéristique :',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? TColors.primary
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                formattedShortDescription,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Coolvetica',
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            if (product.description != null &&
                                product.description!.isNotEmpty) ...[
                              Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? TColors.primary
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                              ),
                            ],
                            if ((formattedShortDescription == null ||
                                    formattedShortDescription.isEmpty) &&
                                (product.description == null ||
                                    product.description!.isEmpty))
                              const Text(
                                'Aucune description disponible.',
                                style: TextStyle(fontSize: 16),
                              ),
                            const SizedBox(height: 20),
                            const Divider(thickness: 1, color: Colors.grey),
                            const SizedBox(height: 20),
                            if (widget.product.hasRelatedProducts) ...[
                              Text(
                                'Produits similaires',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? TColors.primary
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Consumer<ProductViewModel>(
                                builder: (context, viewModel, child) {
                                  if (viewModel.isLoadingRelatedProducts) {
                                    return const SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: TColors.primary,
                                        ),
                                      ),
                                    );
                                  }
                                  if (viewModel.relatedProductsError != null) {
                                    return SizedBox(
                                      height: 100,
                                      child: Center(
                                        child: Text(
                                          viewModel.relatedProductsError!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  if (!_areRelatedProductsForCurrentProduct(
                                      viewModel)) {
                                    return const SizedBox(
                                      height: 100,
                                      child: Center(
                                        child: Text(
                                          'Aucun produit similaire disponible.',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return SizedBox(
                                    height: 280,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          viewModel.relatedProducts.length,
                                      itemBuilder: (context, index) {
                                        final relatedProduct =
                                            viewModel.relatedProducts[index];

                                        // Default card width
                                        double cardWidth = 200.0;

                                        // Calculate extra width if price strings are long
                                        final priceLength = relatedProduct.price
                                            .toString()
                                            .length;
                                        final regularPriceLength =
                                            relatedProduct.regularPrice
                                                    ?.toString()
                                                    .length ??
                                                0;
                                        final maxPriceLength =
                                            priceLength > regularPriceLength
                                                ? priceLength
                                                : regularPriceLength;

                                        // Add extra space if price strings are long
                                        if (maxPriceLength >= 7) {
                                          cardWidth += 30;
                                        } else if (maxPriceLength >= 6) {
                                          cardWidth += 15;
                                        }

                                        return Container(
                                          width: cardWidth,
                                          margin:
                                              const EdgeInsets.only(right: 12),
                                          child: AspectRatio(
                                            aspectRatio: 0.65,
                                            child: GestureDetector(
                                              onTap: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetailsScreen(
                                                      product: relatedProduct,
                                                    ),
                                                  ),
                                                );
                                                if (mounted) {
                                                  _fetchRelatedProducts();
                                                }
                                              },
                                              child: ProductCard(
                                                productId: relatedProduct.id,
                                                imageUrl: relatedProduct
                                                        .imageUrls.isNotEmpty
                                                    ? relatedProduct
                                                        .imageUrls.first
                                                    : '',
                                                name: relatedProduct.name,
                                                price: relatedProduct.price,
                                                regularPrice:
                                                    relatedProduct.regularPrice,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          ],
                        ),
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
