import 'package:flutter/material.dart';
import 'package:team_up/app/app_pallete.dart';
import 'package:team_up/models/student.dart';

class NextPage extends StatelessWidget {
  final Student student;

  const NextPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Next Page"),
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
                    backgroundImage: student.profilePic.path.isNotEmpty
                        ? FileImage(student.profilePic)
                        : AssetImage('assets/profile_image.png')
                            as ImageProvider,
                    backgroundColor: Colors.blue,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${student.year} Year',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        '${student.department}',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        '${student.section}',
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
                children: student.skills
                    .map((skill) => Chip(
                        label:
                            Text(skill, style: TextStyle(color: Colors.white)),
                        backgroundColor: AppPallete.primary))
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
                children: student.interests
                    .map((interest) => Chip(
                        label: Text(interest,
                            style: TextStyle(color: Colors.white)),
                        backgroundColor: AppPallete.primary))
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
