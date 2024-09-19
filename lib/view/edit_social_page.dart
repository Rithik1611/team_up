import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Social Media Links'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Save logic goes here
              Navigator.pop(context);
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
