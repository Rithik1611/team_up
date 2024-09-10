import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<DateTime, int> dateMap = {};
  // Define the start and end dates
  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime endDate = DateTime(DateTime.now().year, 12, 31);

  // Populate the dateMap with real data
  void populateDateMap() {
    DateTime now = DateTime.now();
    dateMap = {
      DateTime(now.year, now.month, now.day): 1,
      DateTime(now.year, now.month, now.day - 1): 2,
      DateTime(now.year, now.month, now.day - 2): 3,
      // Add more dates and their associated values here
    };
  }

  @override
  void initState() {
    populateDateMap(); // Call this to populate dateMap with your actual data
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text('Home'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Welcome to the Home Page!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: HeatMap(
                    datasets: dateMap,
                    startDate: startDate,
                    endDate: endDate,
                    textColor: const Color.fromARGB(255, 0, 0, 0),
                    defaultColor: const Color.fromARGB(255, 78, 78, 78),
                    colorMode: ColorMode.opacity,
                    showText: false,
                    scrollable: true,
                    showColorTip: false,
                    colorsets: const {
                      1: Color(0xffB0B0B0), // Light gray
                      2: Color.fromARGB(255, 255, 0, 0), // Medium gray
                      3: Color.fromARGB(255, 255, 0, 0), // Dark gray
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}