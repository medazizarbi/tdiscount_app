import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/views/product_details_screen.dart';
import 'package:tdiscount_app/views/sub_categorie.dart';
import 'package:tdiscount_app/utils/widgets/custom_drawer.dart'; // Import the custom drawer
import 'package:tdiscount_app/utils/widgets/carousel_widget.dart'; // Import the carousel widget
import 'package:tdiscount_app/utils/widgets/product_card.dart'; // Import the product card widget
import 'package:tdiscount_app/utils/widgets/category_card.dart'; // Import the category card widget
import 'package:tdiscount_app/utils/widgets/highlight_section.dart';
import '../viewmodels/category_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Color get backgroundColor =>
      themedColor(context, TColors.lightContainer, TColors.darkContainer);

  // Add a flag to track if data has been loaded
  bool _dataLoaded = false;

  // icons list
  final Map<int, String> categoryIcons = {
    347: "assets/images/white_cat_icons/tel.webp", // tel et tablettes
    204: "assets/images/white_cat_icons/electro.webp", // electro
    267: "assets/images/white_cat_icons/informatique.png", // informatique
    780: "assets/images/white_cat_icons/maison.png", // maison et bricolage
    407: "assets/images/white_cat_icons/printer.png", //impression
    696: "assets/images/black_cat_icons/t_shirt.png", // vetement et accessoires
    753: "assets/images/white_cat_icons/ordinateur.webp", // oridnateur bureau
    401: "assets/images/white_cat_icons/autre.png", //autres categories
    1337: "assets/images/black_cat_icons/bon-deal.png", // best deals
    323: "assets/images/black_cat_icons/home-cinema.png", // TV images son

    // Add more categoryId: imagePath pairs as needed
  };

  // Default icon path
  final String defaultCategoryIcon = "assets/images/white_cat_icons/autre.png";

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    // Only load data once when the widget is first created
    _loadDataOnce();
  }

  void _loadDataOnce() {
    if (!_dataLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final categoryViewModel =
            Provider.of<CategoryViewModel>(context, listen: false);

        try {
          // First, fetch regular categories if empty and not loading
          if (categoryViewModel.categories.isEmpty &&
              !categoryViewModel.isLoading) {
            await categoryViewModel.fetchCategories();
          }

          // Then, setup top 4 categories with their products (only after categories are loaded)
          if (categoryViewModel.topCategories.isEmpty &&
              !categoryViewModel.isTopCategoriesLoading) {
            await categoryViewModel.setupTopCategories();
          }

          // Finally, fetch trending products
          if (categoryViewModel.trendingProducts.isEmpty) {
            await categoryViewModel.fetchTrendingProducts();
          }
        } catch (e) {
          // Handle error silently or add proper error handling
        } finally {
          _dataLoaded = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final trendingProducts = categoryViewModel.trendingProducts;

    // Calculate the number of columns based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount =
        screenWidth > 600 ? 3 : 2; // 3 columns for tablets, 2 for phones

    return Scaffold(
      appBar: null,
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: TColors.primary,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: TColors.primary,
                    floating: true,
                    pinned: false,
                    automaticallyImplyLeading: false,
                    toolbarHeight: 70,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    flexibleSpace: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8),
                        child: Row(
                          children: [
                            // Drawer button
                            Builder(
                              builder: (context) => IconButton(
                                icon: const Icon(Icons.menu,
                                    color: Colors.black, size: 30),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                            ),
                            // Spacer to center the logo
                            const Spacer(),
                            // Centered Logo
                            Image.asset(
                              "assets/images/tdiscount_images/Logo-Tdiscount-market-noire.png",
                              height: 40, // Same size as FavorisScreen
                              fit: BoxFit.contain,
                            ),
                            // Spacer to balance the layout
                            const Spacer(),
                            // Empty container to balance the drawer button space
                            const SizedBox(
                                width: 48), // Same width as IconButton
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          color: TColors.primary,
                          padding: const EdgeInsets.all(1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              categoryViewModel.isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: TColors.black,
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: categoryViewModel.categories
                                            .map((category) => categoryItem(
                                                category.name,
                                                categoryIcons[category.id] ??
                                                    defaultCategoryIcon, // Use map or default
                                                category.id,
                                                category.count,
                                                categoryViewModel))
                                            .toList(),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ✅ White Widget for Product Display
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: backgroundColor, //gray
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            //padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ✅ Carousel with Padding
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: AutoScrollCarousel(
                                    onPageChanged: (index) {
                                      setState(() {});
                                    },
                                  ),
                                ),

                                const SizedBox(height: 0),

                                // ✅ "Meilleures Ventes" Section
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, left: 16, right: 16),
                                  child: Text(
                                    "Meilleures Ventes",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      // color: Colors.black,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 0),

                                // ✅ Dynamic GridView for Products
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16, left: 16, right: 16),
                                  child: categoryViewModel.isLoading ||
                                          trendingProducts.isEmpty
                                      ? const Column(
                                          children: [
                                            SizedBox(
                                                height:
                                                    24), // Add space above the progress indicator
                                            Center(
                                              child: CircularProgressIndicator(
                                                color: TColors.primary,
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    24), // Add space below the progress indicator
                                          ],
                                        )
                                      : GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                crossAxisCount, // Dynamic columns
                                            crossAxisSpacing: 15,
                                            mainAxisSpacing: 8,
                                            childAspectRatio:
                                                0.75, // Adjust as needed
                                          ),
                                          itemCount: trendingProducts.length,
                                          itemBuilder: (context, index) {
                                            final product =
                                                trendingProducts[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetailsScreen(
                                                            product: product),
                                                  ),
                                                );
                                              },
                                              child: ProductCard(
                                                productId: product.id,
                                                imageUrl: product
                                                        .imageUrls.isNotEmpty
                                                    ? product.imageUrls.first
                                                    : '',
                                                name: product.name,
                                                price: product.price,
                                                regularPrice:
                                                    product.regularPrice,
                                                // Add other fields if needed
                                              ),
                                            );
                                          },
                                        ),
                                ),

                                const SizedBox(height: 8),

                                // ✅ HighlightSection Widget (Full Width)
                                const HighlightSection(
                                  title: "Nouveautés",
                                  subtitle:
                                      "Découvrez les derniers produits - SAMSUNG",
                                  mainImage:
                                      "assets/images/samsung.png", // Replace with real URL
                                  products: [
                                    {
                                      "image": "assets/images/produit1.jpg",
                                      "name": "Samsung"
                                    },
                                    {
                                      "image": "assets/images/prod2.jpg",
                                      "name": "Samsung "
                                    },
                                    {
                                      "image": "assets/images/produit1.jpg",
                                      "name": "Samsung"
                                    },
                                  ],
                                  highlightColorBG: Colors
                                      .yellow, // Specify the background color here
                                ),

                                const SizedBox(height: 8),

                                // ✅ "Top Categories" Section
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    "Top Categories",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),
// ✅ Display Top 4 Category Cards from ViewModel
                                categoryViewModel.isTopCategoriesLoading
                                    ? const SizedBox(
                                        height: 170,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: TColors.primary,
                                          ),
                                        ),
                                      )
                                    : CategoryList(
                                        categories:
                                            categoryViewModel.topCategories,
                                      ),
                                const SizedBox(height: 18),

                                // ✅ Display Top Categories Products
                                ...categoryViewModel.topCategories
                                    .map((category) {
                                  final categoryProducts = categoryViewModel
                                      .getProductsForTopCategory(category.id);

                                  if (categoryProducts.isEmpty) {
                                    return const SizedBox
                                        .shrink(); // Don't show if no products
                                  }

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Category Name Title
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                category.name,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // Optional "See All" button
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) =>
                                                        SubCategorieScreen(
                                                      categoryId: category.id,
                                                      categoryName:
                                                          category.name,
                                                      categoryCount:
                                                          category.count,
                                                    ),
                                                    transitionsBuilder:
                                                        (context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child) {
                                                      const begin =
                                                          Offset(1.0, 0.0);
                                                      const end = Offset.zero;
                                                      const curve =
                                                          Curves.easeInOut;

                                                      var tween = Tween(
                                                              begin: begin,
                                                              end: end)
                                                          .chain(
                                                        CurveTween(
                                                            curve: curve),
                                                      );

                                                      var offsetAnimation =
                                                          animation
                                                              .drive(tween);

                                                      return SlideTransition(
                                                        position:
                                                            offsetAnimation,
                                                        child: child,
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                "Voir tout",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: themedColor(
                                                      context,
                                                      TColors.black,
                                                      TColors.primary),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Products Horizontal List
                                      SizedBox(
                                        height:
                                            250, // Increased height to accommodate content
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          itemCount: categoryProducts.length,
                                          itemBuilder: (context, index) {
                                            final product =
                                                categoryProducts[index];
                                            return Container(
                                              width:
                                                  180, // Increased width to prevent overflow
                                              margin: const EdgeInsets.only(
                                                  right: 12),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetailsScreen(
                                                              product: product),
                                                    ),
                                                  );
                                                },
                                                child: ProductCard(
                                                  productId: product.id,
                                                  imageUrl: product
                                                          .imageUrls.isNotEmpty
                                                      ? product.imageUrls.first
                                                      : '',
                                                  name: product.name,
                                                  price: product.price,
                                                  regularPrice:
                                                      product.regularPrice,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      const SizedBox(height: 20),
                                    ],
                                  );
                                }),

                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Nouveau footer Tdiscount
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          color: TColors.primary,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Tdiscount Marketplace",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: TColors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Bienvenue sur Tdiscount, la marketplace de référence pour la vente en ligne en Tunisie !\n\n"
                                "📦 Livraison rapide   💳 Paiement à la livraison   🔄 Retour et échange facilités\n"
                                "📞 Service client : +216 71 205 105",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: TColors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Adresse : 78, Rue des minéraux 8603 Z.I de la Charguia 1 2035 Tunis - Tunisie",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: TColors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Tdiscount © 2025 - Tous droits réservés | by ",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: TColors.black,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Add your custom action here when "iTrend" is tapped
                                    },
                                    child: const Text(
                                      "iTrend",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color.fromARGB(255, 180, 0, 0),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "contact@tdiscount.tn",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: TColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryItem(String label, String imagePath, int categoryId,
      int categoryCount, CategoryViewModel categoryViewModel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                SubCategorieScreen(
              categoryId: categoryId,
              categoryName: label,
              categoryCount: categoryCount,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // Start from the right
              const end = Offset.zero; // End at the current position
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );

              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: ClipOval(
                  child: SizedBox(
                    width: 45, // Adjust this value for the image size
                    height: 60,
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.white, // Force all icons to be white
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 75,
              height: 30,
              child: Tooltip(
                message: label,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.black, // <-- Set text color to black
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
