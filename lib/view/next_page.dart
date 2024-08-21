import 'package:flutter/material.dart';
import 'package:team_up/models/student.dart';
import 'package:team_up/view/edit_page.dart';

class NextPage extends StatefulWidget {
  final Student student;

  const NextPage({super.key, required this.student});

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  late Student _student;

  @override
  void initState() {
    super.initState();
    _student = widget.student;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Next Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Navigate to the edit page and await the updated student data
              final updatedStudent = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPage(student: _student),
                ),
              );

              // If an updated student is returned, update the state
              if (updatedStudent != null) {
                setState(() {
                  _student = updatedStudent;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _student.profilePic.path.isNotEmpty
                        ? FileImage(_student.profilePic)
                        : AssetImage('assets/profile_image.png')
                            as ImageProvider,
                    backgroundColor: const Color.fromARGB(255, 137, 137, 137),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _student.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${_student.year} Year',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        '${_student.department}',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        '${_student.section}',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Skill set:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: _student.skills
                    .map((skill) => Chip(
                        label:
                            Text(skill, style: TextStyle(color: Colors.white)),
                        backgroundColor: Color.fromARGB(200, 103, 65, 136)))
                    .toList(),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Interested:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: _student.interests
                    .map((interest) => Chip(
                        label: Text(interest,
                            style: TextStyle(color: Colors.white)),
                        backgroundColor:Color.fromARGB(200, 103, 65, 136)))
                    .toList(),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}