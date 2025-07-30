import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/viewModels/auth_viewmodel.dart';

class UpdateUserInfoScreen extends StatefulWidget {
  const UpdateUserInfoScreen({super.key});

  @override
  State<UpdateUserInfoScreen> createState() => _UpdateUserInfoScreenState();
}

class _UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _showPasswordFields = false;

  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Validation state
  bool _prenomInvalid = false;
  bool _nomInvalid = false;
  bool _displayNameInvalid = false;
  bool _emailInvalid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userInfo = await Provider.of<AuthViewModel>(context, listen: false)
          .getUserInfoFromPrefs();
      if (userInfo['first_name'] != null &&
          userInfo['first_name']!.isNotEmpty) {
        _prenomController.text = userInfo['first_name']!;
      }
      if (userInfo['last_name'] != null && userInfo['last_name']!.isNotEmpty) {
        _nomController.text = userInfo['last_name']!;
      }
      if (userInfo['display_name'] != null &&
          userInfo['display_name']!.isNotEmpty) {
        _displayNameController.text = userInfo['display_name']!;
      }
      if (userInfo['email'] != null && userInfo['email']!.isNotEmpty) {
        _emailController.text = userInfo['email']!;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.primary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: TColors.primary,
            elevation: 0,
            title: Image.asset(
              "assets/images/tdiscount_images/Logo-Tdiscount-market-noire.png",
              height: 40,
              fit: BoxFit.contain,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: TColors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            pinned: true,
            floating: false,
            snap: false,
            automaticallyImplyLeading: false,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: themedColor(
                      context,
                      TColors.lightContainer,
                      TColors.darkContainer,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 36),
                        const Center(
                          child: Text(
                            'Modifier mes informations',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // User info fields
                        // Prénom
                        const Row(
                          children: [
                            Text("Prénom"),
                            Text(" *", style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _prenomController,
                          decoration: InputDecoration(
                            hintText: "Entrez votre prénom",
                            errorText:
                                _prenomInvalid ? "Ce champ est requis" : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color:
                                    _prenomInvalid ? Colors.red : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color:
                                    _prenomInvalid ? Colors.red : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: _prenomInvalid
                                    ? Colors.red
                                    : TColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Nom
                        const Row(
                          children: [
                            Text("Nom"),
                            Text(" *", style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nomController,
                          decoration: InputDecoration(
                            hintText: "Entrez votre nom",
                            errorText:
                                _nomInvalid ? "Ce champ est requis" : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: _nomInvalid ? Colors.red : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: _nomInvalid ? Colors.red : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color:
                                    _nomInvalid ? Colors.red : TColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Nom affiché
                        const Row(
                          children: [
                            Text("Nom affiché"),
                            Text(" *", style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _displayNameController,
                          decoration: InputDecoration(
                            hintText: "Entrez le nom affiché",
                            errorText: _displayNameInvalid
                                ? "Ce champ est requis"
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: _displayNameInvalid
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: _displayNameInvalid
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: _displayNameInvalid
                                    ? Colors.red
                                    : TColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Email
                        const Row(
                          children: [
                            Text("Email"),
                            Text(" *", style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Entrez votre email",
                            errorText: _emailInvalid
                                ? (_emailController.text.isEmpty
                                    ? "Ce champ est requis"
                                    : "Veuillez entrer une adresse email valide")
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: _emailInvalid ? Colors.red : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: _emailInvalid ? Colors.red : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: _emailInvalid
                                    ? Colors.red
                                    : TColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 32),
                        // Expandable password section
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showPasswordFields = !_showPasswordFields;
                            });
                          },
                          child: Row(
                            children: [
                              const Text(
                                "Changer votre mot de passe",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const Spacer(),
                              AnimatedRotation(
                                turns: _showPasswordFields
                                    ? 0.5
                                    : 0, // 0 = down, 0.5 = up
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  Icons.expand_more,
                                  color: themedColor(
                                    context,
                                    TColors.black,
                                    TColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_showPasswordFields) ...[
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: Colors.grey, size: 18),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "Laissez les champs mot de passe vides pour conserver votre mot de passe actuel.",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text("Nouveau mot de passe"),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: "Nouveau mot de passe",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                          ),
                          const SizedBox(height: 16),
                          const Text("Confirmer le mot de passe"),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              hintText: "Confirmer le mot de passe",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscureConfirmPassword,
                          ),
                        ],
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: Consumer<AuthViewModel>(
                            builder: (context, authViewModel, child) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: TColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 0,
                                ),
                                onPressed: authViewModel.isLoading
                                    ? null
                                    : () async {
                                        final prenom =
                                            _prenomController.text.trim();
                                        final nom = _nomController.text.trim();
                                        final displayName =
                                            _displayNameController.text.trim();
                                        final email =
                                            _emailController.text.trim();
                                        final password =
                                            _passwordController.text.trim();
                                        final confirmPassword =
                                            _confirmPasswordController.text
                                                .trim();

                                        // Simple email regex
                                        final emailRegex = RegExp(
                                            r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

                                        setState(() {
                                          _prenomInvalid = prenom.isEmpty;
                                          _nomInvalid = nom.isEmpty;
                                          _displayNameInvalid =
                                              displayName.isEmpty;
                                          _emailInvalid = email.isEmpty ||
                                              !emailRegex.hasMatch(email);
                                        });

                                        if (_prenomInvalid ||
                                            _nomInvalid ||
                                            _displayNameInvalid ||
                                            _emailInvalid) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Veuillez remplir tous les champs obligatoires.",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        if (password.isNotEmpty &&
                                            password != confirmPassword) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Les mots de passe ne correspondent pas.",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        if (password.isNotEmpty) {
                                          final passValid = RegExp(
                                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~_\-\.]).{8,}$')
                                              .hasMatch(password);

                                          if (!passValid) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Le mot de passe doit contenir au moins 8 caractères, une majuscule, une minuscule, un chiffre et un caractère spécial.",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            );
                                            return;
                                          }
                                        }

                                        final success =
                                            await authViewModel.updateUserInfo(
                                          name: displayName,
                                          firstName: prenom,
                                          lastName: nom,
                                          email: email,
                                          password: password.isNotEmpty
                                              ? password
                                              : null,
                                        );
                                        if (success) {
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Modifications enregistrées avec succès."),
                                            ),
                                          );
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                        } else {
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Une erreur est survenue.",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                child: authViewModel.isLoading
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.black),
                                      )
                                    : const Text(
                                        "Enregistrer les modifications",
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
