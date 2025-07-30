import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdiscount_app/main.dart';
import 'package:tdiscount_app/models/category_model.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/viewmodels/category_viewmodel.dart';
import 'package:tdiscount_app/views/sub_categorie.dart';
import 'package:tdiscount_app/utils/widgets/logout_dialog.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  bool isCategoriesExpanded = false;
  String displayName = "User";

  @override
  void initState() {
    super.initState();
    _loadDisplayName();
  }

  Future<void> _loadDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_display_name');
    setState(() {
      displayName = name != null && name.isNotEmpty ? name : "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the categories list from the CategoryViewModel
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final categories = categoryViewModel.categories;

    return Drawer(
      backgroundColor: themedColor(
          context, TColors.primary, TColors.darkContainer), // Background color
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Row for "Discount" img on the left and back button on the right
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Use different logo for light/dark theme
                  Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? "assets/images/tdiscount_images/Logo-Tdiscount-market-2.0.png" // White logo for dark theme
                        : "assets/images/tdiscount_images/Logo-Tdiscount-market-noire.png", // Black logo for light theme
                    width: 120,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_outlined),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            Divider(
              color: themedColor(context, TColors.darkGrey, TColors.darkGrey),
            ),

            // Profil utilisateur (without image)
            ListTile(
              title: Text(
                " $displayName",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Mon Profile",
                //style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer first
                homePageKey.currentState
                    ?.onItemTapped(4); // Navigate to ProfilScreen (index 4)
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

            // Déconnexion
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Déconnexion"),
              onTap: () {
                showLogoutDialog(context);
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
