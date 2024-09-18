import 'package:flutter/material.dart';
import 'package:team_up/view/event_detail_page.dart';

class EventsList extends StatelessWidget {
  final List events;

  const EventsList({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return events.isEmpty
        ? const Center(
            child: Text(
              'No upcoming events',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            itemExtent: 95,
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              String eventName = event['eventName']?.toString() ?? 'No Event Name';
              String date = event['eventDate']?.toString() ?? 'No Date';
              String imageUrl = event['image']?.toString() ?? '';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
                child: GestureDetector(
                  onTap: () {
                    String eventId = event['id']?.toString() ?? '';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage(eventId: eventId),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(10, 0, 0, 0),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/100',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                'https://via.placeholder.com/100',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eventName,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(date),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
