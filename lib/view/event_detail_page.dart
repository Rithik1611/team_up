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

  // Converts eventDate from "dd/MM/yyyy" format to "dd-MM-yyyy"
  String formatDate(String eventDate) {
    try {
      // First, try parsing with the expected format from the API
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(eventDate);

      // Format the parsed date into 'dd-MM-yyyy'
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      try {
        // In case the format is not as expected, try parsing it in another format
        DateTime parsedDate = DateTime.parse(eventDate);

        // Format the parsed date into 'dd-MM-yyyy'
        return DateFormat('dd-MM-yyyy').format(parsedDate);
      } catch (e) {
        return "Invalid Date"; // Return error if both parsing attempts fail
      }
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
        elevation: 0,
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
                        // Display Event Image with rounded corners and shadow
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: eventData!['eventPoster'] != null &&
                                    eventData!['eventPoster'].isNotEmpty
                                ? Image.network(
                                    eventData!['eventPoster'],
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const Icon(Icons.error);
                                    },
                                  )
                                : Image.network(
                                    'https://via.placeholder.com/400',
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Display Event Name with a stylish font
                        Text(
                          eventData!['eventName'] ?? 'No Event Name',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Color.fromARGB(255, 49, 0, 128),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Display Event Type with a subtle background
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Event Type: ${eventData!['eventType'] ?? 'No Event Type'}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Display Event Date with an elegant icon
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
                                  color: Color.fromARGB(255, 49, 0, 128),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 20),

                        // Display Event Description with a title "Description:"
                        const Text(
                          'Description:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 49, 0, 128),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          eventData!['eventDes'] ?? 'No Description',
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Register Button for launching URL
                        if (eventData!['eventLink'] != null)
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                _launchURL(eventData!['eventLink']);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 49, 0, 128), // Button color
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
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
