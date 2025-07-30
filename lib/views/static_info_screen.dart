import 'package:flutter/material.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';

class StaticInfoScreen extends StatelessWidget {
  final String title;
  final String content;

  const StaticInfoScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: TColors.primary, // Set to your primary color
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
