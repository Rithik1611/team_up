import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:team_up/view/get_verified_page.dart'; // Import GetWidget


class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text('Add'),
      ),
      body: Center(
        child: Container(
          height: 100,
          child: GFButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GetVerifiedPage(),
              ),
            ),
            text: "Upload",
            textStyle: const TextStyle(fontSize: 24),
            icon: const Icon(Icons.file_upload_sharp, color: Colors.white), // Optional icon
            color: GFColors.SUCCESS,
            textColor: Colors.white,
            shape: GFButtonShape.standard,
            size: GFSize.LARGE,
            blockButton: true,
          ),
        ),
      ),
    );
  }
}
