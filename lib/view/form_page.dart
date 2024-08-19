import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_up/api/dio_service.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  int currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _year = '';
  String _department = '';
  String _section = '';
  List<String> _skills = [];
  List<String> _interests = [];
  File? _profilePic;

  final ImagePicker _picker = ImagePicker();
  final DioService _dioService = DioService(); // Instantiate DioService

  Future<void> _pickProfilePic() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePic = File(pickedFile.path);
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
      if (_profilePic != null)
        'profilepic': await MultipartFile.fromFile(
          _profilePic!.path,
          filename: _profilePic!.path.split('/').last,// Specify the correct media type
        ),
    });

    // Print the contents of FormData in an object-like format
    Map<String, dynamic> formDataMap = {
      'name': _name,
      'year': _year,
      'department': _department,
      'section': _section,
      'skills': _skills,
      'interests': _interests,
      if (_profilePic != null) 'profilePic': _profilePic!.path,
    };
    print(formDataMap);

    // Send POST request using Dio
    Response response =
        await _dioService.postRequest('/user/updateProfile', formData);
    print(response);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data submitted successfully')),
      );
    }
  }

  Future<void> _fetchData() async {
    try {
      // Send GET request using Dio
      Response response = await _dioService.getRequest('/fetchData');
      if (response.statusCode == 200) {
        // Handle the fetched data
        print(response.data); // Example: print fetched data to console
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Getting Started!"),
      ),
      body: Stepper(
        type: StepperType.vertical,
        steps: [
          Step(
            isActive: currentStep >= 0,
            title: const Text("Personal Info"),
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) => _name = value,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onChanged: (value) => _department = value,
                    decoration: const InputDecoration(labelText: 'Department'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your department';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onChanged: (value) => _section = value,
                    decoration: const InputDecoration(labelText: 'Section'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your section';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onChanged: (value) => _year = value,
                    decoration: const InputDecoration(labelText: 'Year'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your year';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          Step(
            isActive: currentStep >= 1,
            title: const Text("Skills Set"),
            content: Column(
              children: [
                ..._skills.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) => setState(() {
                            _skills[index] = value;
                          }),
                          decoration: InputDecoration(
                            labelText: 'Skill ${index + 1}',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => setState(() {
                          _skills.removeAt(index);
                        }),
                      ),
                    ],
                  );
                }).toList(),
                ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 30))),
                  onPressed: () => setState(() {
                    _skills.add('');
                  }),
                  child: const Text('Add Skill'),
                ),
                SizedBox(
                  height: 10,
                ),
                ..._interests.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) => setState(() {
                            _interests[index] = value;
                          }),
                          decoration: InputDecoration(
                            labelText: 'Interest ${index + 1}',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => setState(() {
                          _interests.removeAt(index);
                        }),
                      ),
                    ],
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: () => setState(() {
                    _interests.add('');
                  }),
                  child: const Text('Add Interest'),
                ),
              ],
            ),
          ),
          Step(
            isActive: currentStep >= 2,
            title: const Text("Profile Picture"),
            content: Column(
              children: [
                ElevatedButton(
                  onPressed: _pickProfilePic,
                  child: const Text('Pick Profile Picture'),
                ),
                if (_profilePic != null) ...[
                  Image.file(_profilePic!, width: 100, height: 100),
                ],
              ],
            ),
          ),
        ],
        currentStep: currentStep,
        onStepContinue: () {
          if (_formKey.currentState?.validate() ?? false) {
            if (currentStep < 2) {
              setState(() {
                currentStep += 1;
              });
            } else {
              _sendData();
            }
          }
        },
        onStepCancel: currentStep == 0
            ? null
            : () {
                setState(() {
                  currentStep -= 1;
                });
              },
      ),
    );
  }
}
