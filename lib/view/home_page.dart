import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  // Function to fetch data from the API using Dio
  Future<void> fetchEvents() async {
    Dio dio = Dio();

    try {
      final response = await dio.get('https://66e6c57517055714e58a7cc9.mockapi.io/api/v1/events');
      setState(() {
        events = response.data;
        isLoading = false; // Set loading to false once data is fetched
      });
    } catch (e) {
      print('Failed to load events: $e');
      setState(() {
        isLoading = false; // Stop loading even if there is an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text('Home'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading indicator
          : Column(
              children: [
                // Reserved space for the top section (Teams & Calendar)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  
                  child: Column(
                    
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 100), // Additional spacing for aesthetics
                      Text(
                        'Teams Section',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 150), // Space between sections
                      Text(
                        'Calendar Section',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20), // Additional spacing for aesthetics
                    ],
                  ),
                ),
                // Remaining space for the List of Events or No Events message
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10), // Additional spacing for aesthetics
                    Text(
                      'Upcoming Events',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: events.isEmpty
                      ? const Center(
                          child: Text(
                            'No upcoming events',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )
                      : ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];

                            // Ensure each field is converted to a string to avoid type errors
                            String eventName = event['eventName']?.toString() ?? 'No Event Name';
                            String description = event['description']?.toString() ?? 'No Description';
                            String date = event['date']?.toString() ?? 'No Date';
                            String imageUrl = event['image']?.toString() ?? ''; // Image URL or empty string

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Space around each ListTile
                              child: ListTile(
                                leading: Image.network(
                                  imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/100', // Fallback image if no image
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      'https://via.placeholder.com/100', // Fallback image if the URL fails
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                                title: Text(eventName),
                                subtitle: Text(description),
                                trailing: Text(date),
                                onTap: () {
                                  // Handle tile tap, if needed
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
