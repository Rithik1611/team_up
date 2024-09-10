import 'package:flutter/material.dart';
import 'package:team_up/models/student.dart';
import 'package:team_up/view/edit_page.dart';

class ProfilePage extends StatefulWidget {
  final Student student;
  const ProfilePage({super.key,required this.student});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Student _student;
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _student = widget.student;  // Initialize the _student variable here
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(automaticallyImplyLeading: false,
    backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedStudent = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPage(student: _student),
                ),
              );

              if (updatedStudent != null) {
                setState(() {
                  _student = updatedStudent;
                  // Rebuild profile page with updated student details
                  _pages[3] = ProfilePage(student: _student,);
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
                      : const AssetImage('assets/profile_image.png') as ImageProvider,
                  backgroundColor: const Color.fromARGB(255, 137, 137, 137),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _student.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${_student.year} Year',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Text(
                      _student.department,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Text(
                      _student.section,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Skill set:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: _student.skills
                  .map((skill) => Chip(
                      label: Text(skill, style: const TextStyle(color: Colors.white)),
                      backgroundColor: const Color.fromARGB(255, 49, 0, 128)))
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Interested:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: _student.interests
                  .map((interest) => Chip(
                      label:
                          Text(interest, style: const TextStyle(color: Colors.white)),
                      backgroundColor:  const Color.fromARGB(255, 49, 0, 128)))
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }
}