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

class HomeScreenState extends State<HomeScreen> {
  Color get backgroundColor =>
      themedColor(context, TColors.lightContainer, TColors.darkContainer);

  // List of items with title, description, and visibility control
  final List<Map<String, dynamic>> items = [
    {
      'title': 'LIVRAISON RAPIDE',
      'description':
          'Offrez-vous la livraison gratuite pour toutes vos commandes en ligne des maintenant! Ne manquez pas cette offre exceptionnelle pour faire des économies sur vos achats!',
      'showDescription': false,
    },
    {
      'title': 'GARANTIE',
      'description':
          'Offrez-vous la livraison gratuite pour toutes vos commandes en ligne des maintenant! Ne manquez pas cette offre exceptionnelle pour faire des économies sur vos achats!',
      'showDescription': false,
    },
    {
      'title': 'SERVICE CLIENT',
      'description':
          'Offrez-vous la livraison gratuite pour toutes vos commandes en ligne des maintenant! Ne manquez pas cette offre exceptionnelle pour faire des économies sur vos achats!',
      'showDescription': false,
    },
    {
      'title': 'SAV',
      'description':
          'Offrez-vous la livraison gratuite pour toutes vos commandes en ligne des maintenant! Ne manquez pas cette offre exceptionnelle pour faire des économies sur vos achats!',
      'showDescription': false,
    },
    {
      'title': 'CONTACTEZ-NOUS',
      'description':
          'Offrez-vous la livraison gratuite pour toutes vos commandes en ligne des maintenant! Ne manquez pas cette offre exceptionnelle pour faire des économies sur vos achats!',
      'showDescription': false,
    },
  ];

  // icons list
  final Map<int, String> categoryIcons = {
    347: "assets/images/white_cat_icons/tel.webp", // tel et tablettes
    204: "assets/images/white_cat_icons/electro.webp", // electro
    267: "assets/images/white_cat_icons/informatique.png", // informatique
    780: "assets/images/white_cat_icons/maison.png", // maison et bricolage
    407: "assets/images/white_cat_icons/printer.png", //impression
    696:
        "assets/images/white_cat_icons/vetement.webp", // vetement et accessoires
    753: "assets/images/white_cat_icons/ordinateur.webp", // oridnateur bureau
    401: "assets/images/white_cat_icons/autre.png", //autres categories

    // Add more categoryId: imagePath pairs as needed
  };

  // Default icon path
  final String defaultCategoryIcon = "assets/images/white_cat_icons/elec.png";

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryViewModel =
          Provider.of<CategoryViewModel>(context, listen: false);
      if (categoryViewModel.categories.isEmpty &&
          !categoryViewModel.isLoading) {
        categoryViewModel.fetchCategories();
      }
      if (categoryViewModel.trendingProducts.isEmpty) {
        categoryViewModel.fetchTrendingProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final trendingProducts =
        Provider.of<CategoryViewModel>(context).trendingProducts;

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
                            // Search bar (expand to fill available space)
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
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color.fromARGB(
                                          207, 255, 255, 255),
                                      hintText: "Chercher un produit",
                                      prefixIcon: const Icon(Icons.search,
                                          color: Colors.grey),
                                      suffixIcon: isSearching
                                          ? IconButton(
                                              icon: const Icon(Icons.close,
                                                  color: Colors.grey),
                                              onPressed: () {
                                                _searchController.clear();
                                                FocusScope.of(context)
                                                    .unfocus();
                                                setState(() {
                                                  isSearching = false;
                                                });
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
                                  ),
                                ),
                              ),
                            ),
                            // Logo (hide when searching)
                            if (!isSearching)
                              Image.asset(
                                "assets/images/tdiscount_images/Logo-Tdiscount-market-noire.png",
                                width: 120,
                                height: 60,
                                fit: BoxFit.contain,
                              ),
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

                                // ✅ Display Category Cards
                                const CategoryList(),

                                const SizedBox(height: 18),

                                // ✅ HighlightSection Widget (Full Width)
                                const HighlightSection(
                                  title: "Gaming",
                                  subtitle: "Plongez dans l'univers du gaming",
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
                                  highlightColorBG: Color.fromARGB(
                                      255,
                                      173,
                                      161,
                                      208), // Specify the background color here
                                ),

                                const SizedBox(height: 100),

                                //**** */
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // ✅ Display Titles with Buttons and Descriptions
                        ...items.map((item) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                color: TColors.primary,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Title
                                    Text(
                                      item['title'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: TColors.black,
                                      ),
                                    ),

                                    // Button to toggle description
                                    IconButton(
                                      icon: Icon(
                                        item['showDescription']
                                            ? Icons.keyboard_arrow_up_rounded
                                            : Icons.keyboard_arrow_down_rounded,
                                        color: TColors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          item['showDescription'] =
                                              !item['showDescription'];
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // Description (visible only if showDescription is true)
                              if (item['showDescription'])
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  color: TColors.primary,
                                  child: Text(
                                    item['description'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: TColors.black,
                                    ),
                                  ),
                                ),

                              // Divider
                              const Divider(
                                color: Color.fromARGB(86, 255, 255, 255),
                                thickness: 1,
                                height: 1,
                              ),
                            ],
                          );
                        }),

                        const SizedBox(height: 20), // Extra space at bottom
                        // ✅ Centered Image at the Bottom
                        const Center(
                          child: Text(
                            "Tdiscount", // Replace with your desired text
                            style: TextStyle(
                              fontSize: 20, // Adjust the font size as needed
                              fontWeight: FontWeight
                                  .bold, // You can adjust the font weight
                              color: TColors
                                  .black, // You can adjust the color of the text
                            ),
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Tdiscount © 2025 - Tous droits réservés | by ",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: TColors
                                      .black, // Adjust the color for the non-clickable part
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Add your custom action here when "trend" is tapped
                                },
                                child: const Text(
                                  "Trend", // The clickable word
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color.fromARGB(255, 180, 0,
                                        0), // The yellow color for "trend"
                                    fontWeight: FontWeight.bold,
                                  ),
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
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
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
