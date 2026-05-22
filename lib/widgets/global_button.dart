import 'package:flutter/material.dart';

/// A reusable global button widget to use across the app
class GlobalButton extends StatelessWidget {
  final String text; // The text displayed on the button
  final VoidCallback onPressed; // Function to run when button is tapped
  final Color? color; // Optional button color
  final double? width; // Optional custom width
  final double? height; // Optional custom height

  const GlobalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity, // Use full width by default
      height: height ?? 50.0, // Default height
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor, // Default to theme color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
