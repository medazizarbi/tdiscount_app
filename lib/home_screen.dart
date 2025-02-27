import 'package:flutter/material.dart';
import 'package:tdiscount_app/custom_drawer.dart'; // Import the custom drawer
import 'package:tdiscount_app/widgets/carousel_widget.dart'; // Import the carousel widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryColor = const Color(0xFF006D77);

  // List of items with title, description, and visibility control
  final List<Map<String, dynamic>> items = [
    {
      'title': 'LIVRAISON RAPIDE',
      'description':
          'Offrez-vous la livraison gratuite pour toutes vos commandes en ligne des maintenat! Ne maquez pas cette offre exceptionnelle pour faire des "connomies sur vos achats!',
      'showDescription': false,
    },
    {
      'title': 'GARANTIE',
      'description':
          'Offrez-vous la livraison gratuite pour toutes vos commandes en ligne des maintenat! Ne maquez pas cette offre exceptionnelle pour faire des "connomies sur vos achats!',
      'showDescription': false,
    },
    {
      'title': 'SERVICE CLIENT',
      'description':
          'Offrez-vous la livraison gratuite pour toutes vos commandes en ligne des maintenat! Ne maquez pas cette offre exceptionnelle pour faire des "connomies sur vos achats!',
      'showDescription': false,
    },
    {
      'title': 'SAV',
      'description':
          'Offrez-vous la livraison gratuite pour toutes vos commandes en ligne des maintenat! Ne maquez pas cette offre exceptionnelle pour faire des "connomies sur vos achats!',
      'showDescription': false,
    },
    {
      'title': 'CONTACTEZ-NOUS',
      'description':
          'Offrez-vous la livraison gratuite pour toutes vos commandes en ligne des maintenat! Ne maquez pas cette offre exceptionnelle pour faire des "connomies sur vos achats!',
      'showDescription': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: false,
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
                    flexibleSpace: const FlexibleSpaceBar(
                      title: Text(
                        "Tdiscount",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          color: primaryColor,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Bonjour username",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(207, 255, 255, 255),
                                  hintText: "Chercher un produit",
                                  prefixIcon: const Icon(Icons.search,
                                      color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                ),
                              ),
                              const SizedBox(height: 15),
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoScrollCarousel(), // ✅ Insert Carousel Here

                                const SizedBox(height: 16),
                                Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text("Liste des produits ici"),
                                ),
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
