import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:tdiscount_app/main.dart';
import 'package:tdiscount_app/viewModels/auth_viewmodel.dart';
import 'package:tdiscount_app/views/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  // Add controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        // Center all content within the body
        child: SingleChildScrollView(
          // Prevent overflow for smaller screens
          child: Form(
            key: _formKey, // <-- Add the form key here
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/images/logo.png',
                    height: 50), // Replace with your logo asset

                const SizedBox(height: 40),

                // Username Textfield
                SizedBox(
                  width: 320,
                  height: 50,
                  child: TextFormField(
                    key: const Key('login_email'),
                    controller: _usernameController, // <-- Add controller
                    decoration: InputDecoration(
                      labelText: 'Nom d\'utilisateur*',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Rounded corners for the text field
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre nom d\'utilisateur';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 15),

                // Password Textfield
                SizedBox(
                  width: 320,
                  height: 50,
                  child: TextFormField(
                    key: const Key('login_password'),
                    controller: _passwordController, // <-- Add controller
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Mot de Passe*',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Rounded corners for the text field
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // Continue Button
                SizedBox(
                  width: 320, // Adjust width to match the text fields
                  child: ElevatedButton(
                    key: const Key('login_submit'),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final username = _usernameController.text.trim();
                        final password = _passwordController.text;

                        final success =
                            await authViewModel.login(username, password);
                        if (!mounted) {
                          return; // Check if widget is still mounted
                        }

                        if (success) {
                          // Navigate to home screen and remove login from stack
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const MyHomePage()),
                          );
                        } else {
                          // Show error message
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Verifiez vos identifiants'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            50), // Rounded corners for the button
                      ),
                    ),
                    child: const Text('Continuer',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 80),

                // Sign-up options
                const Center(child: Text('inscrivez-vous avec')),

                const SizedBox(height: 5),

                // Social Media Icons
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.facebook, size: 30),
                    Icon(Icons.g_mobiledata_sharp, size: 30),
                    Icon(Icons.apple, size: 30),
                    Icon(Icons.tiktok_outlined, size: 30),
                  ],
                ),

                const SizedBox(height: 5),

                // Sign-up Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('vous n\'avez pas de compte? '),
                      GestureDetector(
                        onTap: () {
                          // Navigate to sign-up screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          'S\'inscrire',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
