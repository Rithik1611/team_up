import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:team_up/models/student.dart';
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
      ProfilePage(student: _student), // Profile page
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _pageIndex,
        height: 60.0,
        animationDuration: const Duration(milliseconds: 450),
        backgroundColor: Colors.transparent,
        color: Colors.white,
        items: <Widget>[
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.add, 1),
          _buildNavItem(Icons.search_outlined, 2),
          _buildNavItem(Icons.person, 3),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _pageIndex == index ? Color.fromARGB(255, 255, 255, 255) : Colors.transparent,
      ),
      padding: EdgeInsets.all(10.0),
      child: Icon(
        icon,
        size: 24,
        color: _pageIndex == index ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
}
