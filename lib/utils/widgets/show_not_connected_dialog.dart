import 'package:flutter/material.dart';
import 'package:tdiscount_app/views/login_screen.dart';

Future<void> showNotConnectedDialog(BuildContext context) async {
  return showDialog(
    context: context,
    useRootNavigator: true, // <-- Add this line
    builder: (context) => AlertDialog(
      title: const Text("Vous n'êtes pas connecté"),
      content: const Text(
        "Pour accéder à cette fonctionnalité, veuillez vous connecter.",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog
          },
          child: const Text("Retour"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          child: const Text("Se connecter"),
        ),
      ],
    ),
  );
}
