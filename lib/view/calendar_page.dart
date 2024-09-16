import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dio/dio.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List<String>> _events = {};
  List<String> _selectedEvents = [];
  bool isLoading = true;
  DateTime _focusedDay = DateTime.now(); // Initialize the focused day
  DateTime _selectedDay = DateTime.now(); // Initialize the selected day

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    Dio dio = Dio();
    try {
      final response = await dio.get('https://66e6c57517055714e58a7cc9.mockapi.io/api/v1/events');
      setState(() {
        _events.clear();
        for (var event in response.data) {
          String eventDateStr = event['eventDate'].toString();
          DateTime eventDate;

          // Handle DDMMYYYY format
          if (eventDateStr.length == 8) {
            int day = int.parse(eventDateStr.substring(0, 2));
            int month = int.parse(eventDateStr.substring(2, 4));
            int year = int.parse(eventDateStr.substring(4, 8));
            eventDate = DateTime(year, month, day);
          } 
          // Handle Unix timestamp format (seconds since epoch)
          else if (eventDateStr.length >= 10) {
            int timestamp = int.parse(eventDateStr);
            eventDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
          } 
          // Default to current date if format is unknown
          else {
            eventDate = DateTime.now();
          }

          // Normalize the date to remove time components
          DateTime normalizedDate = DateTime(eventDate.year, eventDate.month, eventDate.day);

          if (_events[normalizedDate] == null) {
            _events[normalizedDate] = [];
          }
          _events[normalizedDate]?.add(event['eventName']);
        }
        // Set the events for the initially selected day
        _selectedEvents = _events[_normalizeDate(_selectedDay)] ?? [];
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching events: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text('Calendar Page'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TableCalendar(
                  focusedDay: _focusedDay, // Pass the focused day
                  firstDay: DateTime.utc(2000, 1, 1), // Set the first day
                  lastDay: DateTime.utc(2100, 12, 31), // Set the last day
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day); // Highlight the selected day
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay; // Update focused day
                      _selectedEvents = _events[_normalizeDate(selectedDay)] ?? [];
                    });
                  },
                  eventLoader: (day) {
                    return _events[day] ?? [];
                  },
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          right: 1,
                          bottom: 1,
                          child: _buildEventsMarker(events),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _selectedEvents.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_selectedEvents[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEventsMarker(List events) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: const TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
