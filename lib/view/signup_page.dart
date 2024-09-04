import 'package:flutter/material.dart';
import 'package:team_up/models/auth_remote.dart';
import 'package:team_up/view/form_page.dart';
import 'package:team_up/view/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _name = '';
  String _email = '';
  String _password = '';

  final AuthViewModel _authViewModel = AuthViewModel();

  Future<void> _signup() async {
    bool isSuccess = await _authViewModel.signup(
      name: _name.trim(),
      email: _email.trim(),
      password: _password.trim(),
    );

    if (isSuccess) {
      await Future.delayed(const Duration(milliseconds: 500));
      final token = await _authViewModel.getToken();
      print('Token after signup: $token');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup successful')),
      );
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FormPage(),
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'START                                            YOUR JOURNEY.',
              style: TextStyle(fontSize: 32, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            const SizedBox(height: 32),
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle:
                    const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle:
                    const TextStyle(color: Colors.black),
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
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle:
                    const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('SIGN UP', style: TextStyle(color: Color.fromARGB(255, 49, 0, 128))),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: const Text(
                  'Already have an Account? Login',
                  style: TextStyle(color: Color.fromARGB(255, 49, 0, 128), fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
