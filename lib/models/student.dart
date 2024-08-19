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
  })  : token = token ??
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiQXN3aW4iLCJpZCI6IjY2YmVlZmQzNDJhOTE4Yzg0YWNkOTk3NyIsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzIzNzg5MjY3LCJleHAiOjE3MjYzODEyNjd9.n9pmbrvLlYd9HVl6vyCKulyKO7VpPr5WDHQEaY6o-ZE',
        skills = skills ?? [],
        interests = interests ?? [],
        profilePic = profilePic ?? File('');
}
