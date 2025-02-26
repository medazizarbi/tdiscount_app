import 'package:flutter/material.dart';
import 'custom_drawer.dart'; // Import du menu latéral

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryColor = const Color(0xFF006D77); // Couleur de l'AppBar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Supprime l'AppBar par défaut
      drawer:
          const CustomDrawer(), // Utilisation de `drawer` pour ouvrir à gauche
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: primaryColor,
            expandedHeight: 200.0,
            floating: false,
            pinned: false,
            automaticallyImplyLeading: false, // Supprime le bouton automatique
            leading: Container(), // Supprime l'icône du menu par défaut
            actions: const [], // Aucune icône à droite
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                children: [
                  const Text(
                    "Tdiscount",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(), // Pousse le bouton menu vers la droite
                  Builder(
                    builder: (context) => IconButton(
                      icon:
                          const Icon(Icons.menu, color: Colors.white, size: 30),
                      onPressed: () {
                        Scaffold.of(context)
                            .openDrawer(); // Ouvre le drawer à gauche
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Partie bleue contenant la recherche et les catégories
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
                          fillColor: const Color.fromARGB(207, 255, 255, 255),
                          hintText: "Chercher un produit",
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // ✅ Boutons de catégories avec image + texte
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            categoryItem("Montres", "assets/elec.png"),
                            categoryItem("Chaussures", "assets/elecro.png"),
                            categoryItem("Accessoires", "assets/elec.png"),
                            categoryItem("Vêtements", "assets/elecro.png"),
                            categoryItem("Vêtements", "assets/elec.png"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Partie blanche contenant le reste du contenu
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      // ✅ Carrousel d'images
                      Container(
                        height: 150,
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: const Text("Carrousel d’images ici"),
                      ),
                      const SizedBox(height: 1600),
                      // ✅ Produits (exemple)
                      Container(
                        height: 100,
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        child: const Text("Liste des produits ici"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Fonction pour créer un bouton de catégorie avec image et texte
  Widget categoryItem(String label, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white, // Fond blanc
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
              color: Colors.white, // Texte blanc
            ),
          ),
        ],
      ),
    );
  }
}
