import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:team_up/view/admin_control_page.dart';

import 'package:team_up/view/get_verified_page.dart'; // Import GetWidget
// Import AddCategoryPage

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
                icon: const Icon(Icons.file_upload_sharp, color: Colors.white),
                color: GFColors.SUCCESS,
                textColor: Colors.white,
                shape: GFButtonShape.standard,
                size: GFSize.LARGE,
                blockButton: true,
              ),
            ),
            const SizedBox(height: 20), // Spacing between buttons
            InkWell(
              child: Container(
                height: 100,
                child: GFButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminControlPage()),
                  ),
                  text: "Admin Control",
                  textStyle: const TextStyle(fontSize: 24),
                  icon: const Icon(Icons.admin_panel_settings,
                      color: Colors.white),
                  color: GFColors.INFO,
                  textColor: Colors.white,
                  shape: GFButtonShape.standard,
                  size: GFSize.LARGE,
                  blockButton: true,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
