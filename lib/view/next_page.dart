import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:team_up/models/student.dart';
import 'package:team_up/view/edit_page.dart';
import 'package:team_up/view/home_page.dart';  // Import your HomePage, AddPage, and SearchPage
import 'package:team_up/view/add_page.dart';
import 'package:team_up/view/profile_page.dart';
import 'package:team_up/view/search_page.dart';

class NextPage extends StatefulWidget {
  final Student student;

  const NextPage({super.key, required this.student});

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  late Student _student;
  int _pageIndex = 3; // Start with Profile page as selected

  final List<Widget> _pages = []; // Will be initialized in initState

  @override
  void initState() {
    super.initState();
    _student = widget.student;

    // Initialize the pages
    _pages.addAll([
      HomePage(),  // Replace with your actual HomePage
      AddPage(),   // Replace with your actual AddPage
      SearchPage(), // Replace with your actual SearchPage
      ProfilePage(student: _student,), // Profile page
    ]);
  }

  // Profile page content
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _pageIndex,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.person, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.purple,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
