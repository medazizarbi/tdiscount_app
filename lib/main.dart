import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdiscount_app/providers/theme_provider.dart';
import 'package:tdiscount_app/viewModels/auth_viewmodel.dart';
import 'package:tdiscount_app/viewModels/order_viewmodel.dart';
import 'package:tdiscount_app/viewModels/product_viewmodel.dart';
import 'package:tdiscount_app/viewmodels/category_viewmodel.dart';
import 'package:tdiscount_app/views/login_screen.dart';
import 'views/home_screen.dart';
import 'views/recherche_screen.dart';
import 'views/panier_screen.dart';
import 'views/favoris_screen.dart';
import 'views/profil_screen.dart';
import 'utils/widgets/nav_bar.dart';
import 'package:tdiscount_app/viewModels/favorites_view_model.dart';

final GlobalKey<_MyHomePageState> homePageKey = GlobalKey<_MyHomePageState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoriteViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
      ],
      child: MyApp(isLoggedIn: token != null && token.isNotEmpty),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      themeMode: themeProvider.themeMode,

      debugShowCheckedModeBanner:
          false, // Set to false to remove the debug banner
      home: isLoggedIn ? const MyHomePage() : const LoginScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        // Add other light theme customizations here
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        // Add other dark theme customizations here
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();

  // Expose a method to navigate to the HomeScreen
  static void navigateToHome() {
    homePageKey.currentState?.onItemTapped(2); // Set index to HomeScreen
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

  void onItemTapped(int index) {
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
        onItemTapped: onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
