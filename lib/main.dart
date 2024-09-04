import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:team_up/view/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Team Up',
      theme: ThemeData(
        textTheme: GoogleFonts.ptMonoTextTheme(), 
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 72, 0, 136)),
        useMaterial3: false,
      ),
      home: SignupPage(),
    );
  }
}
