import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:team_up/db/sembast_service.dart'; // Import the SembastService
import 'package:team_up/models/student.dart';
import 'package:team_up/view/main_screen.dart'; // Import your MainScreen
import 'package:team_up/view/starting_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SembastService sembastService = SembastService();

  // Check token validity before running the app
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
  Student? _student; // Define a Student object to hold the student data

  @override
  void initState() {
    super.initState();
    if (widget.isTokenValid) {
      _fetchCurrentUser(); // Fetch user data when the app starts
    }
  }

  Future<void> _fetchCurrentUser() async {
    // Get token from Sembast service
    final SembastService sembastService = SembastService();
    final String? token = await sembastService.getToken();

    if (token != null) {
      Response response = await _dio.get(
        "https://kcgteamupserver-production.up.railway.app/api/user/currentUser",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Add token to the headers
          },
        ),
      );

      // Parse the response data to extract relevant fields
      final data = response.data;
      print(data);

      // Assuming profilePic is a URL or path, you can handle downloading/loading the image
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

      // After fetching the data, update the UI
      setState(() {});
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
          ? MainScreen(
              student: _student!) // Pass the student data to MainScreen
          : StartingPage(), // If token is invalid or student is null, show the StartingPage
    );
  }
}
