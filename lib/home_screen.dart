import 'package:flutter/material.dart';
import 'package:tdiscount_app/custom_drawer.dart'; // Import the custom drawer
import 'package:tdiscount_app/widgets/carousel_widget.dart'; // Import the carousel widget
import 'package:tdiscount_app/widgets/product_card.dart'; // Import the product card widget
import 'package:tdiscount_app/widgets/category_card.dart'; // Import the category card widget
import 'package:tdiscount_app/widgets/highlight_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryColor = const Color(0xFF006D77);
  final Color backgroundColor = Colors.grey[300]!; // Add this line
  int _currentPage = 0; // Track the current page index

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

  @override
  Widget build(BuildContext context) {
    // Calculate the number of columns based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount =
        screenWidth > 600 ? 3 : 2; // 3 columns for tablets, 2 for phones

    return Scaffold(
      appBar: null,
      drawer: const CustomDrawer(), // Replace with your custom drawer
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: primaryColor,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: primaryColor,
                    floating: true, // Make the app bar floating
                    pinned: false, // Keep the app bar visible when scrolling
                    automaticallyImplyLeading: false,
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu,
                            color: Colors.white, size: 30),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      title: Container(
                        height:
                            40, // Adjust the height to make the search field thinner
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16), // Adjust horizontal padding
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(207, 255, 255, 255),
                            hintText: "Chercher un produit",
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical:
                                  8, // Reduce vertical padding to make it thinner
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          color: primaryColor,
                          padding: const EdgeInsets.all(1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    categoryItem("Montres", "assets/elec.png"),
                                    categoryItem(
                                        "Chaussures", "assets/elecro.png"),
                                    categoryItem(
                                        "Accessoires", "assets/elec.png"),
                                    categoryItem(
                                        "Vêtements", "assets/elecro.png"),
                                    categoryItem(
                                        "Vêtements", "assets/elec.png"),
                                  ],
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
                                      setState(() {
                                        _currentPage = index;
                                      });
                                    },
                                  ),
                                ),

                                const SizedBox(height: 0),

                                // ✅ "Meilleures Ventes" Section
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    "Meilleures Ventes",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 0),

                                // ✅ Dynamic GridView for Products
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: GridView.builder(
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
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      final product = products[index];
                                      return ProductCard(
                                        imagePath: product['imagePath']!,
                                        name: product['name']!,
                                        price: product['price']!,
                                        discount: product['discount'],
                                        previousPrice: products[index][
                                            'previousPrice'], // Ensure this is passed
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
                                      "assets/samsung.png", // Replace with real URL
                                  products: [
                                    {
                                      "image": "assets/produit1.jpg",
                                      "name": "Samsung"
                                    },
                                    {
                                      "image": "assets/prod2.jpg",
                                      "name": "Samsung "
                                    },
                                    {
                                      "image": "assets/produit1.jpg",
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
                                      color: Colors.black,
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
                                      "assets/samsung.png", // Replace with real URL
                                  products: [
                                    {
                                      "image": "assets/produit1.jpg",
                                      "name": "Samsung"
                                    },
                                    {
                                      "image": "assets/prod2.jpg",
                                      "name": "Samsung "
                                    },
                                    {
                                      "image": "assets/produit1.jpg",
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
                                color: primaryColor,
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
                                        color: Colors.white,
                                      ),
                                    ),

                                    // Button to toggle description
                                    IconButton(
                                      icon: Icon(
                                        item['showDescription']
                                            ? Icons.keyboard_arrow_up_rounded
                                            : Icons.keyboard_arrow_down_rounded,
                                        color: Colors.white,
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
                                  color: primaryColor,
                                  child: Text(
                                    item['description'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
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
                              color: Colors
                                  .white, // You can adjust the color of the text
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
                                  color: Color.fromARGB(255, 255, 255,
                                      255), // Adjust the color for the non-clickable part
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
                                    color: Colors
                                        .yellow, // The yellow color for "trend"
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

  Widget categoryItem(String label, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
