import 'package:flutter/material.dart';
import 'package:tdiscount_app/utils/widgets/custom_drawer.dart'; // Import the CustomDrawer
import 'package:provider/provider.dart';
import 'package:tdiscount_app/providers/theme_provider.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primary,
        elevation: 0,
        title: const Text("Tdiscount", style: TextStyle(color: TColors.black)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: TColors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const CustomDrawer(), // Use the CustomDrawer here
      body: Container(
        decoration: const BoxDecoration(
          color: TColors.primary,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: themedColor(
                      context, TColors.lightContainer, TColors.darkContainer),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    // Centered Title
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Center(
                        child: Text(
                          "My Profile",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Theme Switch Buttons
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ChoiceChip(
                              label: const Text('Système'),
                              selected:
                                  themeProvider.themeMode == ThemeMode.system,
                              onSelected: (_) =>
                                  themeProvider.setTheme(ThemeMode.system),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Clair'),
                              selected:
                                  themeProvider.themeMode == ThemeMode.light,
                              onSelected: (_) =>
                                  themeProvider.setTheme(ThemeMode.light),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Sombre'),
                              selected:
                                  themeProvider.themeMode == ThemeMode.dark,
                              onSelected: (_) =>
                                  themeProvider.setTheme(ThemeMode.dark),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Placeholder for profile content (empty for now)
                    Expanded(
                      child: Center(
                        child: Text(
                          "Profile content goes here!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
