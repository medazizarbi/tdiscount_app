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

  final OutlineInputBorder curvedBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
    borderSide: BorderSide(color: Colors.grey),
  );

  int _noteMaxLines = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: TColors.primary,
            elevation: 0,
            centerTitle: true,
            floating: true, // <-- makes the app bar float
            pinned: false, // <-- not pinned
            title: Image.asset(
              "assets/images/tdiscount_images/Logo-Tdiscount-market-noire.png",
              height: 40,
              fit: BoxFit.contain,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: TColors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            automaticallyImplyLeading: false,
          ),
          SliverToBoxAdapter(
            child: Container(
              color: TColors.primary,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                children: [
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: themedColor(context, TColors.lightContainer,
                          TColors.darkContainer),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Informations de commande",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                                  validator: (value) =>
                                      value == null || value.trim().isEmpty
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
                                  validator: (value) =>
                                      value == null || value.trim().isEmpty
                                          ? "Champ requis"
                                          : null,
                                ),
                              ),
                            ],
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
                            validator: (value) => value == null || value.isEmpty
                                ? "Champ requis"
                                : null,
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
                                value == null || value.trim().isEmpty
                                    ? "Champ requis"
                                    : null,
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
                              if (value == null || value.trim().isEmpty) {
                                return "Champ requis";
                              }
                              if (!RegExp(r'^[0-9]{8}$')
                                  .hasMatch(value.trim())) {
                                return "Numéro invalide";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Note
                          TextFormField(
                            controller: _noteController,
                            minLines: 2,
                            maxLines: _noteMaxLines,
                            onChanged: (value) {
                              final lineCount =
                                  '\n'.allMatches(value).length + 1;
                              setState(() {
                                _noteMaxLines = lineCount < 2 ? 2 : lineCount;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Note (optionnel)",
                              border: curvedBorder,
                              enabledBorder: curvedBorder,
                              focusedBorder: curvedBorder,
                            ),
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
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final success = await orderViewModel
                                                .createOrdersOneByOne(
                                              firstName:
                                                  _firstNameController.text,
                                              lastName:
                                                  _lastNameController.text,
                                              address1: _addressController.text,
                                              city: _selectedCity ?? "",
                                              phone:
                                                  "+216${_phoneController.text}",
                                              note: _noteController.text,
                                              products: widget.products,
                                              quantities: widget.quantities,
                                            );

                                            if (!mounted) return;
                                            if (success) {
                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Commande envoyée !")),
                                              );
                                              // Optionally: Navigator.pop(context);
                                            } else {
                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(orderViewModel
                                                          .errorMessage ??
                                                      "Erreur inconnue"),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                  child: orderViewModel.isLoading
                                      ? const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  TColors.black),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
