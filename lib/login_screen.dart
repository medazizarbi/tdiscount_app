import 'package:flutter/material.dart';
import 'package:tdiscount_app/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true; // For password visibility toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Handle back button press
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          // Center all content within the body
          child: SingleChildScrollView(
            // Prevent overflow for smaller screens
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/logo.png',
                    height: 50), // Replace with your logo asset

                const SizedBox(height: 40),

                // Email Textfield
                SizedBox(
                  width: 320,
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Adresse e-mail*',
                      prefixIcon: const Icon(Icons.mail_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Rounded corners for the text field
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre adresse e-mail';
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
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Handle login
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
    );
  }
}
