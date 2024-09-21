import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // For date formatting and parsing
import 'package:team_up/db/sembast_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List<String>> _events = {};
  List<String> _selectedEvents = [];
  bool isLoading = true;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final SembastService sembastService = SembastService(); // Create an instance of SembastService

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    Dio dio = Dio();
    final token = await sembastService.getToken();

    final response = await dio.get(
      'https://kcgteamupserver-production.up.railway.app/api/event/all',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    setState(() {
      _events.clear();
      for (var event in response.data) {
        String eventDateStr = event['eventDate'].toString();
        DateTime eventDate;

        try {
          // Parse the eventDate string into DateTime object
          eventDate = DateTime.parse(eventDateStr);

          // Format the parsed date to 'dd-MM-yyyy'
          String formattedDate = DateFormat('dd-MM-yyyy').format(eventDate);
          print(formattedDate); // This will print the date in dd-MM-yyyy format

          // Normalize the date to remove time components
          DateTime normalizedDate = _normalizeDate(eventDate);

          if (_events[normalizedDate] == null) {
            _events[normalizedDate] = [];
          }
          _events[normalizedDate]?.add('${event['eventName']} - $formattedDate');
        } catch (e) {
          print('Error parsing date: $e');
        }
      }
      _selectedEvents = _events[_normalizeDate(_selectedDay)] ?? [];
      isLoading = false;
    });
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
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _selectedEvents = _events[_normalizeDate(selectedDay)] ?? [];
                    });
                  },
                  eventLoader: (day) {
                    // Return events only for the selected day
                    return _events[_normalizeDate(day)] ?? [];
                  },
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
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
                  child: _selectedEvents.isEmpty
                      ? const Center(child: Text('No events for this day'))
                      : ListView.builder(
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
        color: const Color.fromARGB(171, 232, 125, 223),
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
