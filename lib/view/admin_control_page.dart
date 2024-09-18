import 'dart:io'; // Import to handle file

import 'package:dio/dio.dart'; // Import Dio package
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import ImagePicker package
import 'package:team_up/db/sembast_service.dart';

class AdminControlPage extends StatefulWidget {
  const AdminControlPage({Key? key}) : super(key: key);

  @override
  _AdminControlPageState createState() => _AdminControlPageState();
}

class _AdminControlPageState extends State<AdminControlPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _courseLinkController = TextEditingController();
  final _aboutController = TextEditingController();
  DateTime? _selectedDate;
  File? _selectedImage;
  final SembastService _sembastService =
      SembastService(); // Create an instance of SembastService

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _courseLinkController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _postEventToServer() async {
    final token = await _sembastService
        .getToken(); // Retrieve the token from SembastService

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No token found. Please log in.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final eventData = {
      "eventName": _titleController.text,
      "eventLink": _courseLinkController.text,
      "eventDate": _selectedDate?.toIso8601String(),
      "eventType": _descriptionController.text,
      "eventDes": _aboutController.text,
    };

    FormData formData = FormData.fromMap({
      ...eventData,
      if (_selectedImage != null)
        "eventPoster": await MultipartFile.fromFile(
          _selectedImage!.path,
          filename: "event_poster.jpg",
        ),
    });

    var response = await Dio().post(
      'https://kcgteamupserver-production.up.railway.app/api/event/create',
      data: formData,
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token", // Pass the token in the Authorization header
        },
      ),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New event has been added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to post event. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Control'),
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
                  child: _selectedImage == null
                      ? Center(
                          child: Text(
                            'Upload Image',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : Image.file(_selectedImage!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 20),
              Text('Event Name:'),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter Event Name',
                ),
              ),
              SizedBox(height: 10),
              Text('Event Type:'),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Enter Event Type',
                ),
              ),
              SizedBox(height: 10),
              Text('Event Link:'),
              TextField(
                controller: _courseLinkController,
                decoration: const InputDecoration(
                  hintText: 'Enter Event Link',
                ),
              ),
              SizedBox(height: 10),
              Text('About the Event:'),
              TextField(
                controller: _aboutController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text('Date:'),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month_rounded),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                controller: TextEditingController(
                  text: _selectedDate == null
                      ? ''
                      : '${_selectedDate!.toLocal()}'.split(' ')[0],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 49, 0, 128),
                  ),
                  onPressed: _postEventToServer,
                  child: Text('POST EVENT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
