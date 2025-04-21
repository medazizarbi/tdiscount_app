import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/utils/widgets/product_card.dart';
import '../viewmodels/category_viewmodel.dart';

class SubCategoryProductsScreen extends StatefulWidget {
  final int subCategoryId;
  final String subCategoryName;

  const SubCategoryProductsScreen({
    super.key,
    required this.subCategoryId,
    required this.subCategoryName,
  });

  @override
  _SubCategoryProductsScreenState createState() =>
      _SubCategoryProductsScreenState();
}

class _SubCategoryProductsScreenState extends State<SubCategoryProductsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch products for the subcategory when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final categoryViewModel =
          Provider.of<CategoryViewModel>(context, listen: false);
      await categoryViewModel.fetchProductsBySubCategory(widget.subCategoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final products =
        categoryViewModel.productsBySubCategory[widget.subCategoryId] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCategoryName),
        backgroundColor: Colors.blue,
      ),
      body: categoryViewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : products.isEmpty
              ? const Center(
                  child: Text(
                    'No products found.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Adjust based on screen size
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      imageUrl:
                          product.imageUrl ?? 'https://via.placeholder.com/150',
                      name: product.name,
                      price: product.price.toString(),
                      regularPrice: product.regularPrice?.toString(),
                    );
                  },
                ),
    );
  }
}
