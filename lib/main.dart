import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdiscount_app/providers/theme_provider.dart';
import 'package:tdiscount_app/viewModels/auth_viewmodel.dart';
import 'package:tdiscount_app/viewModels/order_viewmodel.dart';
import 'package:tdiscount_app/viewModels/product_viewmodel.dart';
import 'package:tdiscount_app/viewModels/search_viewmodel.dart';
import 'package:tdiscount_app/viewmodels/category_viewmodel.dart';
import 'package:tdiscount_app/views/login_screen.dart';
import 'views/home_screen.dart';
import 'views/recherche_screen.dart';
import 'views/panier_screen.dart';
import 'views/favoris_screen.dart';
import 'views/profil_screen.dart';
import 'utils/widgets/nav_bar.dart';
import 'package:tdiscount_app/viewModels/favorites_view_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils/widgets/connectivity_checker.dart'; // Add this import

// ignore: library_private_types_in_public_api
final GlobalKey<_MyHomePageState> homePageKey = GlobalKey<_MyHomePageState>();

Future<void> main() async {
  await dotenv.load(fileName: ".env");
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
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
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
      debugShowCheckedModeBanner: false,
      home: ConnectivityChecker(
        // <-- Wrap home with ConnectivityChecker
        child: isLoggedIn ? const MyHomePage() : const LoginScreen(),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
