import 'package:flutter/material.dart';
import 'package:team_up/models/student.dart';
import 'package:team_up/view/edit_page.dart';
import 'package:team_up/widget/profile_avatar.dart';
import 'package:team_up/widget/profile_info.dart';
import 'package:team_up/widget/reports_section.dart';

class ProfilePage extends StatefulWidget {
  final Student student;
  const ProfilePage({Key? key, required this.student}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        automaticallyImplyLeading: false,
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
              if (updatedStudent != null && mounted) {
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
              ProfileAvatar(student: _student),
              const SizedBox(height: 20),
              ProfileInfo(student: _student),
              const SizedBox(height: 20),
              const ReportsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
