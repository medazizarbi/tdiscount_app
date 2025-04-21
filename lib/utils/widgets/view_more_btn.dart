import 'package:flutter/material.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';

class ViewMoreButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ViewMoreButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, // Remove padding
        minimumSize: const Size(0, 0), // Remove minimum size constraints
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink tap area
      ),
      child: const Text('Voir Plus',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: TColors.buttonPrimary, // Set the text color to blue
          )),
    );
  }
}
