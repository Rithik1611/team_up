import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text('Add'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Example action: Adding a new item
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('New item added!')),
            );
          },
          child: const Text('Add New Item'),
        ),
      ),
    );
  }
}
