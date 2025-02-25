import 'package:flutter/material.dart';

class PanierScreen extends StatefulWidget {
  const PanierScreen({super.key});

  @override
  _PanierScreenState createState() => _PanierScreenState();
}

class _PanierScreenState extends State<PanierScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the Panier Screen!'),
      ),
    );
  }
}
