import 'package:flutter/material.dart';
import 'package:team_up/models/student.dart';
import 'dart:io';

class ProfileAvatar extends StatelessWidget {
  final Student student;

  const ProfileAvatar({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: student.profilePic.path.isNotEmpty
              ? FileImage(student.profilePic)
              : const AssetImage('assets/profile_image.png') as ImageProvider,
          backgroundColor: const Color.fromARGB(255, 137, 137, 137),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              '${student.year} Year',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            Text(
              student.department,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            Text(
              student.section,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
