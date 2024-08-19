import 'package:flutter/material.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${student.name}"),
            Text("Department: ${student.department}"),
            Text("Section: ${student.section}"),
            Text("Year: ${student.year}"),
            Text("Skills: ${student.skills.join(', ')}"),
            Text("Interests: ${student.interests.join(', ')}"),
            student.profilePic.path.isNotEmpty
                ? Image.file(student.profilePic, height: 100)
                : const Text('No profile picture selected.'),
          ],
        ),
      ),
    );
  }
}
