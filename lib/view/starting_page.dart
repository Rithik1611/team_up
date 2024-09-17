import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:team_up/view/signup_page.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StartingPage(),
      ),
    );

class StartingPage extends StatefulWidget {
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
      decoration: BoxDecoration(
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
              SizedBox(height: 30),
              FadeInUp(
                duration: Duration(milliseconds: 1000),
                child: Text(
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
                child: Text(
                  "TEAM UP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 100),
              Spacer(), // This will push the button to the bottom
              FadeIn(
                duration: Duration(milliseconds: 1000),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupPage(),
                      ),
                    );
                    // Add your onPressed code here!
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white, // Text color
                    minimumSize: Size(300, 60), // Width and height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      // Width and height
                    ),
                  ),
                  child: Text('Get Started'),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
