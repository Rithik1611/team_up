import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ Color.fromARGB(255, 32, 2, 36) ,Color.fromARGB(255, 120, 47, 194), Color.fromARGB(255, 32, 2, 36)], // Gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child, // The child widget (e.g., SignupPage) will be displayed on top of the gradient
    );
  }
}
