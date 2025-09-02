import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/utils/widgets/product_card.dart';
import 'package:tdiscount_app/utils/widgets/view_more_btn.dart';
import '../viewModels/category_viewmodel.dart';
import 'sub_category_products_screen.dart';

class SubCategorieScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final int categoryCount;

  const SubCategorieScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryCount,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SubCategorieScreenState createState() => _SubCategorieScreenState();
}

class _SubCategorieScreenState extends State<SubCategorieScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch subcategories and their products when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final categoryViewModel =
          Provider.of<CategoryViewModel>(context, listen: false);

      // Fetch subcategories
      await categoryViewModel.fetchSubCategories(
          widget.categoryId, widget.categoryName);

      // Fetch products for each subcategory
      for (var subCategory in categoryViewModel.subCategories) {
        await categoryViewModel.fetchProductsBySubCategory(subCategory.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Image.asset(
          "assets/images/tdiscount_images/Logo-Tdiscount-market-noire.png",
          height: 36,
        ),
      ),
      body: Container(
        color: TColors.primary, // Set the background color
        child: Column(
          children: [
            // White container for content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: themedColor(
                      context, TColors.lightContainer, TColors.darkContainer),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                          height: 20), // Add spacing below the banner

                      // Display the category name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Text(
                            widget.categoryName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: themedColor(context, TColors.textPrimary,
                                  TColors.textWhite),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 10), // Add spacing below the category name

                      // Display subcategories
                      categoryViewModel.isLoading
                          ? const Padding(
                              padding: EdgeInsets.only(top: 100.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: TColors.primary,
                                ),
                              ),
                            )
                          : categoryViewModel.subCategories.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'No subcategories found.',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: categoryViewModel.subCategories
                                      .map((subCategory) {
                                    final products =
                                        categoryViewModel.productsBySubCategory[
                                                subCategory.id] ??
                                            [];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: themedColor(
                                              context,
                                              TColors.lightContainer,
                                              const Color.fromARGB(
                                                  255, 29, 29, 29)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(1),
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // First Row: Subcategory Name and "View More" Button
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  subCategory.name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                ViewMoreButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SubCategoryProductsScreen(
                                                          subCategoryId:
                                                              subCategory.id,
                                                          subCategoryName:
                                                              subCategory.name,
                                                          subCategoryCount:
                                                              subCategory.count,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                                height:
                                                    10), // Space between rows

                                            // Second Row: Horizontal List of Products
                                            SizedBox(
                                              height:
                                                  250, // Adjust height for the ProductCard
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: products.length,
                                                itemBuilder: (context, index) {
                                                  final product =
                                                      products[index];
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        right:
                                                            8.0), // Add spacing between cards
                                                    child: SizedBox(
                                                      width:
                                                          200, // Set a fixed width for each ProductCard
                                                      child: ProductCard(
                                                        productId: product.id,
                                                        imageUrl: product
                                                            .imageUrls.first,
                                                        name: product.name,
                                                        price: product.price
                                                            .toString(),
                                                        regularPrice: product
                                                            .regularPrice
                                                            ?.toString(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
