import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'recherche_screen.dart';
import 'panier_screen.dart';
import 'favoris_screen.dart';
import 'profil_screen.dart';
import 'nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner:
          false, // Set to false to remove the debug banner
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 2;

  // Liste des pages pour le navigation bar
  final List<Widget> _pages = const [
    PanierScreen(),
    RechercheScreen(),
    HomeScreen(),
    FavorisScreen(),
    ProfilScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[
          _selectedIndex], // Affiche la page en fonction de l'index sélectionné
      bottomNavigationBar: NavBar(
          onItemTapped: _onItemTapped,
          selectedIndex:
              _selectedIndex), // Passer la fonction et l'index au NavBar
    );
  }
}
