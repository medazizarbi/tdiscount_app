import 'package:flutter/material.dart';
import 'package:tdiscount_app/main.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'login_screen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = themedColor(
      context,
      TColors.lightContainer,
      TColors.darkContainer,
    );
    themedColor(
      context,
      TColors.textPrimary,
      TColors.textWhite,
    );
    final logoPath = isDark
        ? 'assets/images/tdiscount_images/Logo-Tdiscount-market-2.0.png'
        : 'assets/images/tdiscount_images/Logo-Tdiscount-market-noire-2.0.png';

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                logoPath,
                height: 100,
              ),
              const SizedBox(height: 180),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: TColors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text("Se connecter / Créer un compte"),
              ),
              const SizedBox(height: 16),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: themedColor(
                    context,
                    TColors.black,
                    TColors.textWhite,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MyHomePage()),
                  );
                },
                child: const Text("Continuer sans se connecter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
