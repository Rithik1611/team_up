import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_up/db/sembast_service.dart'; // Import your SembastService

class EditSocialPage extends StatefulWidget {
  final String linkedinUrl;
  final String githubUrl;
  final String portfolioUrl;

  EditSocialPage({
    required this.linkedinUrl,
    required this.githubUrl,
    required this.portfolioUrl,
  });

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditSocialPage> {
  late TextEditingController _linkedinController;
  late TextEditingController _githubController;
  late TextEditingController _portfolioController;
  Dio _dio = Dio(); // Initialize Dio for making HTTP requests

  @override
  void initState() {
    super.initState();
    _linkedinController = TextEditingController(text: widget.linkedinUrl);
    _githubController = TextEditingController(text: widget.githubUrl);
    _portfolioController = TextEditingController(text: widget.portfolioUrl);
  }

  @override
  void dispose() {
    _linkedinController.dispose();
    _githubController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  Future<void> _saveSocialLinks() async {
    // Get token from SembastService
    final SembastService sembastService = SembastService();
    final String? token = await sembastService.getToken();

    if (token != null) {
      // Prepare the data to send
      final Map<String, dynamic> socialLinks = {
        'linkedin': _linkedinController.text,
        'github': _githubController.text,
        'portfolio': _portfolioController.text,
      };

      // Send POST request with token in the header
      Response response = await _dio.post(
        "https://kcgteamupserver-production.up.railway.app/api/user/updateLinks",
        data: socialLinks,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Include token in the headers
          },
        ),
      );
      print(response);

      if (response.statusCode == 200) {
        print("Social links updated successfully.");
      } else {
        print("Failed to update social links.");
      }
    } else {
      print("No token found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Social Media Links'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              await _saveSocialLinks(); // Trigger POST request on save
              Navigator.pop(context); // Go back after saving
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _linkedinController,
              decoration: InputDecoration(labelText: 'LinkedIn URL'),
            ),
            TextField(
              controller: _githubController,
              decoration: InputDecoration(labelText: 'GitHub URL'),
            ),
            TextField(
              controller: _portfolioController,
              decoration: InputDecoration(labelText: 'Portfolio URL'),
            ),
          ],
        ),
      ),
    );
  }
}
