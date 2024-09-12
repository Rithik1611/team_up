import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  final DioService _dioService =
      DioService(); // Assuming you have a DioService for API requests

  // Predefined lists of skills and interests
  final List<String> _allSkills = [
    'Flutter',
    'Dart',
    'JavaScript',
    'Python',
    'Java',
    'C++',
    'C#',
    'HTML',
    'CSS',
    'Kotlin',
    'Swift',
    'Ruby',
    'PHP',
    'SQL',
    'R',
    'Go',
    'Rust',
    'Scala',
    'TypeScript',
    'Objective-C',
    'MATLAB',
    'Perl',
    'VBA',
    'Shell Scripting',
    'Node.js',
    'React',
    'Angular',
    'Vue.js',
    'Spring Boot',
    'Django',
    'Flask',
    'Express.js',
    'ASP.NET',
    'Laravel',
    'TensorFlow',
    'PyTorch',
    'Keras',
    'OpenCV',
    'Hadoop',
    'Spark',
    'Unity',
    'Unreal Engine',
    'Blender',
    'AutoCAD',
    'Machine Learning',
    'Data Science',
    'Cloud Computing',
    'AWS',
    'Azure',
    'Google Cloud',
    'Docker',
    'Kubernetes',
    'DevOps',
    'CI/CD',
    'Blockchain',
    'Cybersecurity',
    'Agile Methodologies',
  ];

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
        backgroundColor:  const Color.fromARGB(255, 49, 0, 128),
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
            DropdownButtonFormField<String>(
              value: _year.isNotEmpty ? _year : null,
              items: ['First', 'Second', 'Third', 'Fourth'].map((String year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _year = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Year',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your year';
                }
                return null;
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
            DropdownSearch<String>.multiSelection(
              items: _allSkills,
              popupProps: const PopupPropsMultiSelection.dialog(
                showSearchBox: true,
              ),
              onChanged: (value) {
                setState(() {
                  _skills = value;
                });
              },
              selectedItems: _skills,
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
            DropdownSearch<String>.multiSelection(
              items: _allSkills,
              popupProps: const PopupPropsMultiSelection.dialog(
                showSearchBox: true,
              ),
              onChanged: (value) {
                setState(() {
                  _interests = value;
                });
              },
              selectedItems: _interests,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 49, 0, 128),
                ),
              ),
              onPressed: _sendData,
              child: const Text('Save Changes',),
            ),
          ],
        ),
      ),
    );
  }
}
