import 'package:flutter/material.dart';

/// A reusable card widget with padding and shadow
class GlobalCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GlobalCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
