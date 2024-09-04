import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
      backgroundColor: Color.fromARGB(255, 49, 0, 128),
        title: Text('Add'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Example action: Adding a new item
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('New item added!')),
            );
          },
          child: Text('Add New Item'),
        ),
      ),
    );
  }
}
