import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:team_up/app/app_pallete.dart';
import 'package:team_up/view/calendar_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List events = [];
  List teams = [];
  bool isLoading = true;

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
        events = eventsResponse.data;
        teams = teamsResponse.data;
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
                      SizedBox(height: 10), // Adjust spacing here
                    ],
                  ),
                ),
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
                // Calendar Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the Calendar Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CalendarPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppPallete.primary,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(91, 0, 0, 0),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            size: 40,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Calendar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              Text(
                                'Plan Your Events!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10),
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ListView.builder(
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
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: ListTile(
                                leading: Image.network(
                                  imageUrl.isNotEmpty
                                      ? imageUrl
                                      : 'https://via.placeholder.com/100',
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
                                title: Text(eventName),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
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

// Team Card Widget
class TeamCard extends StatelessWidget {
  final String teamName;

  const TeamCard({
    Key? key,
    required this.teamName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.9),
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
          color: Color.fromARGB(190, 49, 0, 128),
          borderRadius: BorderRadius.all(
            Radius.circular(29),
          ),
        ),
        height: 200, // Adjust height if needed
        width:
            MediaQuery.of(context).size.width * 0.9, // Adjust width if needed
      ),
    );
  }
}
