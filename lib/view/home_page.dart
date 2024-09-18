import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:team_up/view/calendar_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:team_up/view/event_detail_page.dart';
import 'package:team_up/view/teamdetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List events = [];
  List teams = [];
  bool isLoading = true;

  final dataService = DataService();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    Dio dio = Dio();
    try {
      final eventsResponse = await dio
          .get('https://66e6c57517055714e58a7cc9.mockapi.io/api/v1/events');
      final teamsResponse =
          await dio.get('https://66e5b9195cc7f9b6273e2c1b.mockapi.io/teamname');

      if (!mounted) return;

      setState(() {
        events = eventsData;
        teams = teamsData;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load data: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
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
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Teams Section',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Display message if no teams available
                if (teams.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(90.0),
                    child: Text(
                      'No Teams Joined Yet',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  )
                else
                  // Carousel Slider for Team Cards
                  SizedBox(
                    height: 200, // Adjust height if needed
                    child: CarouselSlider.builder(
                      itemCount: teams.length,
                      itemBuilder: (context, index, realIndex) {
                        final team = teams[index];
                        String teamName =
                            team['name']?.toString() ?? 'No Team Name';

                        return TeamCard(
                          teamName: teamName,
                          onTap: () {
                            // Navigate to the TeamDetailPage with team data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TeamDetailPage(team: team), // Pass the team data
                              ),
                            );
                          },
                        );
                      },
                      options: CarouselOptions(
                        height: 200,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        enableInfiniteScroll: true,
                        viewportFraction: 0.8,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                const CalendarButton(),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Upcoming Events',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                // Updated Upcoming Events Section with Padding, Grey Hue, and Shadow
                Expanded(
                  child: events.isEmpty
                      ? const Center(
                          child: Text(
                            'No upcoming events',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemExtent: 95,
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            String eventName = event['eventName']?.toString() ??
                                'No Event Name';
                            String date =
                                event['eventDate']?.toString() ?? 'No Date';
                            String imageUrl = event['image']?.toString() ?? '';

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14.0,
                                vertical: 8,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to EventDetailPage when clicked
                                  String eventId =
                                      event['id']?.toString() ?? '';
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EventDetailPage(eventId: eventId),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          imageUrl.isNotEmpty
                                              ? imageUrl
                                              : 'https://via.placeholder.com/100',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              eventName,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_today,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(date),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ),
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

// Team Card Widget with onTap functionality
class TeamCard extends StatelessWidget {
  final String teamName;
  final VoidCallback onTap;

  const TeamCard({
    Key? key,
    required this.teamName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.9),
      child: InkWell(
        onTap: onTap, // InkWell with onTap
        child: Container(
          alignment: Alignment.center,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                // Display the team name
                Text(
                  teamName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 49, 0, 128),
                const Color.fromARGB(255, 7, 3, 3)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(29),
            ),
          ),
          height: 200, // Adjust height if needed
          width: MediaQuery.of(context).size.width * 0.9, // Adjust width if needed
        ),
      ),
    );
  }
}
