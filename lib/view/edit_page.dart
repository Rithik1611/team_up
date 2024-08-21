import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:team_up/api/dio_service.dart';
import 'package:team_up/models/student.dart';
import 'package:team_up/view/next_page.dart'; // Adjust the import as necessary

class EditPage extends StatefulWidget {
  final Student student;

  const EditPage({super.key, required this.student});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late String _name;
  late String _year;
  late String _section;
  late String _department;
  late List<String> _skills;
  late List<String> _interests;
  File? _newProfilePic;

  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final DioService _dioService =
      DioService(); // Assuming you have a DioService for API requests

  @override
  void initState() {
    super.initState();
    _name = widget.student.name;
    _year = widget.student.year;
    _section = widget.student.section;
    _department = widget.student.department;
    _skills = List.from(widget.student.skills);
    _interests = List.from(widget.student.interests);
  }

  Future<void> _pickProfileImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newProfilePic = File(pickedFile.path);
      });
    }
  }

  void _addSkill(String skill) {
    setState(() {
      _skills.add(skill);
    });
    _skillController.clear(); // Clear the text field after adding the skill
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  void _addInterest(String interest) {
    setState(() {
      _interests.add(interest);
    });
    _interestController
        .clear(); // Clear the text field after adding the interest
  }

  void _removeInterest(String interest) {
    setState(() {
      _interests.remove(interest);
    });
  }

  Future<void> _sendData() async {
    // Prepare the form data
    FormData formData = FormData.fromMap({
      'name': _name,
      'year': _year,
      'department': _department,
      'section': _section,
      'skills': _skills,
      'interests': _interests,
      if (_newProfilePic != null)
        'profilepic': await MultipartFile.fromFile(
          _newProfilePic!.path,
          filename: _newProfilePic!.path.split('/').last,
        ),
    });

    try {
      // Send POST request using Dio
      Response response =
          await _dioService.postRequest('/user/updateProfile', formData);

      if (response.statusCode == 200 &&
          response.data['message'] == 'Profile updated successfully') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );

        // Create a Student object with the entered data
        Student student = Student(
          name: _name,
          year: _year,
          department: _department,
          section: _section,
          skills: _skills,
          interests: _interests,
          profilePic: _newProfilePic ?? widget.student.profilePic,
        );

        // Navigate to NextPage and pass the Student object
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NextPage(student: student),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickProfileImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _newProfilePic != null
                    ? FileImage(_newProfilePic!)
                    : widget.student.profilePic.path.isNotEmpty
                        ? FileImage(widget.student.profilePic)
                        : const AssetImage('assets/profile_image.png')
                            as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              initialValue: _name,
              onChanged: (value) {
                _name = value;
              },
              enabled: false, // This makes the TextFormField read-only
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Year'),
              initialValue: _year,
              onChanged: (value) {
                _year = value;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Section'),
              initialValue: _section,
              onChanged: (value) {
                _section = value;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Department'),
              initialValue: _department,
              onChanged: (value) {
                _department = value;
              },
              enabled: false,
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Skills:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: _skills
                  .map((skill) => Chip(
                        label: Text(skill),
                        deleteIcon: const Icon(Icons.cancel),
                        onDeleted: () => _removeSkill(skill),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _skillController,
              decoration: const InputDecoration(
                labelText: 'Add a new skill',
                suffixIcon: Icon(Icons.add),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _addSkill(value);
                }
              },
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Interests:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: _interests
                  .map((interest) => Chip(
                        label: Text(interest),
                        deleteIcon: const Icon(Icons.cancel),
                        onDeleted: () => _removeInterest(interest),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _interestController,
              decoration: const InputDecoration(
                labelText: 'Add a new interest',
                suffixIcon: Icon(Icons.add),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _addInterest(value);
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendData,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
