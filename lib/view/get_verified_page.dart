import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; 
import 'package:image_picker/image_picker.dart';

class GetVerifiedPage extends StatefulWidget {
  const GetVerifiedPage({super.key});

  @override
  _GetVerifiedPageState createState() => _GetVerifiedPageState();
}

class _GetVerifiedPageState extends State<GetVerifiedPage> {
  File? _imageFile;
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _teamNameController = TextEditingController(); // New controller for team name
  final _usernameController = TextEditingController(); // New controller for username
  DateTime? _selectedDate;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = '${_selectedDate!.toLocal()}'.split(' ')[0];
      });
    }
  }

  Future<void> _uploadAchievement() async {
    if (_imageFile == null ||
        _titleController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _teamNameController.text.isEmpty || // Check if team name is empty
        _usernameController.text.isEmpty) { // Check if username is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Warning',
            message: 'Please fill all fields',
            contentType: ContentType.failure,
          ),
        ),
      );
      return;
    }

    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        'title': _titleController.text,
        'date': _dateController.text,
        'description': _descriptionController.text,
        'team_name': _teamNameController.text, // Add team name
        'username': _usernameController.text, // Add username
        'image': await MultipartFile.fromFile(_imageFile!.path, filename: 'image.jpg'),
      });

      var response = await dio.post(
        'https://your-backend-api.com/upload', // Replace with your actual backend API endpoint
        data: formData,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: AwesomeSnackbarContent(
              title: 'Success',
              message: 'Achievement uploaded successfully.',
              contentType: ContentType.success,
            ),
          ),
        );

        // After successful upload, pass the current date back to ProfilePage
        Navigator.pop(context, DateTime.now());

        // Reset fields after successful upload
        setState(() {
          _imageFile = null;
          _titleController.clear();
          _dateController.clear();
          _descriptionController.clear();
          _teamNameController.clear(); // Clear team name field
          _usernameController.clear(); // Clear username field
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: AwesomeSnackbarContent(
              title: 'Upload Failed',
              message: 'Failed to upload achievement.',
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: AwesomeSnackbarContent(
            title: 'Error',
            message: 'An error occurred: $e',
            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Verified'),
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _imageFile == null
                      ? Center(
                          child: Text(
                            'Upload Image',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 20),
              Text('Post Title:'),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter Title',
                ),
              ),
              SizedBox(height: 10),
              Text('Date:'),
              TextFormField(
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Date of the Event';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month_rounded),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                controller: _dateController,
              ),
              SizedBox(height: 10),
              Text('Description:'),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text('Team Name:'), // New label for team name
              TextField(
                controller: _teamNameController,
                decoration: InputDecoration(
                  hintText: 'Enter Team Name',
                ),
              ),
              SizedBox(height: 10),
              Text('Username:'), // New label for username
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter Username',
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 49, 0, 128),
                  ),
                  onPressed: _uploadAchievement,
                  child: Text('UPLOAD'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
        ],
        currentIndex: 2,
        onTap: (index) {
          // Handle navigation tap
        },
      ),
    );
  }
}
