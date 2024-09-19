import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:team_up/db/sembast_service.dart'; // Ensure you have imported this
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

  final SembastService sembastService =
      SembastService(); // Instance of SembastService

  @override
  void initState() {
    super.initState();
    fetchEventData();
  }

  Future<void> fetchEventData() async {
    String? token = await sembastService.getToken(); // Get the token
    Dio dio = Dio();

    final response = await dio.get(
      'https://kcgteamupserver-production.up.railway.app/api/event/${widget.eventId}',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token', // Add the token to the headers
        },
      ),
    );
    print(response);

    if (!mounted) return;

    setState(() {
      eventData = response.data;
      isLoading = false;
    });
  }

  // Converts eventDate from "dd/MM/yyyy" format to a readable date
  String formatDate(String eventDate) {
    // Ensure the date is in the correct format
    try {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(eventDate);
      return DateFormat.yMMMd()
          .format(parsedDate); // Format to readable format, e.g., Sep 17, 2024
    } catch (e) {
      return "Invalid Date"; // Return error text if format is wrong
    }
  }

  // Opens URL in the browser
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the URL')),
      );
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
                        eventData!['eventPoster'] != null &&
                                eventData!['eventPoster'].isNotEmpty
                            ? Image.network(
                                eventData!['eventPoster'],
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

                        // Display Event Date
                        if (eventData!['eventDate'] != null)
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Colors.grey, size: 18),
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
                          eventData!['eventDes'] ?? 'No Description',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),

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
