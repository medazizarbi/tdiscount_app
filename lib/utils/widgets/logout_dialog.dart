import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/viewModels/auth_viewmodel.dart';
import 'package:tdiscount_app/views/login_screen.dart';

Future<void> showLogoutDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Déconnexion'),
      content: const Text('Voulez-vous vraiment vous déconnecter ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Annuler',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await Provider.of<AuthViewModel>(context, listen: false).logout();
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            }
          },
          child: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
