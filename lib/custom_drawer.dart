import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF006D77), // Couleur de fond
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Profil utilisateur
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage("assets/logo.png"), // Image profil
              radius: 30,
            ),
            title: const Text(
              "Oueslati Hyba",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "Mon Profile",
              style: TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.close, color: Colors.white),
            onTap: () {
              Navigator.pop(context); // Fermer le drawer
            },
          ),

          const Divider(color: Colors.white38),

          // Catégories
          ListTile(
            leading: const Icon(Icons.category, color: Colors.white),
            title:
                const Text("Catégories", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),

          // Coupons
          ListTile(
            leading: const Icon(Icons.card_giftcard, color: Colors.white),
            title: const Text("Coupons", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),

          // Suivi commande
          ListTile(
            leading: const Icon(Icons.local_shipping, color: Colors.white),
            title: const Text("Suivre votre commande",
                style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),

          const Spacer(),

          // Déconnexion
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text("Déconnexion",
                style: TextStyle(color: Colors.white)),
            onTap: () {
              // Ajoute ici l’action de déconnexion
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
