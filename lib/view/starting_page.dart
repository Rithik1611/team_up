import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:team_up/view/signup_page.dart';

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StartingPage(),
      ),
    );

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  _StartingPageState createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity, // Ensure the image takes up full height
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/kcg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              const Color.fromARGB(255, 49, 0, 128).withOpacity(0.87),
              const Color.fromARGB(255, 49, 0, 128).withOpacity(0.11),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              FadeInUp(
                duration: Duration(milliseconds: 1000),
                child: const Text(
                  "WELCOME TO ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FadeInUp(
                duration: Duration(milliseconds: 1000),
                child: const Text(
                  "TEAM UP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 100),
              const Spacer(), // This will push the button to the bottom
              FadeIn(
                duration: const Duration(milliseconds: 1000),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ),
                        );
                        // Add your onPressed code here!
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white, // Text color
                        minimumSize: const Size(300, 60), // Width and height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          // Width and height
                        ),
                      ),
                      child: const Text(
                        'GET STARTED',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Optional: Add some space between the button and the text
                    const Text(
                      'developed by SRK',
                      style: TextStyle(
                        fontSize: 12, // Adjust the font size as needed
                        color: Colors.white, // Adjust the color as needed
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}