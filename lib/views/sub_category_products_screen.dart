import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/models/product_model.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/utils/widgets/product_card.dart';
import 'package:tdiscount_app/viewModels/category_viewmodel.dart';
import 'product_details_screen.dart';

class SubCategoryProductsScreen extends StatefulWidget {
  final int subCategoryId;
  final String subCategoryName;
  final int subCategoryCount;

  const SubCategoryProductsScreen({
    super.key,
    required this.subCategoryId,
    required this.subCategoryName,
    required this.subCategoryCount,
  });

  @override
  State<SubCategoryProductsScreen> createState() =>
      _SubCategoryProductsScreenState();
}

class _SubCategoryProductsScreenState extends State<SubCategoryProductsScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  void _initialize() {
    final viewModel = Provider.of<CategoryViewModel>(context, listen: false);

    // Assign the scroll controller (optional)
    viewModel.scrollController = _scrollController;

    // Attach the scroll listener once per screen
    _setupScrollListener(viewModel);

    // ✅ Only fetch if the category hasn't been fetched yet
    final alreadyLoaded =
        viewModel.productsBySubCategory[widget.subCategoryId]?.isNotEmpty ??
            false;
    if (!alreadyLoaded) {
      viewModel.fetchProductsByCategory(widget.subCategoryId);
    }
  }

  void _setupScrollListener(CategoryViewModel viewModel) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          viewModel.hasMoreProductsFor(widget.subCategoryId) &&
          !viewModel.isLoading) {
        viewModel.fetchProductsByCategory(widget.subCategoryId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CategoryViewModel>(context);
    final products =
        viewModel.productsBySubCategory[widget.subCategoryId] ?? [];
    final isLoadingMore = viewModel.isLoading && products.isNotEmpty;

    final subCategory = viewModel.subCategories.firstWhere(
      (subCategory) => subCategory.id == widget.subCategoryId,
      orElse: () => viewModel.subCategories.first,
    );

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
        color: TColors.primary,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: _whiteContainerDecoration(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _buildContent(
                    viewModel,
                    products,
                    isLoadingMore,
                    subCategory.description,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _whiteContainerDecoration() {
    return BoxDecoration(
      color: themedColor(
        context,
        TColors.lightContainer,
        TColors.darkContainer,
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    );
  }

  Widget _buildContent(
    CategoryViewModel viewModel,
    List<Product> products,
    bool isLoadingMore,
    String? subCategoryDescription,
  ) {
    if (viewModel.isLoading && products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (products.isEmpty) {
      return const Center(child: Text('No products found.'));
    }

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Center(
              child: Text(
                widget.subCategoryName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themedColor(
                    context,
                    TColors.textPrimary, // Black for light
                    TColors.textWhite, // White for dark
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          /*
          if (subCategoryDescription != null &&
              subCategoryDescription.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                subCategoryDescription,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Coolvetica',
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          */
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.7,
            ),
            itemCount: products.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= products.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: TColors.primary,
                    ),
                  ),
                );
              }
              return _buildProductCard(products[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(product: product),
        ),
      ),
      child: ProductCard(
        productId: product.id,
        imageUrl: product.imageUrls.first,
        name: product.name,
        price: product.price.toString(),
        regularPrice: product.regularPrice?.toString(),
      ),
    );
  }
}
