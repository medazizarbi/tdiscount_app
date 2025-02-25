import 'package:flutter/material.dart';

class RechercheScreen extends StatefulWidget {
  const RechercheScreen({super.key});

  @override
  _RechercheScreenState createState() => _RechercheScreenState();
}

class _RechercheScreenState extends State<RechercheScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the Recherche Screen!'),
      ),
    );
  }
}
