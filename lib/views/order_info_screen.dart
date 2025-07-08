import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdiscount_app/models/product_model.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';
import 'package:tdiscount_app/viewModels/order_viewmodel.dart';

class OrderInfoScreen extends StatefulWidget {
  final List<Product> products;
  final Map<int, int> quantities;

  const OrderInfoScreen({
    super.key,
    required this.products,
    required this.quantities,
  });

  @override
  State<OrderInfoScreen> createState() => _OrderInfoScreenState();
}

class _OrderInfoScreenState extends State<OrderInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedCity;

  final List<String> _tunisiaCities = [
    "Tunis",
    "Ariana",
    "Ben Arous",
    "Manouba",
    "Nabeul",
    "Zaghouan",
    "Bizerte",
    "Béja",
    "Jendouba",
    "Kef",
    "Siliana",
    "Sousse",
    "Monastir",
    "Mahdia",
    "Sfax",
    "Kairouan",
    "Kasserine",
    "Sidi Bouzid",
    "Gabès",
    "Medenine",
    "Tataouine",
    "Gafsa",
    "Tozeur",
    "Kebili"
  ];

  final OutlineInputBorder curvedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(color: Colors.grey),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primary,
        elevation: 0,
        title: const Text(
          "Informations de commande",
          style: TextStyle(
            color: TColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: TColors.black),
      ),
      body: Container(
        color:
            themedColor(context, TColors.lightContainer, TColors.darkContainer),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 24),

              // First and Last Name
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: "Prénom",
                        border: curvedBorder,
                        enabledBorder: curvedBorder,
                        focusedBorder: curvedBorder,
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Champ requis"
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: "Nom",
                        border: curvedBorder,
                        enabledBorder: curvedBorder,
                        focusedBorder: curvedBorder,
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Champ requis"
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Address
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: "Adresse",
                  border: curvedBorder,
                  enabledBorder: curvedBorder,
                  focusedBorder: curvedBorder,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Champ requis" : null,
              ),
              const SizedBox(height: 16),
              // City Picker
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: InputDecoration(
                  labelText: "Ville",
                  border: curvedBorder,
                  enabledBorder: curvedBorder,
                  focusedBorder: curvedBorder,
                ),
                items: _tunisiaCities
                    .map((city) => DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                },
                validator: (value) =>
                    value == null || value.isEmpty ? "Champ requis" : null,
              ),
              const SizedBox(height: 16),
              // Phone Number
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: "Numéro de téléphone",
                  prefixText: "+216 ",
                  border: curvedBorder,
                  enabledBorder: curvedBorder,
                  focusedBorder: curvedBorder,
                  counterText: "", // Hide the counter text
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Champ requis";
                  }
                  if (!RegExp(r'^[0-9]{8}$').hasMatch(value)) {
                    return "Numéro invalide";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Note
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: "Note (optionnel)",
                  border: curvedBorder,
                  enabledBorder: curvedBorder,
                  focusedBorder: curvedBorder,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Consumer<OrderViewModel>(
                  builder: (context, orderViewModel, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        foregroundColor: TColors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: orderViewModel.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final success =
                                    await orderViewModel.createOrdersOneByOne(
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  address1: _addressController.text,
                                  city: _selectedCity ?? "",
                                  phone: "+216${_phoneController.text}",
                                  note: _noteController.text,
                                  products: widget.products,
                                  quantities: widget.quantities,
                                );

                                if (!mounted) return;
                                if (success) {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Commande envoyée !")),
                                  );
                                  // Optionally: Navigator.pop(context);
                                } else {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          orderViewModel.errorMessage ??
                                              "Erreur inconnue"),
                                    ),
                                  );
                                }
                              }
                            },
                      child: orderViewModel.isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(TColors.black),
                            )
                          : const Text(
                              "Terminer la commande",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
    );
  }
}
