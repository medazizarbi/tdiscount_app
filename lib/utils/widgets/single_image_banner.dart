import 'package:flutter/material.dart';

class SingleImageBanner extends StatelessWidget {
  final String imagePath;

  const SingleImageBanner({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity, // Full width of the screen
        height: 200, // Adjust the height as needed
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), // Rounded corners
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover, // Cover the entire container
          ),
        ),
      ),
    );
  }
}
