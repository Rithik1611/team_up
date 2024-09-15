import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List<String>> events = {}; // Map to store events with their dates
  bool isLoading = true; // Loading indicator

  @override
  void initState() {
    super.initState();
    fetchEvents(); // Fetch events when the calendar page is loaded
  }

  // Function to fetch data from the API using Dio
  Future<void> fetchEvents() async {
    Dio dio = Dio();

    try {
      final response = await dio.get(
        'https://66e6c57517055714e58a7cc9.mockapi.io/api/v1/events',
      );

      if (!mounted) return;

      setState(() {
        // Mapping the API event data to the `events` map
        events = {
          for (var event in response.data)
            DateTime.parse(event['date']): [event['eventName'].toString()]
        };

        isLoading = false; // Stop loading after data is fetched
      });
    } catch (e) {
      print('Failed to load events: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false; // Stop loading if there is an error
      });
    }
  }

  // Function to show a dialog with event details
  void _showEventDialog(String event) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Event Details'),
          content: Text(event),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text('Calendar Page'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading indicator
          : Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: DateTime.now(),
                  eventLoader: (day) {
                    // Return the events for a specific day
                    return events[day] ?? [];
                  },
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 49, 0, 128),
                      shape: BoxShape.circle,
                    ),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    // When a day is selected, show event dialog if events exist
                    if (events[selectedDay] != null && events[selectedDay]!.isNotEmpty) {
                      _showEventDialog(events[selectedDay]![0]);
                    }
                  },
                ),
                const SizedBox(height: 20),
                if (events.isEmpty)
                  const Text(
                    'No events available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
    );
  }
}

