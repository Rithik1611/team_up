import 'package:flutter/material.dart';
import 'package:team_up/app/app_pallete.dart';
import 'package:team_up/db/sembast_service.dart';
import 'package:team_up/view/form_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SembastService().init();
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
      home: FormPage(),
    );
  }
}
