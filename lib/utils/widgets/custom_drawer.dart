import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/main.dart';
import 'package:tdiscount_app/models/category_model.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/viewmodels/category_viewmodel.dart';
import 'package:tdiscount_app/views/sub_categorie.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isCategoriesExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Access the categories list from the CategoryViewModel
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final categories = categoryViewModel.categories;

    return Drawer(
      backgroundColor: themedColor(context, TColors.lightContainer,
          TColors.darkContainer), // Background color
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
                      // color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      letterSpacing: 1.2, // Letter spacing
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_outlined,
                      //  color: Colors.white
                    ),
                    onPressed: () {
                      Navigator.pop(
                          context); // Close the drawer when back button is tapped
                    },
                  ),
                ],
              ),
            ),

            Divider(
              color: themedColor(context, TColors.darkGrey, TColors.darkGrey),
            ),

            // Profil utilisateur (left side image and profile)
            ListTile(
              leading: const CircleAvatar(
                backgroundImage:
                    AssetImage("assets/images/logo.png"), // Profile image
                radius: 30,
              ),
              title: const Text(
                "Med Aziz El Arbi",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Mon Profile",
                //style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                homePageKey.currentState
                    ?.onItemTapped(4); // Navigate to ProfilScreen
                Navigator.pop(context); // Close the drawer
              },
            ),

            Divider(
              color: themedColor(context, TColors.darkGrey, TColors.darkGrey),
            ),
            // Dynamic Categories Section
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.only(top: 10.0, left: 15.0),
                leading: const Icon(Icons.category),
                title: const Text("Catégories"),
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    isCategoriesExpanded = expanded;
                  });
                },
                children: [
                  if (categoryViewModel.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 251, 255, 0)),
                    )
                  else if (categories.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Aucune catégorie disponible"),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, bottom: 10.0),
                      child: Column(
                        children: categories
                            .map((category) => CategoryTile(category: category))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),

            // Coupons
            ListTile(
              leading: const Icon(Icons.card_giftcard),
              title: const Text("Coupons"),
              onTap: () {},
            ),

            // Suivi commande
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text("Suivre votre commande"),
              onTap: () {},
            ),

            const SizedBox(height: 20),

            // Déconnexion
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Déconnexion"),
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
  final Category category;
  const CategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18),
        leading: const Icon(
          Icons.arrow_circle_right_outlined,
          //color: Color.fromARGB(255, 140, 140, 140),
          size: 20,
        ),
        title: Text(
          category.name,
          style: const TextStyle(
            //  color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        horizontalTitleGap: 10,
        dense: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubCategorieScreen(
                categoryId: category.id, // Pass only the id
                categoryName: category.name, // Pass the name as well
                categoryCount: category.count, // Pass the count as well
              ),
            ),
          );
        },
      ),
    );
  }
}
