import 'dart:io'; // For File type

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_up/models/auth_remote.dart';
import 'package:team_up/models/student.dart';
import 'package:team_up/view/main_screen.dart';
import 'package:team_up/widget/gradient_background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';
  bool _isPasswordVisible = false;

  final AuthViewModel _authViewModel = AuthViewModel();
  final Dio _dio = Dio();
  Student? _student; // Variable to store the Student details

  Future<void> _login() async {
    bool isSuccess = await _authViewModel.login(
      email: _email.trim(),
      password: _password.trim(),
    );

    if (isSuccess) {
      await Future.delayed(const Duration(milliseconds: 500));
      final token = await _authViewModel.getToken();
      print('Token after login: $token');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );

      // Perform GET request using Dio
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

      // Assuming profilePic is a URL or path, here you can handle downloading/loading the image
      // For now, profilePic is set to null or you can download it if you have a valid URL
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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(student: _student!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'WELCOME BACK.',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'LOG IN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
