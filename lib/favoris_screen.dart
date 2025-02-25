import 'package:flutter/material.dart';

class FavorisScreen extends StatefulWidget {
  const FavorisScreen({super.key});

  @override
  _FavorisScreenState createState() => _FavorisScreenState();
}

class _FavorisScreenState extends State<FavorisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the Favoris Screen!'),
      ),
    );
  }
}
