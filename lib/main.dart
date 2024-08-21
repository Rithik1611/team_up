import 'package:flutter/material.dart';
import 'package:team_up/app/app_pallete.dart';
import 'package:team_up/view/auth.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: AppPallete.primary),
        useMaterial3: false,
      ),
      home: AuthPage(),
    );
  }
}
