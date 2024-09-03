import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart'; // Import the dropdown_search package
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_up/api/dio_service.dart';
import 'package:team_up/models/student.dart';
import 'package:team_up/view/next_page.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  int currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  final List<String> _predefinedSkills = [
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

  String _name = '';
  String _year = ''; // Initialize as an empty string
  String _department = '';
  String _section = '';
  List<String> _skills = [];
  List<String> _interests = [];
  File? _profilePic;

  final ImagePicker _picker = ImagePicker();
  final DioService _dioService = DioService(); // Instantiate DioService

  @override
  void initState() {
    super.initState();
    // Ensure _year is valid or reset it to an empty string if not
    _year = ['First', 'Second', 'Third', 'Fourth'].contains(_year) ? _year : '';
  }

  Future<void> _pickProfilePic() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePic = File(pickedFile.path);
      });
    }
  }

  Future<void> _sendData() async {
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
          filename: _profilePic!.path.split('/').last,
        ),
    });

    try {
      Response response =
          await _dioService.postRequest('/user/updateProfile', formData);

      if (response.statusCode == 200 &&
          response.data['message'] == 'Profile updated successfully') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );

        Student student = Student(
          name: _name,
          year: _year,
          department: _department,
          section: _section,
          skills: _skills,
          interests: _interests,
          profilePic: _profilePic ?? File(''),
        );

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
                  DropdownButtonFormField<String>(
                    value: _year.isNotEmpty ? _year : null,
                    items: ['First', 'Second', 'Third', 'Fourth']
                        .map((String year) {
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
                ],
              ),
            ),
          ),
          Step(
            isActive: currentStep >= 1,
            title: const Text("Skills & Interests"),
            content: Column(
              children: [
                // Skills Section
                ..._skills.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Row(
                    children: [
                      Expanded(
                        child: DropdownSearch<String>(
                          items: _predefinedSkills,
                          selectedItem:
                              _skills[index].isEmpty ? null : _skills[index],
                          onChanged: (value) => setState(() {
                            _skills[index] = value ?? '';
                          }),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: 'Skill ${index + 1}',
                            ),
                          ),
                          popupProps: const PopupProps.menu(
                            showSearchBox: true,
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
                  onPressed: () => setState(() {
                    _skills.add(''); // Add an empty entry for a new skill
                  }),
                  child: const Text('Add Skill'),
                ),

                const SizedBox(
                    height:
                        20), // Add some spacing between skills and interests

                // Interests Section
                ..._interests.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Row(
                    children: [
                      Expanded(
                        child: DropdownSearch<String>(
                          items:
                              _predefinedSkills, // Use the same predefined skills list
                          selectedItem: _interests[index].isEmpty
                              ? null
                              : _interests[index],
                          onChanged: (value) => setState(() {
                            _interests[index] = value ?? '';
                          }),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: 'Interest ${index + 1}',
                            ),
                          ),
                          popupProps: const PopupProps.menu(
                            showSearchBox: true,
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
                    _interests.add(''); // Add an empty entry for a new interest
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
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() {
              currentStep -= 1;
            });
          }
        },
        onStepTapped: (step) {
          setState(() {
            currentStep = step;
          });
        },
      ),
    );
  }
}
