import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/utils/widgets/single_image_banner.dart';
import 'package:tdiscount_app/utils/widgets/horizontal_product_card.dart'; // Import the HorizontalProductCard widget
import 'package:tdiscount_app/utils/widgets/view_more_btn.dart'; // Import the ViewMoreButton
import '../viewmodels/category_viewmodel.dart';
import 'sub_category_products_screen.dart'; // Import the SubCategoryProductsScreen

class SubCategorieScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const SubCategorieScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          title: Text(widget.categoryName), // Display the category name
          centerTitle: false, // Align title to the left
          backgroundColor: TColors.primary,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add the banner at the top
            const SingleImageBanner(
                imagePath: 'assets/images/banner_example.png'),
            const SizedBox(height: 20), // Add spacing below the banner

            // Display the category name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.categoryName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10), // Add spacing below the category name

            // Display subcategories
            categoryViewModel.isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator(), // Show loading indicator
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
                        children:
                            categoryViewModel.subCategories.map((subCategory) {
                          final products = categoryViewModel
                                  .productsBySubCategory[subCategory.id] ??
                              [];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
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
                                  // First Row: Subcategory Name and "View More" Button
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                subCategoryId: subCategory.id,
                                                subCategoryName:
                                                    subCategory.name,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                      height: 10), // Space between rows

                                  // Second Row: Horizontal List of Products
                                  SizedBox(
                                    height:
                                        200, // Set height for the product list
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: products.length,
                                      itemBuilder: (context, index) {
                                        final product = products[index];
                                        return HorizontalProductCard(
                                            product: product);
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
    );
  }
}
