import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/providers/theme_provider.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/utils/widgets/custom_drawer.dart';
import 'package:tdiscount_app/utils/widgets/logout_dialog.dart';
import 'package:tdiscount_app/viewModels/auth_viewmodel.dart';
import 'package:tdiscount_app/views/login_screen.dart';
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
    final isLoggedIn = Provider.of<AuthViewModel>(context).isLoggedIn;

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
                          // Title Row
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Mon Profile",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const SectionTitle(title: 'Compte'),
                          isLoggedIn
                              ? SettingTile(
                                  icon: Icons.person,
                                  title: 'Information Personnelle',
                                  subtitle: 'Modifier votre profile',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UpdateUserInfoScreen(),
                                      ),
                                    );
                                  },
                                )
                              : SettingTile(
                                  icon: Icons.login,
                                  title: 'Se connecter',
                                  subtitle: 'Créer un compte',
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                                ),

                          const SectionTitle(title: 'Interface'),
                          const SettingTile(
                            icon: Icons.color_lens,
                            title: 'Thème',
                            trailing: ThemeToggleSwitch(),
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
                                    content: '''
Chez Tdiscount, la sécurité de vos données est notre priorité.

- Toutes vos informations personnelles sont stockées de manière sécurisée et ne sont jamais partagées sans votre consentement.

- Paiement à la livraison pour plus de sérénité.

- Retour et échange facilités.

- Consultez notre politique de confidentialité et nos conditions d’utilisation pour en savoir plus.

Pour toute question, contactez notre service client au +216 71 205 105 ou par email à contact@tdiscount.tn.
''',
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
                                    content: '''
Bienvenue sur Tdiscount Marketplace, la référence de la vente en ligne en Tunisie !

**FAQ Tdiscount**

- Qu’est-ce que Tdiscount ? Une marketplace réunissant de nombreux vendeurs et catégories pour tous vos besoins.

- Quel est le délai de livraison ? Livraison rapide partout en Tunisie.

- Livrez-vous en dehors de la Tunisie ? Non, la livraison est uniquement disponible en Tunisie.

- Comment contacter le service client ? Par téléphone au +216 71 205 105 ou par email à contact@tdiscount.tn.

- Tdiscount propose-t-il des offres spéciales ? Oui, profitez de promotions exclusives toute l’année !

Pour plus d’aide, consultez notre blog ou contactez-nous directement.
''',
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
                                    content: '''
Tdiscount Marketplace

Bienvenue sur Tdiscount, la marketplace de référence pour la vente en ligne en Tunisie !

Tdiscount évolue pour mieux vous servir ! Anciennement un site e-commerce, nous sommes aujourd’hui une marketplace incontournable réunissant une multitude de vendeurs et de catégories.

Notre mission ? Vous offrir une expérience d’achat fluide et sécurisée, avec des offres exclusives et les meilleurs prix en Tunisie.

📦 Livraison rapide
💳 Paiement à la livraison
🔄 Retour et échange facilités
📞 Service client réactif : +216 71 205 105

Retrouvez-nous sur :
- www.tdiscount.com
- Facebook, Instagram, Tiktok : @tdiscount.tn

Adresse :
78, Rue des minéraux 8603 Z.I de la Charguia 1 2035 Tunis - Tunisie

Copyright © 2025 | Tous droits réservés - By iTrend
''',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          if (isLoggedIn)
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: isDark
                ? TColors.textSecondary
                : TColors.darkerGrey, // <-- Black or white
          ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent, // Keep background transparent
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: Icon(
            icon,
            color: isDark ? Colors.white : Colors.black, // <-- Icon color
          ),
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
    final brightness = Theme.of(context).brightness;
    final isLight = themeProvider.themeMode == ThemeMode.system
        ? brightness == Brightness.light
        : themeProvider.themeMode == ThemeMode.light;

    final Color bgColor = isLight ? Colors.grey.shade200 : Colors.grey.shade800;
    final Color textColor = isLight ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: () {
        themeProvider.setTheme(isLight ? ThemeMode.dark : ThemeMode.light);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 100,
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Place the text on the opposite side of the toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isLight)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Nuit",
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 22),
                if (isLight)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      "Jour",
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 22),
              ],
            ),
            // The toggle button (circle) overlays the text
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment: isLight ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isLight ? Icons.wb_sunny : Icons.nightlight_round,
                  color: isLight ? Colors.black : Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
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
        backgroundColor: TColors.primary, // <-- Set your primary color
        foregroundColor: Colors.black, // <-- Optional: set text/icon color
        elevation: 0,
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
