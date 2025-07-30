import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/providers/theme_provider.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/utils/widgets/custom_drawer.dart';
import 'package:tdiscount_app/utils/widgets/logout_dialog.dart';
import 'package:tdiscount_app/views/update_userinfo_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          color: TColors.primary,
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: TColors.primary,
              elevation: 0,
              title: Image.asset(
                "assets/images/tdiscount_images/Logo-Tdiscount-market-noire.png", // Your logo path
                height: 40,
                fit: BoxFit.contain,
              ),
              centerTitle: true,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: TColors.black),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              pinned: true,
              floating: false,
              snap: false,
              automaticallyImplyLeading: false,
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 20), // Add this line for spacing
                  Container(
                    decoration: BoxDecoration(
                      color: themedColor(context, TColors.lightContainer,
                          TColors.darkContainer),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 36),
                          // Centered Profile Email
                          const Center(
                            child: Text(
                              'Paramètres',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  //color: TColors.primary,
                                  fontSize: 20),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const SectionTitle(title: 'Compte'),
                          SettingTile(
                            icon: Icons.person,
                            title: 'Information Personnelle',
                            subtitle: 'Modifier votre profile',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UpdateUserInfoScreen()),
                              );
                            },
                          ),

                          const SectionTitle(title: 'Interface'),
                          const SettingTile(
                            icon: Icons.color_lens,
                            title: 'Thème',
                            trailing: ThemeToggleSwitch(),
                          ),
                          SettingTile(
                            icon: Icons.language,
                            title: 'Language',
                            subtitle: 'Français (FR)',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Autres langues seront bientôt disponibles'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.grey,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(16)), // Curved borders
                                  ),
                                ),
                              );
                            },
                          ),
                          const SectionTitle(title: 'Service'),
                          SettingTile(
                            icon: Icons.lock,
                            title: 'Confidentialité & Sécurité',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StaticInfoScreen(
                                    title: 'Confidentialité & Sécurité',
                                    content:
                                        "Vos données sont protégées. Nous ne partageons jamais vos informations personnelles sans votre consentement.",
                                  ),
                                ),
                              );
                            },
                          ),
                          SettingTile(
                            icon: Icons.help_outline,
                            title: 'Aide',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StaticInfoScreen(
                                    title: 'Aide',
                                    content:
                                        "Pour toute question ou problème, contactez notre support à support@tdiscount.com.",
                                  ),
                                ),
                              );
                            },
                          ),
                          SettingTile(
                            icon: Icons.info_outline,
                            title: 'À propos',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StaticInfoScreen(
                                    title: 'À propos',
                                    content:
                                        "TDiscount App\nVersion 1.0.0\n\nApplication développée pour faciliter vos achats et offres.",
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: () {
                              showLogoutDialog(context);
                            },
                            icon: const Icon(Icons.logout, color: Colors.red),
                            label: const Text(
                              'Déconnexion',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Keep background transparent
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: Icon(icon, color: Colors.teal),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}

class ThemeToggleSwitch extends StatelessWidget {
  const ThemeToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Determine the effective brightness
    final brightness = Theme.of(context).brightness;
    final isLight = themeProvider.themeMode == ThemeMode.system
        ? brightness == Brightness.light
        : themeProvider.themeMode == ThemeMode.light;

    return Switch(
      value: isLight,
      onChanged: (val) {
        themeProvider.setTheme(val ? ThemeMode.light : ThemeMode.dark);
      },
      activeColor: const Color.fromARGB(255, 58, 58, 58), // Color when ON
      inactiveThumbColor: const Color.fromARGB(255, 58, 58, 58), // Color OFF
      inactiveTrackColor: Colors.grey.shade300, // Track color when OFF
    );
  }
}

class StaticInfoScreen extends StatelessWidget {
  final String title;
  final String content;

  const StaticInfoScreen(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
