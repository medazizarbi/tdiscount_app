import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/utils/widgets/custom_drawer.dart';
import 'package:tdiscount_app/utils/widgets/filterbottomsheet.dart';
import 'package:tdiscount_app/utils/widgets/product_card.dart';
import 'package:tdiscount_app/viewModels/search_viewmodel.dart';
import 'package:tdiscount_app/views/product_details_screen.dart';
import 'package:tdiscount_app/viewmodels/category_viewmodel.dart';

class RechercheScreen extends StatefulWidget {
  const RechercheScreen({super.key});

  @override
  State<RechercheScreen> createState() => _RechercheScreenState();
}

class _RechercheScreenState extends State<RechercheScreen> {
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initialize category names for filter since categories are already loaded from home screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryVM = Provider.of<CategoryViewModel>(context, listen: false);
      categoryVM.initializeCategoryNamesForFilter();
    });
  }

  void _onScroll() {
    final searchVM = Provider.of<SearchViewModel>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        searchVM.hasMore &&
        !searchVM.isLoading &&
        searchVM.lastSearch.isNotEmpty) {
      searchVM.searchProducts(searchVM.lastSearch, isNewSearch: false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: TColors.primary,
          elevation: 0,
          title: Image.asset(
            "assets/images/tdiscount_images/Logo-Tdiscount-market-noire.png",
            height: 40,
            fit: BoxFit.contain,
          ),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: TColors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: const CustomDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            color: TColors.primary,
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: TColors.primary,
                  ),
                  child: const SizedBox(height: 20),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: themedColor(
                      context,
                      TColors.lightContainer,
                      TColors.darkContainer,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Title
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Chercher des produits",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      // Search field and filter button
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            // Search field - takes most of the space
                            Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                width: isSearching ? double.infinity : null,
                                child: Focus(
                                  onFocusChange: (hasFocus) {
                                    setState(() {
                                      isSearching = hasFocus;
                                    });
                                  },
                                  child: TextField(
                                    controller: _searchController,
                                    style: TextStyle(
                                      color: themedColor(
                                        context,
                                        TColors
                                            .textPrimary, // Light theme text color
                                        TColors
                                            .textPrimary, // Dark theme text color
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color.fromARGB(
                                          207, 255, 255, 255),
                                      hintText: "Chercher un produit",
                                      hintStyle: TextStyle(
                                        color: themedColor(
                                          context,
                                          TColors
                                              .textPrimary, // Light theme hint color
                                          TColors
                                              .textPrimary, // Dark theme hint color
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: themedColor(
                                          context,
                                          TColors
                                              .textPrimary, // Light theme icon color
                                          TColors
                                              .textPrimary, // Dark theme icon color
                                        ),
                                      ),
                                      suffixIcon: isSearching
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: themedColor(
                                                  context,
                                                  TColors
                                                      .textPrimary, // Light theme icon color
                                                  TColors
                                                      .textPrimary, // Dark theme icon color
                                                ),
                                              ),
                                              onPressed: () {
                                                _searchController.clear();
                                                FocusScope.of(context)
                                                    .unfocus();
                                                setState(() {
                                                  isSearching = false;
                                                });
                                                // Optionally clear results
                                                Provider.of<SearchViewModel>(
                                                        context,
                                                        listen: false)
                                                    .clearResults();
                                              },
                                            )
                                          : null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 16,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isSearching = true;
                                      });
                                    },
                                    onSubmitted: (value) {
                                      if (value.trim().isNotEmpty) {
                                        Provider.of<SearchViewModel>(context,
                                                listen: false)
                                            .searchProducts(value.trim());
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                                width: 12), // Space between search and filter
                            // Filter button - Always accessible
                            Consumer<CategoryViewModel>(
                              builder: (context, categoryVM, child) {
                                // Use the persistent list instead of calling the method each time
                                final availableCategories =
                                    categoryVM.categoryNamesForFilter;

                                return Container(
                                  decoration: BoxDecoration(
                                    color: TColors.primary,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => FilterBottomSheet(
                                          availableCategories:
                                              availableCategories,
                                        ),
                                      ).then((filterData) {
                                        if (filterData != null) {
                                          print("Applied filters: $filterData");
                                        }
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.filter_list_alt,
                                      color: TColors.darkerGrey,
                                    ),
                                    tooltip: "Filtres",
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      // Results
                      Consumer<SearchViewModel>(
                        builder: (context, searchVM, child) {
                          if (searchVM.isLoading &&
                              searchVM.searchResults.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 250.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: TColors.primary,
                                ),
                              ),
                            );
                          } else if (searchVM.errorMessage != null) {
                            return Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: Center(
                                child: Text(
                                  searchVM.errorMessage!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            );
                          } else if (searchVM.searchResults.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 250),
                              child: Center(
                                child: Text(
                                  "Aucun résultat trouvé.",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            final width = MediaQuery.of(context).size.width;
                            final crossAxisCount = width < 600 ? 2 : 3;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 12.0),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: searchVM.searchResults.length +
                                    (searchVM.hasMore ? 1 : 0),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.7,
                                ),
                                itemBuilder: (context, index) {
                                  if (index < searchVM.searchResults.length) {
                                    final product =
                                        searchVM.searchResults[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsScreen(
                                              product: product,
                                            ),
                                          ),
                                        );
                                      },
                                      child: ProductCard(
                                        productId: product.id,
                                        imageUrl: product.imageUrls.isNotEmpty
                                            ? product.imageUrls.first
                                            : '',
                                        name: product.name,
                                        price: product.price,
                                      ),
                                    );
                                  } else {
                                    // Loader at the end for pagination
                                    return const Center(
                                      child: CircularProgressIndicator(
                                          color: TColors.primary),
                                    );
                                  }
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
