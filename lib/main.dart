import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/viewmodels/category_viewmodel.dart';
import 'views/home_screen.dart';
import 'views/recherche_screen.dart';
import 'views/panier_screen.dart';
import 'views/favoris_screen.dart';
import 'views/profil_screen.dart';
import 'utils/widgets/nav_bar.dart';
import 'package:tdiscount_app/viewModels/favorites_view_model.dart';

final GlobalKey<_MyHomePageState> homePageKey = GlobalKey<_MyHomePageState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoriteViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
      ],
      child: const MyApp(),
    ),
  );
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

  // Expose a method to navigate to the HomeScreen
  static void navigateToHome() {
    homePageKey.currentState?._onItemTapped(2); // Set index to HomeScreen
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 2;

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

  void navigateToFavorisScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const FavorisScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavBar(
        onItemTapped: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
