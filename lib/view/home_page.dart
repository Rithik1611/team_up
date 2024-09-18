import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_up/db/sembast_service.dart';
import 'package:team_up/view/calendar_page.dart';
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    Dio dio = Dio();
    SembastService sembastService = SembastService();

    try {
      // Retrieve token from SembastService
      final token = await sembastService.getToken();

      // Add token to headers if available
      final options = Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );
      final teamsResponse = await dio.get(
        'https://kcgteamupserver-production.up.railway.app/api/team/getUserTeams',
        options: options,
      );
      print(teamsResponse.data);
      // Fetch events
      final eventsResponse = await dio.get(
        'https://kcgteamupserver-production.up.railway.app/api/event/all',
        options: options,
      );

      // Fetch teams

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
                    height: 200,
                    child: CarouselSlider.builder(
                      itemCount: teams.length,
                      itemBuilder: (context, index, realIndex) {
                        final team = teams[index];
                        String teamName =
                            team['teamName']?.toString() ?? 'No Team Name';
                        String teamId =
                            team['teamId']?.toString() ?? ''; // Get teamId

                        return TeamCard(
                          teamName: teamName,
                          teamId: teamId, // Pass teamId
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TeamDetailPage(
                                  teamId: teamId, // Pass teamId
                                ),
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
                        color: Colors.white,
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
                            color: Color.fromARGB(255, 0, 0, 0),
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
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Plan Your Events!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
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

class TeamCard extends StatelessWidget {
  final String teamName;
  final String teamId; // Add this line
  final VoidCallback onTap;

  const TeamCard({
    Key? key,
    required this.teamName,
    required this.teamId, // Add this line
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.9),
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
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
          height: 200,
          width: MediaQuery.of(context).size.width * 0.9,
        ),
      ),
    );
  }
}
