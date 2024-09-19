import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:team_up/db/sembast_service.dart';
import 'package:team_up/models/student.dart';
import 'package:team_up/view/main_screen.dart';
import 'package:team_up/view/starting_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SembastService sembastService = SembastService();
  final bool isValid = await sembastService.isTokenValid();

  runApp(MyApp(isTokenValid: isValid));
}

class MyApp extends StatefulWidget {
  final bool isTokenValid;

  const MyApp({super.key, required this.isTokenValid});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Dio _dio = Dio();
  Student? _student;

  @override
  void initState() {
    super.initState();
    if (widget.isTokenValid) {
      _fetchCurrentUser();
    }
  }

  Future<void> _fetchCurrentUser() async {
    final SembastService sembastService = SembastService();
    final String? token = await sembastService.getToken();

    if (token != null) {
      Response response = await _dio.get(
        "https://kcgteamupserver-production.up.railway.app/api/user/currentUser",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final data = response.data;
      print(data);

      _student = Student(
        name: data['name'],
        year: data['year'],
        department: data['department'],
        section: data['section'],
        skills: List<String>.from(data['skills']),
        interests: List<String>.from(data['interests']),
        profilePic:
            data['profilePic'] != null ? File(data['profilePic']) : null,
      );

      print('Student details stored: $_student');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Team Up',
      theme: ThemeData(
        textTheme: GoogleFonts.ptMonoTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 49, 0, 128),
        ),
        useMaterial3: false,
      ),
      home: widget.isTokenValid && _student != null
          ? MainScreen(student: _student!)
          : StartingPage(),
    );
  }
}
