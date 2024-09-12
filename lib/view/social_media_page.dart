import 'package:flutter/material.dart';

class SocialMediaPage extends StatelessWidget {
  const SocialMediaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Media Handles'),
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
      ),
      body: Center(
        child: Text(
          'Add your social media links here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
