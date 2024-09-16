import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:url_launcher/url_launcher.dart'; // For launching URLs

class EventDetailPage extends StatefulWidget {
  final String eventId;

  const EventDetailPage({Key? key, required this.eventId}) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  Map<String, dynamic>? eventData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEventData();
  }

  Future<void> fetchEventData() async {
    Dio dio = Dio();
    try {
      final response = await dio.get(
          'https://66e6c57517055714e58a7cc9.mockapi.io/api/v1/event-page/${widget.eventId}');
      
      if (!mounted) return;

      setState(() {
        eventData = response.data;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load event details: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat.yMMMd().format(date); // Formats the date like "Sep 16, 2024"
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : eventData == null
              ? const Center(child: Text('Event details not available'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display Event Image (with fallback if image is empty)
                        eventData!['image'] != null && eventData!['image'].isNotEmpty
                            ? Image.network(
                                eventData!['image'],
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              )
                            : Image.network(
                                'https://via.placeholder.com/400',
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                        const SizedBox(height: 20),

                        // Display Event Name
                        Text(
                          eventData!['eventName'] ?? 'No Event Name',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Display Event Type
                        Text(
                          'Type: ${eventData!['eventType'] ?? 'No Event Type'}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),

                         Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Colors.grey, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              'Date: ${formatDate(eventData!['eventDate'])}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Display Event Description
                        Text(
                          eventData!['description'] ?? 'No Description',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),

                        // Display Event Date
                        
                        

                        // Display Event Link using url_launcher
                        GestureDetector(
                          onTap: () {
                            if (eventData!['eventLink'] != null) {
                              _launchURL(eventData!['eventLink']);
                            }
                          },
                          child: Text(
                            eventData!['eventLink'] ?? 'No Event Link',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
