import 'dart:io';

class Student {
  String name;
  String year;
  String department;
  String section;
  List<String> skills;
  List<String> interests;
  File profilePic;
  String token;

  Student({
    required this.name,
    required this.year,
    required this.department,
    required this.section,
    List<String>? skills,
    List<String>? interests,
    File? profilePic,
    String? token,
  })  : token = token ?? '',
        skills = skills ?? [],
        interests = interests ?? [],
        profilePic = profilePic ?? File('');
}
