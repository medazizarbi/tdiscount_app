import 'package:flutter/material.dart';
import 'package:tdiscount_app/views/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedCivility;
  bool _isPrivacyPolicyAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  const SizedBox(height: 40),

                  // Title
                  const Text(
                    'Créer votre compte',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Civility (Radio Buttons)
                  // Civility (Radio Buttons)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Civilité :',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                          width: 10), // Spacing between text and radio buttons
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text(
                                  'Homme',
                                  style: TextStyle(
                                      fontSize: 12), // Adjust text size here
                                ),
                                value: 'Homme',
                                groupValue: _selectedCivility,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCivility = value;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text(
                                  'Femme',
                                  style: TextStyle(
                                      fontSize: 12), // Adjust text size here
                                ),
                                value: 'Femme',
                                groupValue: _selectedCivility,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCivility = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                          child: buildTextField(
                              'Nom*', Icons.person_outline_rounded)),
                      const SizedBox(width: 5), // Spacing between fields
                      Expanded(
                          child: buildTextField(
                              'Prénom*', Icons.person_outline_rounded)),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Email
                  buildTextField('Adresse e-mail', Icons.mail_outline),

                  const SizedBox(height: 15),

                  // Phone
                  buildTextField('Numéro de téléphone*', Icons.phone_outlined),

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

                  // Address
                  buildTextField('Adresse*', Icons.location_on_outlined),

                  const SizedBox(height: 15),

                  // City Fields (Ville & Code Postal in the same line)
                  Row(
                    children: [
                      Expanded(
                          child: buildTextField(
                              'Ville*', Icons.location_city_outlined)),
                      const SizedBox(width: 5), // Spacing between fields
                      Expanded(
                          child: buildTextField('Code Postal*',
                              Icons.local_post_office_outlined)),
                    ],
                  ),

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
                          if (_selectedCivility == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Veuillez choisir votre civilité'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else if (!_isPrivacyPolicyAccepted) {
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
                            const Color.fromARGB(255, 15, 112, 123),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text('Continuer',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold)),
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
                        const Text('avez-vous deja un compte ?'),
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
                            'log in',
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
