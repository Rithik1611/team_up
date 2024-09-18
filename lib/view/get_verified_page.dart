import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_up/db/sembast_service.dart';

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
  final _teamNameController = TextEditingController();
  DateTime? _selectedDate;
  final SembastService _sembastService =
      SembastService(); // Initialize SembastService

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
        _teamNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    String? token = await _sembastService.getToken(); // Retrieve the token

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token not available. Please login.')),
      );
      return;
    }

    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'eventName': _titleController.text,
      'date': _dateController.text,
      'description': _descriptionController.text,
      'teamName': _teamNameController.text,
      'poster':
          await MultipartFile.fromFile(_imageFile!.path, filename: 'image.jpg'),
    });

    var response = await dio.post(
      'https://kcgteamupserver-production.up.railway.app/api/user/achievement/create',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token', // Add token to request headers
        },
      ),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Achievement uploaded successfully')),
      );

      Navigator.pop(context, DateTime.now());

      setState(() {
        _imageFile = null;
        _titleController.clear();
        _dateController.clear();
        _descriptionController.clear();
        _teamNameController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload achievement')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Verified'),
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
                      ? const Center(
                          child: Text('Upload Image',
                              style: TextStyle(color: Colors.grey)))
                      : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Post Title:'),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Enter Title'),
              ),
              const SizedBox(height: 10),
              const Text('Date:'),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month_rounded),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                controller: _dateController,
              ),
              const SizedBox(height: 10),
              const Text('Description:'),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Enter Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Team Name:'),
              TextField(
                controller: _teamNameController,
                decoration: const InputDecoration(hintText: 'Enter Team Name'),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 49, 0, 128),
                  ),
                  onPressed: _uploadAchievement,
                  child: const Text('UPLOAD'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
