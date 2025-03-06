import 'package:flutter/material.dart';
import 'package:tdiscount_app/profil_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // To keep track of the expanded state of the "Catégories" section
  bool isCategoriesExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF006D77), // Background color
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Row for "Discount" text on the left and back button on the right
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "TDiscount", // Text at the top left
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      letterSpacing: 1.2, // Letter spacing
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_outlined,
                        color: Colors.white),
                    onPressed: () {
                      Navigator.pop(
                          context); // Close the drawer when back button is tapped
                    },
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white38),

            // Profil utilisateur (left side image and profile)
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage("assets/logo.png"), // Profile image
                radius: 30,
              ),
              title: const Text(
                "Med Aziz El Arbi",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Mon Profile",
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                // Navigate to ProfilScreen when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilScreen()),
                );
              },
            ),

            const Divider(color: Colors.white38),

            // Catégories (Expandable list)
            ExpansionTile(
              leading: const Icon(Icons.category, color: Colors.white),
              title: const Text("Catégories",
                  style: TextStyle(color: Colors.white)),
              onExpansionChanged: (bool expanded) {
                setState(() {
                  isCategoriesExpanded = expanded;
                });
              },
              children: [
                // This will be shown when the "Catégories" section is expanded
                Padding(
                  padding: const EdgeInsets.only(
                      left: 32.0), // Indentation for categories
                  child: Column(
                    children: List.generate(
                      10, // Change this number to dynamically generate more categories
                      (index) => CategoryTile(title: "Category ${index + 1}"),
                    ),
                  ),
                ),
              ],
            ),

            // Coupons
            ListTile(
              leading: const Icon(Icons.card_giftcard, color: Colors.white),
              title:
                  const Text("Coupons", style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),

            // Suivi commande
            ListTile(
              leading: const Icon(Icons.local_shipping, color: Colors.white),
              title: const Text("Suivre votre commande",
                  style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),

            const SizedBox(height: 20),

            // Déconnexion
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text("Déconnexion",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                // Action de déconnexion ici
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String title;
  const CategoryTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, // Fixed height for consistency
      alignment: Alignment.center, // Ensures everything is centered vertically
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18),
        leading: const Icon(
          Icons.arrow_circle_right_outlined,
          color: Color.fromARGB(255, 140, 140, 140),
          size: 20,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        horizontalTitleGap: 10, // Ensures proper spacing between icon and text
        dense: true, // Reduces ListTile height to fit within Container
        onTap: () {
          // Action when category is tapped
        },
      ),
    );
  }
}
