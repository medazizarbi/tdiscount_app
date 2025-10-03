import 'package:flutter/material.dart';
import 'package:tdiscount_app/views/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isPrivacyPolicyAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inscription',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 30,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'assets/images/tdiscount_images/Logo-Tdiscount-market-2.0.png'
                        : 'assets/images/tdiscount_images/Logo-Tdiscount-market-noire-2.0.png',
                    height: 50,
                  ),
                  const SizedBox(height: 30),

                  buildTextField('Nom*', Icons.person_outline_rounded),
                  const SizedBox(height: 15),
                  buildTextField('Prénom*', Icons.person_outline_rounded),
                  const SizedBox(height: 15),

                  // Email
                  buildTextField('Adresse e-mail', Icons.mail_outline),

                  const SizedBox(height: 15),

                  // Password
                  buildPasswordField('Mot de Passe*', _obscurePassword, () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  }),

                  const SizedBox(height: 15),

                  // Confirm Password
                  buildPasswordField(
                      'Confirmer Mot de Passe*', _obscureConfirmPassword, () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  }),

                  const SizedBox(height: 15),

                  // Privacy Policy Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _isPrivacyPolicyAccepted,
                        onChanged: (value) {
                          setState(() {
                            _isPrivacyPolicyAccepted = value!;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "J'accepte la politique de confidentialité",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Continue Button
                  SizedBox(
                    width: 320,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (!_isPrivacyPolicyAccepted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Vous devez accepter la politique de confidentialité'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            // Handle sign-up logic
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.yellow, // Use your primary color
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text('Continuer',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Sign-up Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Avez-vous déjà un compte ? '),
                        GestureDetector(
                          onTap: () {
                            // Navigate to log in screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text(
                            'Se connecter',
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
      ),
    );
  }

  Widget buildTextField(String label, IconData icon) {
    return SizedBox(
      width: 350,
      height: 70, // Increased height to account for validation messages
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (label == 'Adresse e-mail' && value != null && value.isNotEmpty) {
            // Validate email format only if provided
            final emailRegex =
                RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Veuillez entrer une adresse e-mail valide';
            }
          } else if (label != 'Adresse e-mail' &&
              (value == null || value.isEmpty)) {
            return 'Veuillez entrer $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildPasswordField(
      String label, bool obscureText, VoidCallback toggleVisibility) {
    return SizedBox(
      width: 350,
      height: 70, // Increased height to account for validation messages
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          suffixIcon: IconButton(
            icon: Icon(obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined),
            onPressed: toggleVisibility,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Veuillez entrer $label' : null,
      ),
    );
  }
}
