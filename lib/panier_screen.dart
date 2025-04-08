import 'package:flutter/material.dart';
import 'package:tdiscount_app/custom_drawer.dart';

class PanierProductCard extends StatelessWidget {
  final String imagePath;
  final String productName;
  final int quantity;
  final double price;
  final double? previousPrice; // Optional previous price
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;

  const PanierProductCard({
    super.key,
    required this.imagePath,
    required this.productName,
    required this.quantity,
    required this.price,
    this.previousPrice,
    required this.onAdd,
    required this.onRemove,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Image.asset(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 12),

          // Name and Quantity Section
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Quantity Controls
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: onRemove,
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: onAdd,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Remove Button and Price Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Remove Button
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
              const SizedBox(height: 8),

              // Price Row (Previous Price + Actual Price)
              Row(
                children: [
                  if (previousPrice != null)
                    Text(
                      '\$${previousPrice!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.red,
                      ),
                    ),
                  if (previousPrice != null)
                    const SizedBox(width: 8), // Spacing
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PanierScreen extends StatefulWidget {
  const PanierScreen({super.key});

  @override
  _PanierScreenState createState() => _PanierScreenState();
}

class _PanierScreenState extends State<PanierScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  // Simulated cart data
  final List<Map<String, dynamic>> cartItems = [
    {
      'imagePath': 'assets/produit1.jpg',
      'productName': 'Product 1 iehg rh hui  hui hui hui hui hui hui hui hui',
      'quantity': 2,
      'price': 20.0,
      'previousPrice': 25.0,
    },
    {
      'imagePath': 'assets/prod2.jpg',
      'productName': 'Product 2  hui  hui hui hui hui hui hui hui hui ',
      'quantity': 1,
      'price': 15.0,
      'previousPrice': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      _controller.forward();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF006D77),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Tdiscount", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF006D77), Color(0xFF83C5BE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 224, 224, 224),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: cartItems.isEmpty
                    ? SlideTransition(
                        position: _offsetAnimation,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined,
                                  size: 80, color: Colors.black54),
                              SizedBox(height: 16),
                              Text(
                                "Votre panier est vide.",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return PanierProductCard(
                            imagePath: item['imagePath'],
                            productName: item['productName'],
                            quantity: item['quantity'],
                            price: item['price'],
                            previousPrice: item['previousPrice'],
                            onAdd: () {
                              setState(() {
                                item['quantity']++;
                              });
                            },
                            onRemove: () {
                              setState(() {
                                if (item['quantity'] > 1) {
                                  item['quantity']--;
                                }
                              });
                            },
                            onDelete: () {
                              setState(() {
                                cartItems.removeAt(index);
                              });
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
