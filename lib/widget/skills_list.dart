import 'package:flutter/material.dart';

class SkillsList extends StatelessWidget {
  final List<String> skills;

  const SkillsList({Key? key, required this.skills}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: skills
          .map(
            (skill) => Chip(
              label: Text(
                skill,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 49, 0, 128),
            ),
          )
          .toList(),
    );
  }
}
