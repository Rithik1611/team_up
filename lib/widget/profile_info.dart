import 'package:flutter/material.dart';
import 'package:team_up/models/student.dart';
import 'package:team_up/widget/interests_lists.dart';
import 'skills_list.dart';

class ProfileInfo extends StatelessWidget {
  final Student student;

  const ProfileInfo({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Skill set:',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        const SizedBox(height: 10),
        SkillsList(skills: student.skills),
        const SizedBox(height: 20),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Interested:',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        const SizedBox(height: 10),
        InterestsList(interests: student.interests),
      ],
    );
  }
}
